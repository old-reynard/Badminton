import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';


class BadColors {
  static const Color accent = Color(0xFFAF3132);
  static const Color buttonAccent = Color(0xFFF8B34B);
  static const Color main = Color(0xFF7CDE5A);
  static const Color dark = Color(0xFF257D06);
  static const Color black = Color(0xFF000000);
  static const Color empty = Color(0xFFE5E5E5);
  static const Color background = Color(0xFFF8F8F8);

}

class BadStrings {
  static final String appTitle = 'Badminton Booking';

  // Calendar page

  // bottom navigation bar
  static final String calendarNavBarTitle = 'Calendar'.toUpperCase();
  static final String reportsNavBarTitle = 'Reports'.toUpperCase();
  static final String crmNavBarTitle = 'CRM'.toUpperCase();
  static final String settingsNavBarTitle = 'Setiings'.toUpperCase();
  static const String gridFull = 'Full';
}


class BadSizes {

  // Calendar page
  static final double navBarIcons = 20;
  static final double navBarTitles = 9;

  // Calendar cell dimensions
  static final double cellWidth = 82;
  static const double cellHeight = 60;
  static final double cellPadding = 1;

  static final int cellsPerScreen = 5;

  // backdrop
  static final int backdropDuration = 100;
  static const double headerHeight = 50;
  static const double headerBorderRadius = 10;
  static const double backdropHeight = 375;

}


class BadStyles {

  static final TextStyle navBarStyle =
  TextStyle(fontSize: BadSizes.navBarTitles);
}


class BadIcons {

  static final String assetCalendarLoc = 'assets/calendar';

  static final String calendarIconLoc = 'assets/calendar/Calendar.svg';
  static final String reportsIconLoc = assetCalendarLoc + '/Reports.svg';
  static final String crmIconLoc = assetCalendarLoc + '/Customers.svg';
  static final String settingsIconLoc = assetCalendarLoc + '/Settings.svg';


  static final calendarIcon = SvgPicture.asset(
    calendarIconLoc,
    height: 40,
    width: 40,
    color: BadColors.black,
  );
}