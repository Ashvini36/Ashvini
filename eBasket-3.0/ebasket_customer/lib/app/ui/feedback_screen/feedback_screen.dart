import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/dashboard_screen/dashboard_screen.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/utils/dark_theme_provider.dart';
import 'package:ebasket_customer/widgets/common_ui.dart';
import 'package:ebasket_customer/widgets/round_button_gradiant.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppThemeData.white,
      appBar:
          CommonUI.customAppBar(context, title:  Text("Feedback".tr, style: TextStyle(color: AppThemeData.black, fontFamily: AppThemeData.semiBold, fontSize: 20)), isBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Responsive.width(35, context),
              height: Responsive.height(17, context),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2080&q=80'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(90.0)),
                border: Border.all(
                  color: AppThemeData.groceryAppDarkBlue,
                  width: 4.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Please rate the driver".tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppThemeData.black.withOpacity(0.50), fontFamily: AppThemeData.semiBold, fontSize: 14),
            ),
            const SizedBox(
              height: 15,
            ),
            RatingBar.builder(
              initialRating: 4,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>  Icon(
                Icons.star,
                color: AppThemeData.groceryAppDarkBlue,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              controller: null,
              hintText: "Satisfaction .......".tr,
              prefix: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset("assets/icons/ic_feedback.svg", height: 22, width: 22),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            RoundedButtonGradiant(
              title: "Go To Home Page".tr,
              onPress: () {
                Get.offAll(() => const DashBoardScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
