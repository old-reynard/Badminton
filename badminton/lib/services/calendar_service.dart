import 'dart:math';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

const String apiUrl = 'http://ec2-13-233-112-79.ap-south-1.compute.amazonaws.com/';

class CalendarService {

  var rng = Random();

  List<DateTime> dates = <DateTime>[
//    DateTime.utc(2018, 12, 12),
    DateTime.utc(2018, 12, 13),
    DateTime.utc(2018, 12, 14),
    DateTime.utc(2018, 12, 15),
    DateTime.utc(2018, 12, 16),
    DateTime.utc(2018, 12, 17)
  ];

  List<String> times = <String>[
    '00:30 am',
    '01:30 am',
    '02:30 am',
    '03:30 am',
    '04:30 am',
    '05:30 am',
    '06:30 am',
    '07:30 am',
    '08:30 am',
    '09:30 am',
    '10:30 am',
    '11:30 am',
    '12:30 pm',
    '01:30 pm',
    '02:30 pm',
    '03:30 pm',
    '04:30 pm',
    '05:30 pm',
    '06:30 pm',
    '07:30 pm',
    '08:30 pm',
    '09:30 pm',
    '10:30 pm',
    '11:30 pm',
  ];


  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/json/courts.json');
  }

  Future<Map> availability() async {
    return json.decode(await loadAsset());
  }

  Future<String> getData() async {

    var query = {
      'mobile':'14377753105',
      'password': '123456',
      'start_date':'2018-12-15',
      'end_date':'2018-12-18'
    };

    String requestUrl = "http://ec2-13-233-112-79.ap-south-1.compute.amazonaws.com?mobile=14377753105&password=123456&start_date=2018-12-15&end_date=2018-12-18";

    final response = await http.get(requestUrl);
    return '';//response.body;
  }
}