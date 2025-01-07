import 'dart:math';

import 'package:flutter/material.dart';

class Throttle extends StatefulWidget {
  final double throttleHeight;
  final double handleHeight;
  final double baseWidth;
  final double minValue;
  final double maxValue;

  const Throttle(
      {super.key,
      this.throttleHeight = 200,
      this.handleHeight = 30,
      this.baseWidth = 70,
      this.minValue = 0,
      this.maxValue = 100});

  @override
  // ignore: library_private_types_in_public_api
  _ThrottleState createState() => _ThrottleState();
}

class _ThrottleState extends State<Throttle> {
  late final double _throttleHeight;
  late final double _handleHeight;
  late final double _baseWidth;
  late final double _minValue;
  late final double _maxValue;
  late Offset _center;

  bool _isDragging = false;
  Offset _lastDrag = Offset.zero;

  @override
  void initState() {
    super.initState();
    _throttleHeight = widget.throttleHeight;
    _handleHeight = widget.handleHeight;
    _baseWidth = widget.baseWidth;
    _minValue = widget.baseWidth;
    _maxValue = widget.baseWidth;
    _center = Offset(
      _baseWidth / 2,
      (_throttleHeight - _handleHeight / 2),
    );
  }

  void _startDragging(DragStartDetails details) {
    final Rect handle = Rect.fromCenter(
        center: _center, width: _baseWidth, height: _handleHeight);

    if (handle.contains(details.localPosition)) {
      _isDragging = true;
      _lastDrag = details.localPosition;
    }
  }

  void _updatePosition(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      double newY = _center.dy + details.localPosition.dy - _lastDrag.dy;
      newY = min(newY, (_throttleHeight - _handleHeight / 2));
      newY = max(newY, (_handleHeight / 2));

      _center = Offset(_center.dx, newY);
      _lastDrag = details.localPosition;
    });
  }

  void _stopDragging() {
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _startDragging,
      onPanUpdate: _updatePosition,
      onPanEnd: (_) => _stopDragging(),
      child: CustomPaint(
        size: Size(_baseWidth, _throttleHeight),
        painter: ThrottlePainter(
            _throttleHeight, _handleHeight, _baseWidth, _center),
      ),
    );
  }
}

class ThrottlePainter extends CustomPainter {
  final double throttleHeight;
  final double handleHeight;
  final double baseWidth;
  final Offset center;

  ThrottlePainter(
      this.throttleHeight, this.handleHeight, this.baseWidth, this.center);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final Paint handlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Rect throttle = Rect.fromCenter(
        center: (Offset(baseWidth / 2, throttleHeight / 2)),
        width: baseWidth,
        height: throttleHeight);
    Rect handle =
        Rect.fromCenter(center: center, width: baseWidth, height: handleHeight);

    canvas.drawRect(throttle, basePaint);
    canvas.drawRect(handle, handlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
