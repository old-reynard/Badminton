import 'package:flutter/material.dart';

import 'package:badminton/data/contract.dart';

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

  static Widget calendarCell({Color color: BadColors.main, int available, String text : BadStrings.gridFull}) {
    return Cell(color: color, text: text,);
  }
}


class Cell extends StatefulWidget {

  final Color color;
  final int available;
  final String text;

  Cell({this.color, this.available, this.text});

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {


  double height = BadSizes.cellHeight;
  double width = BadSizes.cellWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.all(BadSizes.cellPadding),
        child: Material(
          color: widget.color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            child: Center(
              child: Text(widget.text),
            )
          ),
        )
      ),
    );
  }
}

class CellHeader extends StatefulWidget {
  final int date;
  final String day;
  final String arrow;

  CellHeader({this.date, this.day, this.arrow});

  @override
  _CellHeaderState createState() => _CellHeaderState();
}

class _CellHeaderState extends State<CellHeader> {

  double width = BadSizes.cellWidth;
  double height = BadSizes.cellHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Material(
        color: BadColors.background,
        child: Column(
          children: <Widget>[
            Text(widget.day),
            Text(widget.date.toString()),
          ],
        ),
      ),
    );
  }
}