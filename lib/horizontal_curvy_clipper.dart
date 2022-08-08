import 'package:flutter/cupertino.dart';

class HorizontalCurvyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo((size.width / 8) * 6, size.height);
    path.lineTo(0, size.height);
    // path.lineTo(0, size.width);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
