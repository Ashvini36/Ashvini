import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/employees_controller.dart';
import 'package:scaneats/app/ui/employees_screen/employees_desktop_view.dart';
import 'package:scaneats/app/ui/employees_screen/employees_mobile_view.dart';
import 'package:scaneats/app/ui/employees_screen/employees_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigateEmployeesScreen extends StatelessWidget {
  const NavigateEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: EmployeesController(),
        builder: (controller) {
          return ResponsiveLayout(mobileBody: EmployeesMobileScreen(controller), tabletBody: EmployeesTabletScreen(controller), desktopBody: EmployeesDesktopScreen(controller));
        });
  }
}
