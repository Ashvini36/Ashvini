import 'dart:io';

import 'package:ebasket_customer/app/model/mail_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/widgets/permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> showLoadingDialog(title) async {
  return Get.dialog(Center(
    child: Container(
      decoration: BoxDecoration(color: AppThemeData.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(backgroundColor: AppThemeData.groceryAppDarkBlue.withOpacity(0.20), valueColor:  AlwaysStoppedAnimation<Color>(AppThemeData.groceryAppDarkBlue)),
          const SizedBox(
            height: 10,
          ),
          Text(
            title.toString(),
            style: const TextStyle(color: AppThemeData.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
          )
        ]),
      ),
    ),
  ));
}

void checkPermission(Function() onTap) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied) {
    ShowToastDialog.showToast("You have to allow location permission to use your location");
  } else if (permission == LocationPermission.deniedForever) {
    Get.dialog(const PermissionDialog());
  } else {
    onTap();
  }
}

showAlertDialog(BuildContext context, String title, String content, bool addOkButton) {
  // set up the AlertDialog
  Widget? okButton;
  if (addOkButton) {
    okButton = TextButton(
      child: Text('ok'.tr),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
  if (Platform.isIOS) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [if (okButton != null) okButton],
    );
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  } else {
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(content), actions: [if (okButton != null) okButton]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

 MailSettings? mailSettings;

final smtpServer = SmtpServer(mailSettings!.host.toString(),
username: mailSettings!.userName.toString(), password: mailSettings!.password.toString(), port: 465, ignoreBadCertificate: false, ssl: true, allowInsecure: true);

 sendMail({String? subject, String? body, bool? isAdmin = false, List<dynamic>? recipients}) async {
// Create our message.
if (isAdmin == true) {
recipients!.add(mailSettings!.userName.toString());
}
final message = Message()
..from = Address(mailSettings!.userName.toString(), mailSettings!.fromName.toString())
..recipients = recipients!
..subject = subject
..text = body
..html = body;

try {
final sendReport = await send(message, smtpServer);
print('Message sent: ' + sendReport.toString());
} on MailerException catch (e) {
print(e);
print('Message not sent.');
for (var p in e.problems) {
print('Problem: ${p.code}: ${p.msg}');
}
}
}
