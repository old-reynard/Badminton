import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data/contract.dart';
import 'package:badminton/UI/widgets.dart';
import 'services/calendar_service.dart';






class MultiplePage extends StatefulWidget {

  final CalendarService _calendarService;

  MultiplePage(this._calendarService);

  @override
  State<MultiplePage> createState() => _MultiplePageState();
}

class _MultiplePageState extends State<MultiplePage> {
  bool _block = true;

  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  List<bool> occupied = List.filled(7, false);

  BlockingPurpose purpose;
  Map available;

  List<String> services = <String>[];
  List<String> courts = <String>[];
  String _currentService;
  String _currentCourt;

  @override
  void initState() {
    widget._calendarService.availability().then((json) {
      setState(() {
        available = json;
        var subtypes = available[subtypeListKey];
        for (var subtype in subtypes) {
          this.services.add(subtype[nameKey]);
        }
        var services = available[servicesListKey];
        for (var service in services) {
          courts.add(service[inventoryNameKey]);
        }

//        _currentService = (services == null && services.length == 0) ? '' : services[0];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: _getCorrectLayout(),
      ),
    );
  }

  Widget _appBar() {
    TextStyle blockStyle = _block ? BadStyles.appBarStyle : BadStyles.appBarStyleInactive;
    TextStyle unblockStyle = _block ? BadStyles.appBarStyleInactive : BadStyles.appBarStyle;

    return AppBar(
      backgroundColor: BadColors.background,
      centerTitle: true,
      elevation: 0.0,
      bottom: PreferredSize(
          child: Text(BadStrings.blockingNote, style: BadStyles.labelStyle,),
          preferredSize: Size(double.infinity, 10.0),
      ),
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    _block = true;
                  });
                },
                child: Text(
                    BadStrings.block, style: blockStyle,
                ),
              ),
              Text(" | ", style: BadStyles.appBarStyle,),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _block = false;
                  });
                },
                child: Text(
                  BadStrings.unblock, style: unblockStyle,
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _field(Widget kid) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Material(
            elevation: 2.0,
            color: BadColors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BadSizes.buttonBorderRadius)
            ),
            child: Padding(padding:EdgeInsets.all(12),child: kid)
        ),
      ),
    );
  }

  Widget _chooseServiceButton() {
    if (services == null || services.length == 0) return Container();
    else {
      final List<DropdownMenuItem<String>> items = services.map((String value) =>
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        )).toList();
      return DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton(
            isDense: true,
            items: items,
            value: _currentService == null ? null : _currentService,
            onChanged: (String newValue) {
              setState(() {
                _currentService = newValue;
              });
            },
          ),
        ),
      );
    }
  }

  Widget _chooseCourtButton() {
    if (courts == null || courts.length == 0) return Container();
    else {
      List<DropdownMenuItem<String>> items = courts.map((String value) =>
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        )).toList();
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          isDense: true,
            items: items,
            value: _currentCourt == null ? null : _currentCourt,
            onChanged: (String value) {
              setState(() {
                _currentCourt = value;
              });
            }
        ),
      );
    }
  }

  Widget _dateField() {
    var formatter = DateFormat('yyyy-MM-dd');
    String startText = _startDate == null
        ? BadStrings.from
        : "${formatter.format(_startDate.toLocal())}";
    String endText = _endDate == null
        ? BadStrings.to
        : "${formatter.format(_endDate.toLocal())}";
    return Row(
      children: <Widget>[
        Text(BadStrings.date, style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () => _selectDate(context, true),
          child: Text(startText, style: BadStyles.multipleStyle,),
        ),
        Text('|', style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () => _selectDate(context, false),
          child: Text(endText, style: BadStyles.multipleStyle,),
        ),
      ],
    );
  }

  Widget _timeField() {

    String startText = _startTime == null
        ? BadStrings.from
        : '${_startTime.hour}:${_startTime.minute}';

    String endText = _endTime == null
        ? BadStrings.to
        : '${_endTime.hour}:${_endTime.minute}';
    return Row(
      children: <Widget>[
        Text(BadStrings.time, style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () => _selectTime(context, true),
          child: Text(startText, style: BadStyles.multipleStyle,),
        ),
        Text('|', style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () => _selectTime(context, false),
          child: Text(endText, style: BadStyles.multipleStyle,),
        ),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context, bool start) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _startDate && picked != _endDate) {
      setState(() {
        if (start) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool start) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now())
    );
    if (picked != null && picked != _startTime && picked != _endTime) {
      setState(() {
        if (start) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  Widget _getCorrectLayout() {
    Widget layout = _block
        ? Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _field(_chooseServiceButton()),
              _field(_chooseCourtButton()),
            ],
          ),
          _field(_dateField()),
          _field(_timeField()),
          _field(_dayField()),
          _field(_purposeField()),
          BadWidgets.submitButton(BadStrings.block, (){print('oho');}),
        ],
      ),
    )
        : Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _field(_chooseServiceButton()),
              _field(_chooseCourtButton()),
            ],
          ),
          _field(_dateField()),
          _field(_timeField()),
          _field(_dayField()),
