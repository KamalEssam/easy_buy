import 'package:flutter/material.dart';

class GradientView extends StatelessWidget {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final List<Color> colors;

  GradientView({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight, this.colors,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors!=null?colors: [
              const Color(0xff058bcb),
              const Color(0xff076c9d)
            ]
            ,),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft!=null?topLeft:0),
            topRight: Radius.circular(topLeft!=null?topLeft:0),
            bottomRight: Radius.circular(bottomRight!=null?bottomRight:0),
            bottomLeft: Radius.circular(bottomLeft!=null?bottomLeft:0),
          ),

        )
    );
  }
}
