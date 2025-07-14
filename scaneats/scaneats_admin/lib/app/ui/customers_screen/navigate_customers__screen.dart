import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/customers_controller.dart';
import 'package:scaneats/app/ui/customers_screen/customers_desktop_view.dart';
import 'package:scaneats/app/ui/customers_screen/customers_mobile_view.dart';
import 'package:scaneats/app/ui/customers_screen/customers_tablet_view.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:get/get.dart';

class NavigateCustomerScreen extends StatelessWidget {
  const NavigateCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CustomersController(),
      builder: (controller) {
        return ResponsiveLayout(mobileBody: CustomersMobileScreen(controller), tabletBody: CustomersTabletScreen(controller), desktopBody: CustomersDesktopScreen(controller));
      },
    );
  }
}
