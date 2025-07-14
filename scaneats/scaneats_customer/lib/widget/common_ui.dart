import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaneats_customer/constant/constant.dart';
import 'package:scaneats_customer/controller/pos_controller.dart';
import 'package:scaneats_customer/page/pos_screen/navigate_pos_screen.dart';
import 'package:scaneats_customer/page/pos_screen/widget_pos_screen.dart';
import 'package:scaneats_customer/responsive/responsive.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/widget/container_custom.dart';
import 'package:scaneats_customer/widget/network_image_widget.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

PopupMenuItem iconButton({String? image, bool selected = false, required bool isDarkmode, dynamic model}) {
  return PopupMenuItem(
    height: 30,
    value: model,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(visible: image == null, child: selected ? const Icon(Icons.radio_button_checked_outlined, size: 20) : const Icon(Icons.circle_outlined, size: 20)),
        Visibility(visible: image != null, child: ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.asset(image ?? '', width: 20, height: 20))),
        const SizedBox(width: 10),
        Text(model.title ?? '', style: TextStyle(color: isDarkmode ? AppThemeData.white : AppThemeData.black)),
      ],
    ),
  );
}

class CommonUI {
  static AppBar appBarUI(BuildContext context, {Color? backgroundColor, bool isCartVisible = true}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
        backgroundColor: themeChange.getThem() ? backgroundColor ?? AppThemeData.black : backgroundColor ?? AppThemeData.white,
        elevation: 0,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.offAll(const NavigatePosScreen());
            },
            child: NetworkImageWidget(imageUrl: Constant.projectLogo, width: 120, placeHolderUrl: Constant.placeholderURL),
          ),
        ),
        actions: [
          GetBuilder(
            init: PosController(),
            builder: (controller) {
              return GestureDetector(
                  onTap: () {
                    controller.setThme(themeChange: themeChange);
                  },
                  child: themeChange.getThem()
                      ? const Icon(Icons.light_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500)
                      : const Icon(Icons.dark_mode_outlined, size: 25, weight: 0.5, color: AppThemeData.pickledBluewood500));
            }
          ),
          if (isCartVisible)
            GetBuilder(
                init: PosController(),
                builder: (controller) {
                  return Visibility(
                    visible: controller.addToCart.value.product != null,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          controller.calculateAddToCart();
                          if (Responsive.isMobile(context)) {
                            Get.to(const AddToCartMoblieView());
                          } else {
                            addToCartDialog(context, themeChange.getThem());
                          }
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                "assets/icons/shopping-bag.svg",
                                height: 28,
                                width: 28,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(AppThemeData.crusta500, BlendMode.srcIn),
                              ),
                            ),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: AppThemeData.crusta500,
                                      child: TextCustom(title: '${controller.addToCart.value.product?.length ?? 0}', color: AppThemeData.white, fontSize: 10)),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                })
        ]);
  }
}
