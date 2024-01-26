import 'dart:math';

import 'package:bai5_bloc_dio/widgets/axes_painter.dart';
import 'package:bai5_bloc_dio/widgets/shape.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset origin = const Offset(0, 0);
  double initialScale = 1.0;
  double scaleFactor = 1.0;

  List<double> initialScaleShape = [];
  List<double> scaleShapeFactor = [];

  Offset initialOffsetShape = Offset.zero;
  Offset offsetShapeFactor = Offset.zero;

  List<Shape> shapes = [];
  int? indexSelectShape;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPressMoveUpdate: (details) {
            setState(() {
              if (indexSelectShape != null) {
                offsetShapeFactor =
                    initialOffsetShape + details.localOffsetFromOrigin;
                shapes[indexSelectShape!].center = offsetShapeFactor;
              }
            });
          },
          onLongPressEnd: (LongPressEndDetails details) {
            // Khi ngón tay nhấn giữ kết thúc, reset đối tượng Shape được chọn
            indexSelectShape = null;
          },
          onLongPressStart: (LongPressStartDetails details) {
            for (var shape in shapes) {
              if (shape is RectangleShape) {
                final transformedCenter =
                    shape.center * shape.scale + shape.offset;
                if (details.localPosition.dx >=
                        transformedCenter.dx - shape.width / 2 * shape.scale &&
                    details.localPosition.dx <=
                        transformedCenter.dx + shape.width / 2 * shape.scale &&
                    details.localPosition.dy >=
                        transformedCenter.dy - shape.height / 2 * shape.scale &&
                    details.localPosition.dy <=
                        transformedCenter.dy + shape.height / 2 * shape.scale) {
                  indexSelectShape = shapes.indexOf(shape);
                  initialOffsetShape = shape.center;
                }
              } else if (shape is CircleShape) {
                final transformedCenter =
                    shape.center * shape.scale + shape.offset;
                final distance = sqrt(
                  pow(details.localPosition.dx - transformedCenter.dx, 2) +
                      pow(details.localPosition.dy - transformedCenter.dy, 2),
                );

                if (distance <= shape.radius * shape.scale) {
                  indexSelectShape = shapes.indexOf(shape);
                  initialOffsetShape = shape.center;
                }
              }
            }
          },
          onScaleStart: (details) {
            initialScale = scaleFactor;
            for (var shape in shapes) {
              initialScaleShape[shapes.indexOf(shape)] =
                  scaleShapeFactor[shapes.indexOf(shape)];
            }
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              if (details.pointerCount == 1) {
                origin += details.focalPointDelta;
                shapes.forEach((shape) {
                  shape.offset += details.focalPointDelta;
                });
              } else {
                scaleFactor = initialScale * details.scale;
                shapes.forEach((shape) {
                  shape.scale =
                      initialScaleShape[shapes.indexOf(shape)] * details.scale;
                });
              }
            });
          },
          child: CustomPaint(
            key: UniqueKey(),
            painter: AxesPainter(origin, scaleFactor, shapes),
            child: Container(),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                shapes.add(RectangleShape(
                    center: getCenterOfScreen(context), origin: origin));
                scaleShapeFactor.add(1.0);
                initialScaleShape.add(1.0);
              });
            },
            shape: CircleBorder(),
            child: Icon(Icons.rectangle),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                shapes.add(CircleShape(
                    center: getCenterOfScreen(context), origin: origin));
                scaleShapeFactor.add(1.0);
                initialScaleShape.add(1.0);
              });
            },
            shape: CircleBorder(),
            child: Icon(Icons.circle),
          )
        ],
      ),
    );
  }
}

Offset getCenterOfScreen(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final centerX = screenSize.width / 2;
  final centerY = screenSize.height / 2;
  return Offset(centerX, centerY);
}
