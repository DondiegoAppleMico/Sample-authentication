import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  final double size;
  final Color color;

  ConfettiWidget({this.size = 10, this.color = Colors.yellow});

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  List<Offset> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _controller.repeat();

    Timer.periodic(Duration(milliseconds: 100), (timer) {
      _addParticle();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addParticle() {
    final double x = _random.nextDouble() * MediaQuery.of(context).size.width;
    final double y = -widget.size;
    final Offset position = Offset(x, y);
    setState(() {
      _particles.add(position);
    });

    _controller.addListener(() {
      setState(() {
        _particles = _particles
            .map((Offset offset) => Offset(
                  offset.dx,
                  offset.dy +
                      _controller.value * MediaQuery.of(context).size.height,
                ))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ConfettiPainter(
        particles: _particles,
        size: widget.size,
        color: widget.color,
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Offset> particles;
  final double size;
  final Color color;

  ConfettiPainter(
      {required this.particles, required this.size, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    particles.forEach((Offset offset) {
      canvas.drawCircle(offset, this.size, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
