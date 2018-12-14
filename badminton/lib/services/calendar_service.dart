import 'dart:math';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;





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

    Map raw = json.decode(await loadAsset());

//    Green - if total_slot = available
//    Orange - if 50% of total_slot > available (handle decimals)
//    Full - if total_slot = booked or if total_slot = booked+blocked (where booked > 0)
//    Blocked sign - if total_Slot = blocked
    const String slotsKey = 'slots';
    const String dateKey = 'date';
    const String slotListKey = 'slot_list';
    const String startTimeKey = 'start_time';
    const String endTimeKey = 'end_time';
    const String totalSlotKey = 'total_slot';
    const String availableKey = 'available';
    const String bookedKey = 'booked';
    const String blockedKey = 'blocked';

    Map<DateTime, Map<String, int>> available = Map();



    var slots = raw[slotsKey];
    for (var slot in slots) {
      var date = DateTime.parse(slot[dateKey]);
      var slotList = slot[slotListKey];
      for (var booking in slotList) {

      }

      print('slot list' + date.toString());
    }


    for (var date in dates) {
      if (date != null) {
        available[date] = Map();
        print(available[date]);
        for (var time in times) {
          if (time != null) {
            available[date][time] = rng.nextInt(4);
          }
        }
      }
    }
    print(available);
    return available;
  }
}