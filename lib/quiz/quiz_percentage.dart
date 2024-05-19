import 'package:flutter/material.dart';

class PercentageAnimation extends StatefulWidget {
  final double percentage;

  const PercentageAnimation({Key? key, required this.percentage})
      : super(key: key);

  @override
  _PercentageAnimationState createState() => _PercentageAnimationState();
}

class _PercentageAnimationState extends State<PercentageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.percentage)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_animation.value.toStringAsFixed(0)}%',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
