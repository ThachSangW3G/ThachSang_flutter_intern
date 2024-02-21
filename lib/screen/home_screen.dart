import 'dart:math';

import 'package:bai5_bloc_dio/widgets/axes_painter.dart';
import 'package:bai5_bloc_dio/widgets/shape.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Size screenSize;
  const HomeScreen({super.key, required this.screenSize});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset origin = const Offset(0, 0);
  double initialScale = 1.0;
  double scaleFactor = 1.0;

  Offset? touchCenter;
  late Offset centerPoint;
  Offset oldCenterPoint = const Offset(0, 0);

  late Offset oldStartDrag;
  late double scale;
  late double oldScale;

  List<Shape> shapes = [];
  int? indexSelectShape;

  @override
  void initState() {
    super.initState();
    centerPoint =
        Offset(widget.screenSize.width / 2, widget.screenSize.height / 2);
    scale = 1.0;
    oldScale = scale;
  }

  Offset getPointAxis(Offset offset) {
    Offset distance = offset - centerPoint;
    Offset axisOffset = Offset(distance.dx / scale, -(distance.dy / scale));
    return axisOffset;
  }

  Offset getCenterOfScreen(Size screenSize) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;
    return getPointAxis(Offset(centerX, centerY));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onLongPressMoveUpdate: (details) {
            setState(() {
              if (indexSelectShape != null) {
                shapes[indexSelectShape!].center =
                    getPointAxis(details.localPosition);
              }
            });
          },
          onLongPressEnd: (LongPressEndDetails details) {
            indexSelectShape = null;
          },
          onLongPressStart: (LongPressStartDetails details) {
            for (var shape in shapes) {
              if (shape is RectangleShape) {
                final position = getPointAxis(details.localPosition);
                if (position.dx >= shape.center.dx - shape.width / 2 &&
                    position.dx <= shape.center.dx + shape.width / 2 &&
                    position.dy >= shape.center.dy - shape.height / 2 &&
                    position.dy <= shape.center.dy + shape.height / 2) {
                  indexSelectShape = shapes.indexOf(shape);
                }
              } else if (shape is CircleShape) {
                final position = getPointAxis(details.localPosition);
                final distance = sqrt(
                  pow(position.dx - shape.center.dx, 2) +
                      pow(position.dy - shape.center.dy, 2),
                );

                if (distance <= shape.radius) {
                  indexSelectShape = shapes.indexOf(shape);
                }
              }
            }
          },
          onScaleStart: (details) {
            oldScale = scale;
            oldCenterPoint = centerPoint;
            touchCenter = null;

            oldStartDrag = details.localFocalPoint;
            oldCenterPoint = centerPoint;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              if (details.pointerCount == 1) {
                final distance = details.localFocalPoint - oldStartDrag;
                centerPoint = oldCenterPoint + distance;
              } else {
                scale = oldScale * details.scale;

                touchCenter ??= details.focalPoint;

                if (scale >= 0.1 && scale <= 15 && touchCenter != null) {
                  var dis = touchCenter! - oldCenterPoint;
                  dis *= details.scale;
                  centerPoint = touchCenter! - dis;
                } else {
                  if (scale > 15) scale = 15;
                  if (scale < 0.1) scale = 0.1;
                }
              }
            });
          },
          child: CustomPaint(
            key: UniqueKey(),
            painter: AxesPainter(
                centerPoint: centerPoint, scale: scale, shapes: shapes),
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
                    center: getCenterOfScreen(widget.screenSize)));
              });
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.rectangle),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                shapes.add(
                    CircleShape(center: getCenterOfScreen(widget.screenSize)));
              });
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.circle),
          )
        ],
      ),
    );
  }
}
