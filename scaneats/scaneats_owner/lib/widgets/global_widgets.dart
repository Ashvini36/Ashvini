import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/responsive/responsive.dart';
import 'package:scaneats_owner/theme/app_theme_data.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

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
      Responsive.isMobile(Get.context!)
          ? SizedBox(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onChangeOne,
                    child: Row(
                      children: [
                        parameter == radioOne
                            ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                            : Icon(Icons.circle_outlined, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                        spaceW(width: 4),
                        TextCustom(title: radioOne, maxLine: 2)
                      ],
                    ),
                  ),
                  spaceH(height: 10),
                  GestureDetector(
                    onTap: onChangeTwo,
                    child: Row(children: [
                      parameter == radioTwo
                          ? Icon(Icons.radio_button_checked, color: AppThemeData.crusta500, size: 18)
                          : Icon(Icons.circle_outlined, color: themeChange.getThem() ? AppThemeData.pickledBluewood100 : AppThemeData.pickledBluewood950, size: 18),
                      spaceW(width: 4),
                      TextCustom(title: radioTwo, maxLine: 2)
                    ]),
                  )
                ],
              ))
          : SizedBox(
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
                          TextCustom(title: radioOne, maxLine: 2)
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
                        TextCustom(title: radioTwo, maxLine: 2)
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
        color: isSelected ? AppThemeData.pickledBluewood700 : null,
        border: Border.all(color: isDarkMode ? AppThemeData.pickledBluewood800 : AppThemeData.pickledBluewood200),
        borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: TextCustom(title: label, color: isSelected ? AppThemeData.white : null),
    ),
  );
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

String ddmmDate(DateTime date) {
  return DateFormat.MMMd().format(date);
}

Timestamp dateTimeToStep(DateTime date) {
  DateTime time = date.copyWith(hour: 0, minute: 00);
  printLog(DateFormat('dd-MM-yyyy HH:mm:a').format(time).toString());
  return Timestamp.fromDate(time);
}

DateFormat graphDate({required String time}) {
  if (time == 'Year') {
    return DateFormat.MMM();
  } else if (time == 'Month') {
    return DateFormat.MMMd();
  } else {
    return DateFormat.yMd();
  }
}

DateTime dateTimeToDate(DateTime date, select) {
  DateTime time = date;
  if (select == 'Year') {
    time = date.copyWith(day: 0, month: date.month, year: date.year, hour: 0, minute: 00, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  } else if (select == 'Month') {
    time = date.copyWith(day: date.day, month: date.month, year: date.year, hour: 0, minute: 00, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  } else {
    time = date.copyWith(day: date.day, month: date.month, year: date.year, hour: 0, minute: 00, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  }
  return time;
}

DateTime selectDateTime(String select) {
  DateTime date = DateTime.now();
  DateTime today = DateTime.now();
  if (select == 'Year') {
    date = date.copyWith(day: 1, month: 1, year: today.year, hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  } else if (select == 'Month') {
    date = date.copyWith(day: 1, month: today.month, year: today.year, hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  } else {
    date = date.copyWith(day: 1, month: 1, year: today.year, hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0, isUtc: true);
  }
  return date;
}
