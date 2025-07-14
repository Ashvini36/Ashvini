import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/employees_controller.dart';
import 'package:scaneats/app/ui/employees_screen/widget_employees.dart';
import 'package:scaneats/widgets/common_ui.dart';


class EmployeesTabletScreen extends StatelessWidget {
  final EmployeesController controller;

  const EmployeesTabletScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarUI(context, onSelectBranch: ((V) => controller.getEmployeeData()), onChange: ((v) => controller.searchByName(name: v.toString()))),
        const AllEmployeesWidget()
      ],
    );
  }
}
