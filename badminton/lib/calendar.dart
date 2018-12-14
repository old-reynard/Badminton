import 'package:flutter/material.dart';
import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';
import 'package:badminton/UI/backdrop.dart';

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
      value: 0.0
    );
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
      body: Backdrop(controller: controller, backLayer: calendarGrid(),),
      bottomNavigationBar: BadWidgets.bottomBar(),
    );
  }

  Widget calendarGrid() {

    Color color;

    List<Widget> grid = <Widget>[];
    if (available != null) {
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
    }

    return SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: grid,
          ),
        ),
      );
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
      leading: new IconButton(
        onPressed: () {
          controller.fling(velocity: isBackdropVisible ? -1.0 : 1.0);
        },
        icon: new AnimatedIcon(
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
    if (available != null) {
      var dates = available.keys. toList();
      for (int i = 0; i < BadSizes.cellsPerScreen; i++) {
        DateTime date = dates[i];
        header.add(CellHeader(date: date.day, day: date.weekday.toString(),));
      }
    }
    return header;
  }
}

