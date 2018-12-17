import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';
import 'package:badminton/UI/backdrop.dart';
import 'services/utils.dart';

typedef DateAssigner = void Function(String date, String time);

class CalendarPage extends StatefulWidget {
  final CalendarService _calendarService;

  CalendarPage(this._calendarService);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Map available;
//  DateTime currentDate = DateTime.now().subtract(Duration(days: 5));
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';

  List<String> subtypes = <String>[];
  List<String> services = <String>[];
  String currentSubtype;
  String currentService;

  List<DateTime> _dates = <DateTime>[];

  @override
  void initState() {
    super.initState();
    widget._calendarService.availability().then((json) {
      setState(() {
        available = json;
        _getSubtypes();
        _getServices();
        _getDates();
        _fillDateGaps();
      });
    });

    controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: BadSizes.backdropDuration),
        value: 0.0);

//    widget._calendarService.getCalendarData().then((response) {
//      setState(() {
//        available = json.decode(response);
//        _getSubtypes();
//        _getServices();
//        _getDates();
//        _fillDateGaps();
//      });
//    });

//    widget._calendarService.getSlotData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool get isBackdropVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Backdrop(
        controller: controller,
        backLayer: calendarGrid(),
        serviceId: 174,
        date: selectedDate,
        calendarService: widget._calendarService,
        time: selectedTime,
      ),
      bottomNavigationBar: BadWidgets.bottomBar(),
    );
  }

  Widget calendarGrid() {
    List<String> labels = _getTimeLabels();
    List<Widget> timeLabelHeaders = _getTimeHeaders(labels);

    int horMin = (BadSizes.cellsPerScreen < _dates.length)
        ? BadSizes.cellsPerScreen
        : _dates.length;

    List<Widget> grid = <Widget>[];
    List<List<Widget>> array = List.generate(labels.length, (i) =>
      List.generate(horMin, (j) => null));

    if (available != null) {
      var slots = available[slotsKey];
      for (var slot in slots) {
        var date = DateTime.parse(slot[dateKey]);
        if (Utils.isSameDay(currentDate, date) || date.isAfter(currentDate)) {
          var slotList = slot[slotListKey];
          for (var booking in slotList) {
            String startTime = booking[startTimeKey];
            int available = booking[availableKey];
            int booked = booking[bookedKey];
            int blocked = booking[blockedKey];
            int total = booking[totalSlotKey];

            Map info = {
              availableKey: available,
              dateKey: date,
              bookedKey: booked,
              blockedKey: blocked,
              totalSlotKey: total,
              startTimeKey: startTime,
              visibleKey: true,
              callbackKey: _handleBackdrop(date, startTime),
            };

            array[labels.indexOf(startTime)][_findDateIndex(date) + 1]
              = BadWidgets.calendarCell(slot: info,);
          }
        }
      }
    }
    _fillHeaders(array, timeLabelHeaders);
    _fillGridGaps(array);

    for (int k = 0; k < array.length; k++) {grid.add(Row(children: array[k],));}

    return Container(
        child: Center(
      child: ListView(
        children: grid,
      ),
    ));
  }

  Widget _appBar() {

    Widget rightDropdown = Container();

    if (available != null && available[multiServiceKey] == 1
        && services.length != 0 && services.isNotEmpty)
      rightDropdown = _chooseServiceDropDown();
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _chooseSubtypeDropDown(),
          rightDropdown,
        ],
      ),
      elevation: 2.0,
      backgroundColor: BadColors.background,
      bottom: PreferredSize(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _populateHeader(),
        ),
        preferredSize: Size.fromHeight(BadSizes.cellHeight),
      ),
    );
  }

  List<Widget> _populateHeader() {
    List<Widget> header = <Widget>[];
    int min = (BadSizes.cellsPerScreen - 1 < _dates.length)
        ? BadSizes.cellsPerScreen - 1
        : _dates.length;
    header.add(MonthCell(currentDate));

    for (int i = 0; i < min; i++) {
      header.add(CellHeader(date: _dates[i],));
    }


    return header;
  }

  List<String> _getTimeLabels() {
    List<String> timeLabels = <String>[];

    if (available != null) {
      var slots = available[slotsKey];
      for (var slot in slots) {
        var slotList = slot[slotListKey];
        for (var item in slotList) {
          timeLabels.add(item[startTimeKey]);
        }
      }
      timeLabels.sort();
      timeLabels = timeLabels.toSet().toList();
    }
    return timeLabels;
  }

  List<Widget> _getTimeHeaders(List<String> labels) {
    return labels.map((String label) => BadWidgets.calendarCell(
      slot: {startTimeKey: label, labelKey: true, visibleKey: true},
    )).toList();
  }

  List<DateTime> _getDates() {
//    List<DateTime> dates = <DateTime>[];
    if (available != null) {
      var slots = available[slotsKey];
      for (var slot in slots) {

        DateTime date = DateTime.parse(slot[dateKey]);

        if (date.isAfter(currentDate) ||
          Utils.isSameDay(date, currentDate)) _dates.add(date);
      }

      if (_dates.length > 0) {
        while (_dates.length != BadSizes.cellsPerScreen - 1) {
          int days = 1;
          _dates.add(_dates[_dates.length - 1].add(Duration(days: days)));
          days++;
        }
      }
    }
    return _dates;
  }

  DateAssigner _handleBackdrop(date, time) {
    return (date, time) {
      controller.fling(velocity: isBackdropVisible ? -1.0 : 1.0);
      setState(() {
        selectedDate = DateTime.parse(date);
        selectedTime = time;
      });
    };
  }

  void _getSubtypes() {
    var subtypes = available[subtypeListKey];
    for (var subtype in subtypes) {
      this.subtypes.add(subtype[nameKey]);
    }
  }

  void _getServices() {
    var serviceList = available[servicesListKey];
    for (var service in serviceList) {
      services.add(service[inventoryNameKey]);
    }
  }

  Widget _chooseSubtypeDropDown() {
    if (subtypes == null || subtypes.length == 0)
      return Container();
    else {
      final List<DropdownMenuItem<String>> items = subtypes
          .map((String s) => '${s[0].toUpperCase()}${s.substring(1)}')
          .map((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value, style: TextStyle(fontSize: 16, fontWeight:FontWeight.bold),),
      ))
          .toList();
      return DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton(
            isDense: true,
            items: items,
            value: currentSubtype == null ? null : currentSubtype,
            onChanged: (String newValue) {
              setState(() {
                currentSubtype = newValue;
              });
            },
          ),
        ),
      );
    }
  }

  Widget _chooseServiceDropDown() {
    if (services == null || services.length == 0)
      return Container();
    else {
      List<DropdownMenuItem<String>> items = services
          .map((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value == null ? '' : value),
      ))
          .toList();
      return DropdownButtonHideUnderline(
        child: DropdownButton(
            isDense: true,
            items: items,
            value: currentService == null ? null : currentService,
            onChanged: (String value) {
              setState(() {
                currentService = value;
              });
            }),
      );
    }
  }

  void _fillDateGaps() {
    for (int i = 0; i < _dates.length - 1; i++) {
      var thisDate = _dates[i];
      var nextDate = thisDate.add(Duration(days: 1));
      while (!Utils.isSameDay(nextDate, _dates[i + 1])) {
        _dates.insert(i + 1, nextDate);
        nextDate.add(Duration(days: 1));
      }
    }
  }

  int _findDateIndex(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    var formatted = formatter.format(date);

    for (int i = 0; i < _dates.length; i++) {
      if (formatted ==  formatter.format(_dates[i])) return i;
    }
    return -1;
  }

  void _fillGridGaps(List<List<Widget>> grid) {
    for (int row = 0; row < grid.length; row++) {
      for (int col = 0; col < grid[0].length; col++) {
        if (grid[row][col] == null) {
          int available = 0;
          int blocked = 1;
          int total = 1;

          Map info = {
            availableKey:available,
            blockedKey: blocked,
            totalSlotKey: total,
            visibleKey: true,
          };
          grid[row][col] = BadWidgets.calendarCell(slot: info);
        }
      }
    }
  }

  void _fillHeaders(List<List<Widget>> grid, List<Widget> headers) {
    if (grid != null && grid.isNotEmpty && available != null) {
      for (int row = 0; row < grid.length; row++) {
        grid[row][0] = headers[row];
      }
    }
  }
}
