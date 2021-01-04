import 'package:flutter/widgets.dart';


class LoginBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height * .61);
    //quadraticBezierTo(curve,end)

    path.quadraticBezierTo(size.width * 0.15, size.height * 0.63, size.width * 0.38, size.height * 0.68);

    path.quadraticBezierTo(size.width * 0.5, size.height * 0.7, size.width * 0.62, size.height * 0.68);
//
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.63, size.width, size.height*.61);


    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}



class LoginBottomTwo extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width * 0.65,0.0);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.14, size.width,size.height*0.15);
    path.lineTo(size.width,0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

