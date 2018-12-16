import 'package:flutter/material.dart';
import 'dart:convert';

import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';
import 'package:badminton/UI/backdrop.dart';
import 'services/utils.dart';



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
  DateTime currentDate = DateTime.now().subtract(Duration(days: 1));

//  String _calendarData;


  List<String> subtypes = <String>[];
  List<String> services = <String>[];
  String currentSubtype;
  String currentService;

  @override
  void initState() {
    super.initState();
    widget._calendarService.availability().then((json) {
      setState(() {
        available = json;
        _getSubtypes();
        _getServices();
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
//        print(available);
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
      body: Backdrop(controller: controller, backLayer: calendarGrid()),
      bottomNavigationBar: BadWidgets.bottomBar(),
    );
  }

  Widget calendarGrid() {
    List<String> labels = _getTimeLabels();
    List<Widget> timeLabelHeaders = _getTimeHeaders(labels);
    int min = (BadSizes.cellsPerScreen < labels.length)
        ? BadSizes.cellsPerScreen
        : labels.length;

    List<Widget> grid = <Widget>[];



    for (int i = 0; i < min; i++) {
      String timeSlot = labels[i];
      List<Widget> line = <Widget>[];

      if (available != null) {
        var trackDate = currentDate;
        var slots = available[slotsKey];

        for (var slot in slots) {
          var date = DateTime.parse(slot[dateKey]);

          if (trackDate.isBefore(date)) {
            while(!Utils.isSameDay(date, trackDate)) {
              int available = 0;
              int blocked = 1;
              int total = 1;

              Map info = {
                availableKey:available,
                blockedKey: blocked,
                totalSlotKey: total,
                visibleKey: true,
              };
              line.add(BadWidgets.calendarCell(slot: info));
              trackDate = trackDate.add(Duration(days: 1));
            }
          }

          // found today
          if (Utils.isSameDay(trackDate, date)) {
            var slotList = slot[slotListKey];
            for (var booking in slotList) {
              String startTime = booking[startTimeKey];
              if (timeSlot == startTime) {
                int available = booking[availableKey];
                int booked = booking[bookedKey];
                int blocked = booking[blockedKey];
                int total = booking[totalSlotKey];

                Map info = {
                  availableKey:available,
                  bookedKey: booked,
                  blockedKey: blocked,
                  totalSlotKey: total,
                  startTimeKey: startTime,
                  visibleKey: true,
                  callbackKey: _handleBackdrop
                };

                line.add(BadWidgets.calendarCell(slot: info));
                trackDate = trackDate.add(Duration(days: 1));
              }
            }
          }
        }
      }
      grid.add(Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        mainAxisSize: MainAxisSize.max,
        children: [timeLabelHeaders[i]] + line,
      ));
    }

    return Container(
        child: Center(
      child: Column(
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
      elevation: 8.0,
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
    var dates = _getDates();
    int min = (BadSizes.cellsPerScreen < dates.length)
        ? BadSizes.cellsPerScreen
        : dates.length;
    for (int i = 0; i < min; i++) {
      DateTime date = DateTime.parse(dates[i]);
      header.add(CellHeader(date: date,));
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

  List<String> _getDates() {
    List<String> dates = <String>[];

    if (available != null) {
      var slots = available[slotsKey];
      for (var slot in slots) {
        String date = slot[dateKey];
        dates.add(date);
      }
    }
    return dates;
  }

  void _handleBackdrop() => controller.fling(velocity: isBackdropVisible ? -1.0 : 1.0);

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

}
