import 'package:flutter/cupertino.dart';

class AvatarClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(width: 100, height: 100, center: Offset(0, 0));
    return Rect.fromLTWH(50, 50, 110, 110);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
  
}