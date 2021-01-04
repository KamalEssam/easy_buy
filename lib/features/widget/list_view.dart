import 'dart:ui';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:flutter/material.dart';

class MyListView extends StatelessWidget {
  final ActionReport report;
  final listSize;
  final Widget listBuilder;

  MyListView({
    @required this.report,
    @required this.listBuilder,
    @required this.listSize,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return (report?.status == ActionStatus.running)
        ? Container(
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 3,
            )),
          )
        : listSize == 0
            ? Center(
                child: Hero(
                  tag: "noData",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/empty.png",
                        fit: BoxFit.fitWidth,
                        color:AppTheme().appTheme.primaryColor,
                        width: 220,
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'List is empty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppTheme().appTheme.primaryColor,
                              fontSize: 18.0,
                              fontFamily: 'NotoSansSC',
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : listBuilder;
  }
}
