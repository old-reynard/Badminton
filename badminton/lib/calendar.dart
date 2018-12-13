import 'package:flutter/material.dart';
import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';

class CalendarPage extends StatefulWidget {

  final CalendarService _calendarService;

  CalendarPage(this._calendarService);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}


class _CalendarPageState extends State<CalendarPage> {

  Map available;


  @override
  void initState() {
    super.initState();
    available = widget._calendarService.availability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
             children: calendarGrid(),
          ),
        ),
      ),
      bottomNavigationBar: BadWidgets.bottomBar(),
    );
  }

  List<Widget> calendarGrid() {

    Color color;

    List<Widget> grid = <Widget>[];
    var dates = available.keys.toList();
    for (int i = 0; i < BadSizes.cellsPerScreen; i++) {
      color = (i == 0 ? BadColors.background : BadColors.main);
      var date = dates[i];
      grid.add(
          Column(
            children: fromDate(available[date], color),
          )
      );
    }

    return grid;
  }

  List<Widget> fromDate(Map date, Color color) {
    List<Widget> buttons = <Widget>[];
    var times = date.keys.toList();
    for (int i = 0; i < times.length; i++) {
      var time = times[i];
      buttons.add(
        BadWidgets.calendarCell(
          available: date[i],
          text: time,
          color: color
        )
      );
    }
    return buttons;
  }

  Widget _appBar() {
    return AppBar(
      elevation: 8.0,
      backgroundColor: BadColors.background,
      bottom: PreferredSize(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _populateHeader(),
          ),
          preferredSize: Size.fromHeight(BadSizes.cellHeight),
      ),
    );
  }

  List<Widget> _populateHeader() {
    List<Widget> header = <Widget>[];
    var dates = available.keys. toList();
    for (int i = 0; i < BadSizes.cellsPerScreen; i++) {
      DateTime date = dates[i];
      header.add(CellHeader(date: date.day, day: date.weekday.toString(),));
    }
    return header;
  }
}

