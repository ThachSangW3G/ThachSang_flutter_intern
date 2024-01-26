import 'package:bai5_bloc_dio/widgets/shape.dart';
import 'package:flutter/material.dart';

class AxesPainter extends CustomPainter {
  final double axisThickness = 2.0; // Độ dày của trục
  final double gridThickness = 0.5; // Độ dày của đường lưới

  final Offset origin;
  final double initialUnitSpacing = 30.0;
  late double unitSpacing;
  final double scale;

  double unit = 1;

  final List<Shape> shapes;

  AxesPainter(this.origin, this.scale, this.shapes) {
    unitSpacing = initialUnitSpacing * scale;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2 + origin.dx;
    final double centerY = size.height / 2 + origin.dy;

    print('center x');
    print(centerX);
    print('center Y');
    print(centerY);
    print('scale');
    print(scale);

    double fontSize = 10;

    final TextStyle textStyle =
        TextStyle(fontSize: fontSize, color: Colors.black);

    if (scale > 2 && scale < 10) {
      unit = 0.5;
      fontSize = 20;
    } else if (scale > 10) {
      unit = 0.2;
      fontSize = 20;
    } else if (scale < 0.8 && scale > 0.4) {
      unit = 2;
    } else if (scale < 0.4 && scale > 0.2) {
      unit = 5;
    } else if (scale < 0.2) {
      unit = 10;
    }

    // Vẽ trục Ox
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      Paint()
        ..color = Colors.black
        ..strokeWidth = axisThickness,
    );

    // Vẽ trục Oy
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      Paint()
        ..color = Colors.black
        ..strokeWidth = axisThickness,
    );

    // Vẽ đơn vị trên trục Ox
    for (double i = centerX + unitSpacing * unit;
        i < size.width;
        i += unitSpacing * unit) {
      canvas.drawLine(
        Offset(i, centerY - 5),
        Offset(i, centerY + 5),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (i - centerX) / (unitSpacing);
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(canvas, Offset(i - textPainter.width / 2, centerY + 8));
    }

    for (double i = centerX - unitSpacing * unit;
        i > -size.width;
        i -= unitSpacing * unit) {
      canvas.drawLine(
        Offset(i, centerY - 5),
        Offset(i, centerY + 5),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (i - centerX) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(canvas, Offset(i - textPainter.width / 2, centerY + 8));
    }

    // Vẽ đơn vị trên trục Oy
    for (double i = centerY + unitSpacing * unit;
        i < size.height;
        i += unitSpacing * unit) {
      canvas.drawLine(
        Offset(centerX - 5, i),
        Offset(centerX + 5, i),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (centerY - i) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(canvas,
          Offset(centerX - textPainter.width - 8, i - textPainter.height / 2));
    }

    for (double i = centerY - unitSpacing * unit;
        i > -size.height;
        i -= unitSpacing * unit) {
      canvas.drawLine(
        Offset(centerX - 5, i),
        Offset(centerX + 5, i),
        Paint()
          ..color = Colors.black
          ..strokeWidth = axisThickness,
      );

      final text = (centerY - i) / unitSpacing;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: scale > 2 ? text.toStringAsFixed(1) : text.round().toString(),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: initialUnitSpacing);
      textPainter.paint(canvas,
          Offset(centerX - textPainter.width - 8, i - textPainter.height / 2));
    }

    // Vẽ đường lưới
    for (double i = centerX + unitSpacing; i < size.width; i += unitSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerY + unitSpacing; i < size.height; i += unitSpacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerX - unitSpacing; i > -size.width; i -= unitSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (double i = centerY - unitSpacing; i > -size.height; i -= unitSpacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = gridThickness,
      );
    }

    for (var shape in shapes) {
      shape.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
