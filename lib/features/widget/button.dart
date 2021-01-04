import 'dart:ui';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  MyButton({
    @required this.text,
    @required this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
        height: 50.0,
        decoration: BoxDecoration(
          color: AppTheme().appTheme.primaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
