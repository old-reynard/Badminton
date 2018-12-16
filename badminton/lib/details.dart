import 'package:flutter/material.dart';

import 'data/contract.dart';
import 'UI/widgets.dart';

class DetailsPage extends StatefulWidget {

  final String service;

  DetailsPage({this.service});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int radio = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(BadStrings.appBarTitle, style: BadStyles.appBarStyle,),
      backgroundColor: BadColors.background,
      centerTitle: true,
      elevation: 0.0,
    );
  }

  Widget _body() {

    String date = DateTime.now().toString();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _showService(),
          Container(
            color: BadColors.expansionTile,
            child: ExpansionTile(
              backgroundColor: BadColors.background,
              title: Text(date),
              children: _dropdown(),
            ),
          ),
          Container(
            color: BadColors.expansionTile,
            child: ExpansionTile(
              backgroundColor: BadColors.background,
              title: Text(date),
              children: _dropdown(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _dropdown() {
    List<Widget> buttons = <Widget>[
      _purposeButton(),
      _nameButton(),
      _mobileButton(),
      BadWidgets.submitButton(BadStrings.submit, () {print('oro');}),
    ];

    List<Widget> widgets = <Widget>[];

    for (int i = 0; i < buttons.length; i++) {
      var button = buttons[i];
      if (i == 0) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: _dropdownButton(button),
          ),
        );
      } else if (i == buttons.length - 1) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: button,
          )
        );
      } else {
        widgets.add(_dropdownButton(button));
      }
    }

    return widgets;
  }

  Widget _dropdownButton(Widget kid) {
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

  Widget _purposeButton() {
    return Row(
      children: <Widget>[
        Text(BadStrings.purpose),
        Radio(
          value: 1,
          activeColor: BadColors.accent,
          groupValue: this.radio,
          onChanged: (int value) {
            setState(() {
              this.radio = value;
            });
          },
        ),
        Text(BadStrings.booking),
        Radio(
          value: 2,
          activeColor: BadColors.accent,
          groupValue: this.radio,
          onChanged: (int value) {
            setState(() {
              this.radio = value;
            });
          },
        ),
        Text(BadStrings.blocking)
      ],
    );
  }

  Widget _nameButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(BadStrings.name),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: BadStrings.fullName,
              labelStyle: BadStyles.labelStyle,
            ),
          ),
        ),
        FlatButton(
          child: Text(BadStrings.selectContact),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _mobileButton() {
    return Row(
      children: <Widget>[
        Text(BadStrings.mobile),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: BadStrings.sendSMS,
              labelStyle: BadStyles.labelStyle
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Material(
            elevation: 2.0,
            color: BadColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BadSizes.buttonBorderRadius)
            ),
            child: FlatButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                child: Text(BadStrings.submit, style: BadStyles.buttonTextStyle,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showService() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
          widget.service, style: BadStyles.serviceStyle,),

    );
  }
}