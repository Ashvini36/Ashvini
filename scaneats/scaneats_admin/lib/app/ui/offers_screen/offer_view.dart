import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/offers_controller.dart';
import 'package:scaneats/app/ui/offers_screen/offers_screen.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/widgets/common_ui.dart';


class OfferViewScreen extends StatelessWidget {
  final OffersController controller;

  const OfferViewScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Responsive.isMobile(context)) CommonUI.appBarMobileUI(context),
        if (Responsive.isMobile(context)) CommonUI.appMoblieUI(context),
        if (!Responsive.isMobile(context)) CommonUI.appBarUI(context),
        const OffersScreen()
      ],
    );
  }
}
