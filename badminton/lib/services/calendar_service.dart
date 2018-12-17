import 'dart:math';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;


const String calendarUrl = 'http://ec2-13-233-112-79.ap-south-1.compute.amazonaws.com/v3/saas/slot/list';
const String slotUrl = 'http://ec2-13-233-112-79.ap-south-1.compute.amazonaws.com/v3/saas/slot/data';

class CalendarService {

  var client = http.Client();

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

  Future<String> getCalendarData() async {
    var response = await client.post(calendarUrl);
    return response.body;
  }

  Future<String> getSlotData(String serviceId, String date) async {

    var response = await client.post(
        slotUrl + '?service_id={$serviceId}&date={$date}');
    print(response.body);
    return response.body;
  }
}