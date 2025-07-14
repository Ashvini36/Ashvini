import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 850) {
          return mobileBody;
        } else if (constraints.maxWidth < 1100) {
          return tabletBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;

  static width(double size, BuildContext context) {
    return MediaQuery.of(context).size.width * (size / 100);
  }

  static height(double size, BuildContext context) {
    return MediaQuery.of(context).size.height * (size / 100);
  }
}
