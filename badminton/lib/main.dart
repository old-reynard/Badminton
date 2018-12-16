import 'package:flutter/material.dart';

import 'data/contract.dart';
import 'calendar.dart';
import 'services/calendar_service.dart';
import 'details.dart';
import 'multiple.dart';


void main() => runApp(new BadmintonApp());

class BadmintonApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: BadStrings.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF'
      ),
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  State<Root> createState() => RootState();
}

class RootState extends State<Root> {

  @override
  Widget build(BuildContext context) {
//    return DetailsPage(service: 'Badminton Courts',);
//    return CalendarPage(CalendarService());
    return MultiplePage();
  }
}
