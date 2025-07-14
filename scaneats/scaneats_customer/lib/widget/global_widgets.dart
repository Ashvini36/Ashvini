import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_customer/theme/app_theme_data.dart';
import 'package:scaneats_customer/utils/DarkThemeProvider.dart';
import 'package:scaneats_customer/widget/text_widget.dart';

Widget spaceH({double? height}) => SizedBox(height: height ?? 10.0);

Widget spaceW({double? width}) => SizedBox(width: width ?? 10.0);

void printLog(String data) => log(data.toString());

EdgeInsets paddingEdgeInsets({double horizontal = 16, double vertical = 16}) {
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

devider(context, {Color? color, double height = 1}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Container(height: height, color: color ?? (themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50));
}

Widget customRadioButton(context, {required parameter, dynamic onChangeOne, dynamic onChangeTwo, required String title, required String radioOne, required String radioTwo}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      TextCustom(
        title: title,
        fontSize: 12,
      ),
      spaceH(height: 20),
      SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onChangeOne,
                  child: Row(
                    children: [
                      parameter == radioOne
                          ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                          : Icon(Icons.circle_outlined, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                      spaceW(width: 4),
                      TextCustom(title: radioOne)
                    ],
                  ),
                ),
              ),
              spaceW(),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onChangeTwo,
                  child: Row(children: [
                    parameter == radioTwo
                        ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                        : Icon(Icons.circle_outlined, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                    spaceW(width: 4),
                    TextCustom(title: radioTwo)
                  ]),
                ),
              )
            ],
          )),
    ],
  );
}

showAlertDialog(BuildContext context, String title, String content, bool addOkButton, {bool? login}) {
  // set up the AlertDialog
  // ignore: unused_local_variable
  Widget? okButton;
  if (addOkButton) {
    okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        if (login == true) {
          Get.back();
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppThemeData.pickledBluewood600
      ..strokeWidth = 1 // Adjust thickness as needed
      ..strokeCap = StrokeCap.square;

    const double dashWidth = 5;
    const double dashSpace = 5;
    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawLine(Offset(currentX, 0), Offset(currentX + dashWidth, 0), paint);
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Widget buildChip({required String label, required bool isSelected, required bool isDarkMode}) {
  return Container(
    decoration: BoxDecoration(
        color: isSelected ? AppThemeData.crusta500 : null,
        border: Border.all(color: isDarkMode ? AppThemeData.pickledBluewood800 : AppThemeData.pickledBluewood200),
        borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextCustom(title: label, color: isSelected ? AppThemeData.white : null),
    ),
  );
}

extension StringExtensions on String {
  String capitalizeText() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

Future<void> showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const TextCustom(title: 'Alert', fontSize: 18),
        content: const SingleChildScrollView(
          child: TextCustom(
            title: "Do you want to exit an App?",
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const TextCustom(
              title: 'Exit',
              fontSize: 16,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const TextCustom(
              title: 'Cancel',
              color: AppThemeData.forestGreen400,
              fontSize: 16,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

