import 'dart:math';


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

  Map availability() {
    Map<DateTime, Map<String, int>> available = Map();

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