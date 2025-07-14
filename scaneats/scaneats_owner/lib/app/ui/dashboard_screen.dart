import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/app/controller/dash_board_controller.dart';
import 'package:scaneats_owner/app/ui/login_screen/login_screen.dart';
import 'package:scaneats_owner/constant/constant.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/utils/Preferences.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/network_image_widget.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

final GlobalKey<ScaffoldState> scaffoldHomeKey = GlobalKey<ScaffoldState>();

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader(context)
              : Scaffold(
                  key: scaffoldHomeKey,
                  drawer: customDrawer(context, controller),
                  body: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(visible: Responsive.isDesktop(context), child: customDrawer(context, controller)),
                      Expanded(
                        child: SingleChildScrollView(child: controller.drawerItems[controller.selectedDrawerIndex.value].widget),
                      )
                    ],
                  ),
                );
        });
  }

  customDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      if (d.isVisible == true) {
        drawerOptions.add(GestureDetector(
          onTap: () {
            controller.changeView(screenType: "");
            controller.onSelectItem(i);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: d.icon != null
                  ? Row(
                      children: [
                        SvgPicture.asset(d.icon ?? '',
                            width: 20,
                            color: i == controller.selectedDrawerIndex.value
                                ? AppThemeData.crusta500
                                : themeChange.getThem()
                                    ? AppThemeData.pickledBluewood800
                                    : AppThemeData.pickledBluewood200),
                        const SizedBox(
                          width: 20,
                        ),
                        TextCustom(
                            title: d.title ?? '',
                            color: i == controller.selectedDrawerIndex.value
                                ? AppThemeData.crusta500
                                : themeChange.getThem()
                                    ? AppThemeData.pickledBluewood800
                                    : AppThemeData.pickledBluewood200,
                            fontSize: 14,
                            fontFamily: AppThemeData.medium),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        devider(context,
                            color: themeChange.getThem() ? AppThemeData.pickledBluewood500 : AppThemeData.pickledBluewood950, height: themeChange.getThem() ? 0.08 : 0.8),
                        spaceH(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextCustom(title: d.title ?? '', fontSize: 12, color: AppThemeData.pickledBluewood500, fontFamily: AppThemeData.regular),
                        ),
                      ],
                    ),
            ),
          ),
        ));
      }
    }

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      backgroundColor: themeChange.getThem() ? AppThemeData.white : AppThemeData.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: NetworkImageWidget(
                      imageUrl: Constant.projectLogo,
                      fit: BoxFit.contain,
                      height: 100,
                      width: 200,
                    ),
                  ),
                  !Responsive.isMobile(context)
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            Preferences.clearKeyData(Preferences.order);
                            Get.offAll(const LoginScreen());
                          },
                          child: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                        )
                ],
              ),
            ),
            spaceH(),
            Expanded(child: SingleChildScrollView(child: Column(children: drawerOptions))),
          ],
        ),
      ),
    );
  }
}
