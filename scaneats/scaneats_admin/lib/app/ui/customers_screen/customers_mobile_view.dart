import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/customers_controller.dart';
import 'package:scaneats/app/ui/customers_screen/widget_customer.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/widgets/common_ui.dart';


class CustomersMobileScreen extends StatelessWidget {
  final CustomersController controller;

  const CustomersMobileScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonUI.appBarMobileUI(context),
        CommonUI.appMoblieUI(context,
            onSelectBranch: ((V) => controller.getCustomerData()), onChange: ((v) => Constant().debouncer.call(() => controller.searchByName(name: v.toString())))),
        const AllCustomerWidget()
      ],
    );
  }
}
