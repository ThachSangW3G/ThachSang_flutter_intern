import 'dart:math';

import 'package:bai5_bloc_dio/widgets/shape.dart';
import 'package:flutter/material.dart';

class AxesPainter extends CustomPainter {
  final double axisThickness = 2.0; // Độ dày của trục
  final double gridThickness = 0.5; // Độ dày của đường lưới

  final double initialUnitSpacing = 30.0;
  late double unitSpacing;
  double scale = 1.0;

  double unit = 1;

  Offset centerPoint;

  final List<Shape> shapes;

  AxesPainter(
      {required this.centerPoint, required this.scale, required this.shapes}) {
    unitSpacing = initialUnitSpacing * scale;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double fontSize = 10;

    final TextStyle textStyle =
        TextStyle(fontSize: fontSize, color: Colors.black);

    if (scale > 2 && scale <= 10) {
      unit = 0.5;
      fontSize = 20;
    } else if (scale > 10) {
      unit = 0.2;
      fontSize = 20;
    } else if (scale < 0.8 && scale >= 0.4) {
      unit = 2;
    } else if (scale < 0.4 && scale > 0.1) {
      unit = 5;
    } else if (scale <= 0.1) {
      unit = 10;
    }

    // Vẽ trục Ox
    canvas.drawLine(
      Offset(0, centerPoint.dy),
      Offset(size.width, centerPoint.dy),
      Paint()
        ..color = Colors.black
        ..strokeWidth = axisThickness,
    );

    // Vẽ trục Oy
    canvas.drawLine(
      Offset(centerPoint.dx, 0),
      Offset(centerPoint.dx, size.height),
      Paint()
        ..color = Colors.black
        ..strokeWidth = axisThickness,
    );

    // Vẽ đơn vị trên trục Ox
    for (double i = centerPoint.dx + unitSpacing * unit;
        i < size.width;
        i += unitSpacing * unit) {
      canvas.drawLine(
        Offset(i, centerPoint.dy - 5),
        Offset(i, centerPoint.dy + 5),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (i - centerPoint.dx) / (unitSpacing);
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(
          canvas, Offset(i - textPainter.width / 2, centerPoint.dy + 8));
    }

    for (double i = centerPoint.dx - unitSpacing * unit;
        i > -size.width;
        i -= unitSpacing * unit) {
      canvas.drawLine(
        Offset(i, centerPoint.dy - 5),
        Offset(i, centerPoint.dy + 5),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (i - centerPoint.dx) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(
          canvas, Offset(i - textPainter.width / 2, centerPoint.dy + 8));
    }

    // Vẽ đơn vị trên trục Oy
    for (double i = centerPoint.dy + unitSpacing * unit;
        i < size.height;
        i += unitSpacing * unit) {
      canvas.drawLine(
        Offset(centerPoint.dx - 5, i),
        Offset(centerPoint.dx + 5, i),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (centerPoint.dy - i) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(
          canvas,
          Offset(centerPoint.dx - textPainter.width - 8,
              i - textPainter.height / 2));
    }

    for (double i = centerPoint.dy - unitSpacing * unit;
        i > -size.height;
        i -= unitSpacing * unit) {
      canvas.drawLine(
        Offset(centerPoint.dx - 5, i),
        Offset(centerPoint.dx + 5, i),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (centerPoint.dy - i) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(
          canvas,
          Offset(centerPoint.dx - textPainter.width - 8,
              i - textPainter.height / 2));
    }

    // Vẽ đường lưới
    for (double i = centerPoint.dx + unitSpacing;
        i < size.width;
        i += unitSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerPoint.dy + unitSpacing;
        i < size.height;
        i += unitSpacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerPoint.dx - unitSpacing;
        i > -size.width;
        i -= unitSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerPoint.dy - unitSpacing;
        i > -size.height;
        i -= unitSpacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    Offset toRealPoint(Offset point) {
      double x = centerPoint.dx + point.dx * scale;
      double y = centerPoint.dy - point.dy * scale;
      return Offset(x, y);
    }

    double toRealLength(double axisLength) {
      return axisLength * scale;
    }

    for (var shape in shapes) {
      if (shape is CircleShape) {
        canvas.drawCircle(toRealPoint(shape.center), toRealLength(shape.radius),
            Paint()..color = shape.color);
      } else if (shape is RectangleShape) {
        canvas.drawRect(
            Rect.fromCenter(
              center: toRealPoint(shape.center),
              width: toRealLength(shape.width),
              height: toRealLength(shape.height),
            ),
            Paint()..color = shape.color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
