/*
 * @Author: Yolanda 
 * @Date: 2020-02-19 15:57:20 
 * @Last Modified by: Yolanda
 * @Last Modified time: 2020-02-20 16:38:07
 */

import 'package:flutter/material.dart';
import 'package:qnsdk_example/group/paddingText.dart';
import 'package:qnsdk_example/group/titleInput.dart';
import 'package:qnsdk/qnsdk.dart';

class UserInfo extends StatefulWidget {
  String _userId = '1234567';
  int _height = 170;
  String _gender = 'male';
  bool _athleteType = false;
  double _clothesWeight = 0;
  DateTime _birthday = DateTime(1990, 1, 1);

  QNUser get user => QNUser(_userId, _height, _gender, _birthday,
      _athleteType ? 1 : 0, _clothesWeight);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        userIdAndHeight(),
        genderAndSport(),
        birthdayAndClothesWeight()
      ],
    );
  }

  Widget userIdAndHeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(
                text: 'userId',
              ),
              PaddingText(text: widget._userId)
            ],
          ),
        ),
        Expanded(
            flex: 1,
            child: TitleInput(
                text: 'height',
                initValue: widget._height.toString(),
                textOnChange: (value) {
                  if (value != null) {
                    setState(() {
                      widget._height = int.parse(value);
                    });
                  }
                },
                inputType: TextInputType.number)),
      ],
    );
  }

  Widget genderAndSport() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'gender'),
              Radio(
                  groupValue: widget._gender,
                  value: 'male',
                  onChanged: (value) {
                    setState(() {
                      widget._gender = value;
                    });
                  }),
              Radio(
                  groupValue: widget._gender,
                  value: 'female',
                  onChanged: (value) {
                    setState(() {
                      widget._gender = value;
                    });
                  })
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'athleteType'),
              Switch(
                  value: widget._athleteType,
                  onChanged: (value) {
                    setState(() {
                      widget._athleteType = value;
                    });
                  }),
            ],
          ),
        )
      ],
    );
  }

  void _showBirthdayPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
        context: context,
        initialDate: widget._birthday,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(DateTime.now().year - 3));
    setState(() {
      if (picker != null) {
        print(picker);
        widget._birthday = picker;
      }
    });
  }

  Widget birthdayAndClothesWeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TitleInput(
              text: 'clothesWeight',
              initValue: widget._clothesWeight.toString(),
              textOnChange: (value) {
                if (value != null) {
                  setState(() {
                    widget._clothesWeight = double.parse(value);
                  });
                }
              }),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              PaddingText(text: 'birthday'),
              RaisedButton(
                child: PaddingText(
                  text:
                      '${widget._birthday.year}-${widget._birthday.month}-${widget._birthday.day}',
                  insets: EdgeInsets.zero,
                ),
                onPressed: _showBirthdayPicker,
              )
            ],
          ),
        )
      ],
    );
  }
}
