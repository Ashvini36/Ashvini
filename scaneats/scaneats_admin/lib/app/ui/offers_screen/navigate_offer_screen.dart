import 'package:flutter/material.dart';
import 'package:scaneats/app/controller/offers_controller.dart';
import 'package:get/get.dart';
import 'package:scaneats/app/ui/offers_screen/offer_view.dart';

class NavigateOfferScreen extends StatelessWidget {
  const NavigateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        global: true,
        init: OffersController(),
        builder: (controller) {
          return OfferViewScreen(controller);
        });
  }
}