//          _field(_purposeField()),
          BadWidgets.submitButton(BadStrings.block, (){print('oho');}),
        ],
      ),
    );
    return layout;
  }

  Widget _dayButton(bool chosen, String day, int order) {
    Color color = chosen ? BadColors.main : BadColors.inactive;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: OutlineButton(
          borderSide: BorderSide(color: color),
          color: color,
          onPressed: () {
            setState(() {
              occupied[order] = !occupied[order];
            });
          },
          child: Center(
            child: Row(
              children: <Widget>[
                Text(day, style: TextStyle(color: color),),
                Icon(Icons.check, color: color,)
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _dayField() {
    List<Widget> upper = <Widget>[];
    List<Widget> lower = <Widget>[];

    for (int i = 0; i < 4; i++) {
      upper.add(_dayButton(occupied[i], BadStrings.week[i], i));
    }

    for (int j = 4; j < 7; j++) {
      lower.add(_dayButton(occupied[j], BadStrings.week[j], j));
    }
    return Column(
      children: <Widget>[
        Row(children: upper,),
        Row(children: lower,),
      ],
    );
  }

  Widget _purposeField() {
   return Column(
     children: <Widget>[
       Row(children: <Widget>[Text(BadStrings.purpose)],),
       Row(
         children: <Widget>[
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Row(
                 children: <Widget>[
                   Radio(
                     activeColor: BadColors.accent,
                     value: BlockingPurpose.maintenance,
                     groupValue: purpose,
                     onChanged: ((value) => _changePurpose(value)),
                   ),
                   Text(BadStrings.maintenance),
                 ],
               ),
               Row(
                 children: <Widget>[
                   Radio(
                     activeColor: BadColors.accent,
                     value: BlockingPurpose.holiday,
                     groupValue: purpose,
                     onChanged: ((value) => _changePurpose(value)),
                   ),
                   Text(BadStrings.holiday),
                 ],
               ),
             ],
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Row(
                 children: <Widget>[
                   Radio(
                     activeColor: BadColors.accent,
                     value: BlockingPurpose.academy,
                     groupValue: purpose,
                     onChanged: ((value) => _changePurpose(value)),
                   ),
                   Text(BadStrings.academy),
                 ],
               ),
               Row(
                 children: <Widget>[
                   Radio(
                     activeColor: BadColors.accent,
                     value: BlockingPurpose.userBooking,
                     groupValue: purpose,
                     onChanged: ((value) => _changePurpose(value)),
                   ),
                   Text(BadStrings.userBooking),
                 ],
               ),
             ],
           ),
         ],
       ),
     ],
   );
  }

  void _changePurpose(value) {
    setState(() {
      purpose = value;
    });
  }
}

enum BlockingPurpose {
  maintenance, academy, holiday, userBooking
}