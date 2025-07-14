import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/text_widget.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/ic_error.svg"),
            spaceH(height: 20),
            const TextCustom(title: "Oops! Looks like you've taken a wrong turn.",fontSize: 18,fontFamily: AppThemeData.bold,),
            spaceH(height: 10),
            const TextCustom(title: "Sorry, the page you're looking for isn't here. Let's get you back on track!",fontSize: 16,fontFamily: AppThemeData.medium)
          ],
        ),
      ),
    );
  }
}
