import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FancyFab extends StatefulWidget {
  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: Colors.black54,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimateIcons(
        startTooltip: 'Toggle',
        endTooltip: 'NoToggle',
        startIcon: Icons.add,
        endIcon: Icons.close,
        size: 30.0,
        onStartIconPress: () {
          return true;
          print("Clicked on Add Icon");
        },
        onEndIconPress: () {
          return true;
          print("Clicked on Close Icon");
        },
        duration: Duration(milliseconds: 1000),
        color: Colors.white12,
        clockwise: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return toggle();
  }
}