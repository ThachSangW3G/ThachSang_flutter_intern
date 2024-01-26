import 'dart:math';

import 'package:flutter/material.dart';

abstract class Shape {
  final Paint paint = Paint();

  Offset offset = Offset.zero; // Offset cho di chuyển
  double scale = 1.0; // Giá trị thu phóng
  Offset center;
  Offset move = Offset.zero;
  Shape({required this.center});
  void draw(Canvas canvas);
}

class RectangleShape extends Shape {
  final double width = Random().nextDouble() * 50 + 30;
  final double height = Random().nextDouble() * 50 + 30;

  RectangleShape({required Offset center}) : super(center: center) {
    paint.color = Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1.0,
    );
  }

  @override
  void draw(Canvas canvas) {
    final transformedCenter = center * scale + offset + move;
    print('center');
    print(transformedCenter);
    print('ofset');
    print(offset);
    canvas.drawRect(
      Rect.fromCenter(
          center: transformedCenter,
          width: width * scale,
          height: height * scale),
      paint,
    );
  }
}

class CircleShape extends Shape {
  final double radius = Random().nextDouble() * 30 + 20;

  CircleShape({required Offset center}) : super(center: center) {
    paint.color = Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1.0,
    );
  }

  @override
  void draw(Canvas canvas) {
    final transformedCenter = center * scale + offset;
    canvas.drawCircle(transformedCenter, radius * scale, paint);
  }
}
