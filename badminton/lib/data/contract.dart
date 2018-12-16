import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

const String slotsKey = 'slots';
const String dateKey = 'date';
const String slotListKey = 'slot_list';
const String startTimeKey = 'start_time';
const String endTimeKey = 'end_time';
const String totalSlotKey = 'total_slot';
const String slotNameKey = 'slot_name';
const String availableKey = 'available';
const String bookedKey = 'booked';
const String blockedKey = 'blocked';
const String labelKey = 'label';
const String visibleKey = 'visible';
const String servicesListKey = 'services_list';
const String inventoryNameKey = 'inventory_name';
const String subtypeListKey = 'subtype_list';
const String nameKey = 'name';
const String callbackKey = 'callback';
const String multiServiceKey = 'multi_service';



class BadColors {
  static const Color accent = Color(0xFFAF3132);
  static const Color buttonAccent = Color(0xFFF8B34B);
  static const Color main = Color(0xFF7CDE5A);
  static const Color dark = Color(0xFF257D06);
  static const Color black = Color(0xFF000000);
  static const Color empty = Color(0xFFE5E5E5);
  static const Color background = Color(0xFFF8F8F8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color expansionTile = Color(0xFFDADADA);
  static const Color inactive = Color(0xFF918F8F);



}

class BadStrings {
  static final String appTitle = 'Badminton Booking';

  // Calendar page

  // bottom navigation bar
  static final String calendarNavBarTitle = 'Calendar'.toUpperCase();
  static final String reportsNavBarTitle = 'Reports'.toUpperCase();
  static final String crmNavBarTitle = 'CRM'.toUpperCase();
  static final String settingsNavBarTitle = 'Settings'.toUpperCase();
  static const String gridFull = 'Full';

  // Booking Details page

  static final String appBarTitle = 'Booking Details';
  static final String purpose = 'Purpose *: ';
  static final String name = 'Name *: ';
  static final String fullName = 'Full Name';
  static final String selectContact = 'Select Contact';
  static final String sendSMS = 'Send FREE Confirmation SMS';
  static final String mobile = 'Mobile: ';
  static final String submit = 'Submit';

  static final String booking = 'Booking';
  static final String blocking = 'Blocking';

  // Multiple blocking page

  static final String blockingNote = 'Blocking disallows users to block specified dates';
  static final String block = 'Block';
  static final String unblock = 'Unblock';
  static final String from = 'From';
  static final String to = 'To';
  static final String date = 'Date*: ';
  static final String time = 'Time*: ';
  static final String maintenance = 'Maintenance';
  static final String holiday = 'Holiday';
  static final String academy = 'Academy';
  static final String userBooking = 'User Booking';

  static final List<String> week = <String>[
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];



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
  static final double headerWeekdaySize = 10;
  static final double headerDaySize = 18;


  // Backdrop
  static final int backdropDuration = 100;
  static const double headerHeight = 50;
  static const double headerBorderRadius = 10;
  static const double backdropHeight = 375;

  // Details page

  static const double appBarTitle = 17;
  static const double buttonBorderRadius = 8;
  static const double buttonWidth = 312;
  static const double buttonHeight = 42;
  static const double labelSize = 12;
  static const double buttonTextSize = 16;

  // Multiple blocking page
  static const double multipleTextSize = 15;


}


class BadStyles {

  static final TextStyle navBarStyle =
    TextStyle(fontSize: BadSizes.navBarTitles);

  static final TextStyle appBarStyle =
    TextStyle(fontSize: BadSizes.appBarTitle,
        color: BadColors.black, fontWeight: FontWeight.bold);

  static final TextStyle appBarStyleInactive =
  TextStyle(fontSize: BadSizes.appBarTitle,
      color: BadColors.inactive, fontWeight: FontWeight.bold);

  static final TextStyle labelStyle =
    TextStyle(fontSize: BadSizes.labelSize);

  static final TextStyle buttonTextStyle =
    TextStyle(fontSize: BadSizes.buttonTextSize, color: BadColors.white,
      fontWeight: FontWeight.bold);

  static final TextStyle serviceStyle =
    TextStyle(fontSize: BadSizes.buttonTextSize, fontWeight: FontWeight.bold);

  static final TextStyle multipleStyle =
    TextStyle(fontSize: BadSizes.multipleTextSize, fontWeight: FontWeight.bold);

  static final TextStyle headerWeekdayStyle =
    TextStyle(fontSize: BadSizes.headerWeekdaySize);

  static final TextStyle headerDayStyle =
    TextStyle(fontSize: BadSizes.headerDaySize, fontWeight: FontWeight.bold);
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