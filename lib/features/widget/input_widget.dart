import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  TextEditingController controller;
  Widget suffixIcon;
  String hint;
  String text;
  bool obscureText;
  double height;
  TextInputType type;

  Input({
    @required this.controller,
    this.suffixIcon,
    this.text,
    this.hint,
    @required this.obscureText,
    this.height,
    this.type,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: height != null ? height : 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              height: 25,
              child: TextField(
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: type != null ? type : TextInputType.text,
                obscureText: obscureText,
                controller: controller,
                style: TextStyle(
                    letterSpacing: 1,
                    wordSpacing: 1,
                    color: Colors.black87,
                    fontFamily: "din-regular",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: hint != null ? hint : "",
                  hintStyle: TextStyle(
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontFamily: "din-regular",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
