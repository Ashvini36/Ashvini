import 'package:flutter/material.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:provider/provider.dart';

class ContainerCustom extends StatelessWidget {
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double radius;
  final Color? color;
  final Color? borderColor;

  const ContainerCustom({super.key, this.alignment = Alignment.center, this.padding, this.borderColor, this.color, this.child, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
        alignment: alignment,
        padding: padding ?? paddingEdgeInsets(),
        decoration: BoxDecoration(
            border: borderColor != null ? Border.all(color: borderColor!) : null,
            color: color ?? (themeChange.getThem() ? AppThemeData.black : AppThemeData.white),
            borderRadius: BorderRadius.circular(radius)),
        child: child);
  }
}

class ContainerBorderCustom extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final Color color;
  final Color? fillColor;
  final double radius;

  const ContainerBorderCustom(
      {super.key, this.fillColor, this.padding = const EdgeInsets.all(8), required this.child, this.color = AppThemeData.pickledBluewood50, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(padding: padding, decoration: BoxDecoration(color: fillColor, border: Border.all(color: color), borderRadius: BorderRadius.circular(radius)), child: child);
  }
}
