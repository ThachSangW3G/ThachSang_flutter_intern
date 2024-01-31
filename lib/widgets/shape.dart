import 'dart:math';

import 'package:flutter/material.dart';

abstract class Shape {
  Offset center;
  final Color color = Color.fromRGBO(
    Random().nextInt(256),
    Random().nextInt(256),
    Random().nextInt(256),
    1.0,
  );
  Shape({required this.center});
}

class RectangleShape extends Shape {
  final double width = Random().nextDouble() * 50 + 30;
  final double height = Random().nextDouble() * 50 + 30;

  RectangleShape({required Offset center}) : super(center: center);
}

class CircleShape extends Shape {
  final double radius = Random().nextDouble() * 30 + 20;

  CircleShape({required Offset center}) : super(center: center);
}
