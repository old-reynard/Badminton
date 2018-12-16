import 'package:flutter/material.dart';

import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';
import 'package:badminton/UI/backdrop.dart';
import 'services/utils.dart';


//import 'package:backdrop/backdrop.dart';

const String slotsKey = 'slots';
const String dateKey = 'date';
const String slotListKey = 'slot_list';
const String startTimeKey = 'start_time';
const String endTimeKey = 'end_time';
const String totalSlotKey = 'total_slot';
const String availableKey = 'available';
const String bookedKey = 'booked';
const String blockedKey = 'blocked';
const String labelKey = 'label';
const String visibleKey = 'visible';


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
  DateTime currentDate = DateTime.now();
  String test;

  @override
  void initState() {
    super.initState();
    widget._calendarService.availability().then((json) {
      setState(() {
        available = json;
      });
    });

    controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: BadSizes.backdropDuration),
        value: 0.0);

    widget._calendarService.getData().then((response) {
      setState(() {
        test = response;
        print('Badminton ' + test);
      });
    });
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
              int available = 1;
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
    return AppBar(
      leading: IconButton(
        onPressed: () {
          controller.fling(velocity: isBackdropVisible ? -1.0 : 1.0);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: controller.view,
        ),
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
      header.add(CellHeader(
        date: date.day,
        day: date.weekday.toString(),
      ));
    }
    return header;
  }

  /// business logic

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
    List<Widget> headers = <Widget>[];
    for (String label in labels) {
      Map info = {startTimeKey: label, labelKey: true, visibleKey: true};
      headers.add(BadWidgets.calendarCell(slot: info));
    }
    return headers;
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
}
