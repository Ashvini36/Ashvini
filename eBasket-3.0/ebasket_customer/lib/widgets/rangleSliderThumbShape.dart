import 'package:flutter/material.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';

class CircleThumbShape extends RangeSliderThumbShape {
  const CircleThumbShape({this.thumbRadius = 10.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required SliderThemeData sliderTheme,
        bool? isDiscrete,
        bool? isEnabled,
        bool? isOnTop,
        TextDirection? textDirection,
        Thumb? thumb,
        bool? isPressed,
      }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = AppThemeData.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppThemeData.colorSliderBarPrimary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, thumbRadius, fillPaint)
      ..drawCircle(center, thumbRadius, borderPaint);
  }
}

