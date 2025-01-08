import 'package:flutter/material.dart';
import 'dart:math';

class Speedometer extends StatefulWidget {
  final double minSpeed;
  final double maxSpeed;

  const Speedometer({
    required this.minSpeed,
    required this.maxSpeed,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  SpeedometerState createState() => SpeedometerState();
}

class SpeedometerState extends State<Speedometer> {
  double currentSpeed = 0.0;

  // Function to update the speed
  void updateSpeed(double newSpeed) {
    setState(() {
      currentSpeed = newSpeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Size of the speedometer
      painter: SpeedometerPainter(
        currentSpeed: currentSpeed,
        minSpeed: widget.minSpeed,
        maxSpeed: widget.maxSpeed,
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double currentSpeed;
  final double minSpeed;
  final double maxSpeed;

  SpeedometerPainter({
    required this.currentSpeed,
    required this.minSpeed,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final Paint needlePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Paint arcPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2 - 10;

    // Draw the background circle
    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);

    // Draw the arc (representing the speed range)
    double startAngle = -pi / 2; // Start at 9 o'clock
    double sweepAngle = pi; // Sweep the arc over 180 degrees
    Rect arcRect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, arcPaint);

    // Draw the needle based on current speed
    double angle = _calculateNeedleAngle();
    double needleX = centerX + radius * cos(angle);
    double needleY = centerY + radius * sin(angle);
    canvas.drawLine(
        Offset(centerX, centerY), Offset(needleX, needleY), needlePaint);

    // Draw the speed text in the center
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '${currentSpeed.toStringAsFixed(0)} km/h',
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );
  }

  double _calculateNeedleAngle() {
    // Calculate the angle for the needle based on the current speed
    double speedRatio = (currentSpeed - minSpeed) / (maxSpeed - minSpeed);
    double angle = -pi / 2 + speedRatio * pi; // Mapping to 180 degrees
    return angle;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
