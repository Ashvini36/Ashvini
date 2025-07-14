import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/employees_controller.dart';
import 'package:scaneats/app/ui/employees_screen/widget_employees.dart';
import 'package:scaneats/widgets/common_ui.dart';


class EmployeesMobileScreen extends StatelessWidget {
  final EmployeesController controller;
  const EmployeesMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
        CommonUI.appMoblieUI(context,
            onSelectBranch: ((V) => controller.getEmployeeData()), onChange: ((v) => controller.searchByName(name: v.toString()))),
        const AllEmployeesWidget()
      ],
    );
  }
}
