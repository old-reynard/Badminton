import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data/contract.dart';

class MultiplePage extends StatefulWidget {


  @override
  State<MultiplePage> createState() => _MultiplePageState();
}

class _MultiplePageState extends State<MultiplePage> {
  bool _block = true;

  DateTime _startDate;
  DateTime _endDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
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

  Widget _body() {
    return SingleChildScrollView(
      child: _getCorrectLayout(),
    );
  }

  Widget _field(Widget kid) {
    return Center(
      child: Container(
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
      ),
    );
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
    return Row(
      children: <Widget>[
        Text(BadStrings.time, style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () {},
          child: Text(BadStrings.from, style: BadStyles.multipleStyle,),
        ),
        Text('|', style: BadStyles.multipleStyle,),
        FlatButton(
          onPressed: () {},
          child: Text(BadStrings.to, style: BadStyles.multipleStyle,),
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

  Widget _getCorrectLayout() {
    Widget layout = _block
        ? Column(
      children: <Widget>[
        _field(_dateField()),
        _field(_timeField()),
      ],
    )
        : Container();
    return layout;
  }
}