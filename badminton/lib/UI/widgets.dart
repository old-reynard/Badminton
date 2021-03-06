import 'package:flutter/material.dart';

import 'package:badminton/data/contract.dart';
import 'package:badminton/services/utils.dart';
import 'package:badminton/calendar.dart';

class BadWidgets {

  static Widget bottomBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today, size: BadSizes.navBarIcons,), //BadIcons.calendarIcon,
          title: Text(
            BadStrings.calendarNavBarTitle,
            style: BadStyles.navBarStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sort, size: BadSizes.navBarIcons,),
          title: Text(
            BadStrings.reportsNavBarTitle,
            style: BadStyles.navBarStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: BadSizes.navBarIcons,),
          title: Text(
            BadStrings.crmNavBarTitle,
            style: BadStyles.navBarStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, size: BadSizes.navBarIcons,),
          title: Text(
            BadStrings.settingsNavBarTitle,
            style: BadStyles.navBarStyle,
          ),
        ),
      ],
    );
  }

  static Widget submitButton(String text, VoidCallback onClick) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Material(
            elevation: 2.0,
            color: BadColors.accent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BadSizes.buttonBorderRadius)
            ),
            child: FlatButton(
              onPressed: onClick,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                child: Text(text, style: BadStyles.buttonTextStyle,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget calendarCell({Map slot}) =>
      Cell(slot: slot,);
}


class Cell extends StatefulWidget {

  final Map slot;

  Cell({this.slot});

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {

  //  Green - if total_slot = available
  //  Orange - if 50% of total_slot > available (handle decimals)
  //  Full - if total_slot = booked or if total_slot = booked+blocked (where booked > 0)
  //  Blocked sign - if total_Slot = blocked
  Color color;
  Widget kid;

  double height = BadSizes.cellHeight;
  double width = BadSizes.cellWidth;

  @override
  Widget build(BuildContext context) {

    final DateTime date = widget.slot[dateKey];
    final int available = widget.slot[availableKey];
    final int booked = widget.slot[bookedKey];
    final int blocked = widget.slot[blockedKey];
    final int total = widget.slot[totalSlotKey];
    bool label = widget.slot[labelKey];
    DateAssigner callback = widget.slot[callbackKey];
    label = label ?? false;
    final String startTime = widget.slot[startTimeKey];
    bool visible = widget.slot[visibleKey];
    visible = visible ?? false;
    final double opacity = visible ? 1.0 : 0.0;


    color = _getColor(available, booked, blocked, total, label);
    kid = _getChild(total, booked, blocked, available, label, startTime);

    return Container(
      width: width,
      height: height,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: EdgeInsets.all(BadSizes.cellPadding),
          child: Material(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: GestureDetector(
              onTap: () => callback(date.toString(), startTime),
              child: InkWell(
                child: Center(
                  child: kid,
                )
              ),
            ),
          )
        ),
      ),
    );
  }

  Color _getColor(int available, int booked, int blocked, int total, bool label) {
    Color color;
    if (label) {
      color = BadColors.background;
    } else {
      if (total != 0 && total != null && total == available) color = BadColors.main;
      else if (total / 2 < available) color = BadColors.buttonAccent;
      else color = BadColors.empty;
    }
    return color;
  }

  Widget _getChild(int total, int booked, int blocked, int available, bool label, String time) {
    Widget kid;

    if (label) {
      kid = Text(time);
    } else {
      if (total == blocked) {
        kid = Icon(Icons.block);
      } else if (total == booked + blocked) {
        kid = Text(BadStrings.gridFull);
      } else {
        kid = Text("$available Availabe");
      }
    }

    return kid;
  }

}

class CellHeader extends StatefulWidget {
  final DateTime date;
  final String arrow;

  CellHeader({this.date, this.arrow});

  @override
  _CellHeaderState createState() => _CellHeaderState();
}

class _CellHeaderState extends State<CellHeader> {

  double width = BadSizes.cellWidth;
  double height = BadSizes.cellHeight;

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = '';
    if (Utils.isSameDay(widget.date, DateTime.now())) dayOfWeek = 'Today';
    else if (Utils.isSameDay(widget.date, DateTime.now().add(Duration(days: 1))))
      dayOfWeek = 'Tom';
    else dayOfWeek = BadStrings.week[widget.date.weekday - 1];


    return Container(
      width: width,
      height: height,
      child: Material(
        color: BadColors.background,
        child: Column(
          children: <Widget>[
            Text(dayOfWeek, style: BadStyles.headerWeekdayStyle,),
            Text(widget.date.day.toString(), style: BadStyles.headerDayStyle,),
          ],
        ),
      ),
    );
  }
}

class MonthCell extends StatelessWidget {

  final DateTime date;

  MonthCell(this.date);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: BadSizes.cellWidth,
      height: BadSizes.cellHeight,
      child: Material(
        color: BadColors.background,
        child: Column(
          children: <Widget>[
            Text(BadStrings.year[date.month - 1], style: BadStyles.monthCellStyle,),
            Text(date.year.toString(), style: BadStyles.monthCellStyle,),
          ],
        ),
      ),
    );
  }
}