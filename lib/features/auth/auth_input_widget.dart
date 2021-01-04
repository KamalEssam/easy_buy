import 'package:easy_buy/features/settings/theme.dart';
import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  TextEditingController controller;
  Widget suffixIcon;
  String hint;
  bool obscureText;
  bool validate;
  String errorText;

  AuthInput({
    @required this.controller,
    @required this.suffixIcon,
    @required this.hint,
    @required this.obscureText,
    @required this.validate,
    @required this.errorText,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      style: TextStyle(color: AppTheme().appTheme.primaryColor),
      decoration: InputDecoration(
        errorText: validate ? errorText : null,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: AppTheme().appTheme.primaryColor,
          width: 1.0,
        )),
        errorBorder:  OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            )),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.black54,
          width: 0.5,
        )),
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.black54,
            fontFamily: 'NotoSansSC',
            fontSize: 14.0),
      ),
    );
  }
}
