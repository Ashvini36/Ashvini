import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  Future<UserModel?> loginAPI(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.userLogin), headers: API.authheader, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'].toString() == 'success') {
        ShowToastDialog.closeLoader();

        Preferences.setString(Preferences.accesstoken, responseBody['data']['accesstoken'].toString());
        Preferences.setString(Preferences.admincommissiontype, responseBody['data']['commision_type'].toString());

        Preferences.setString(Preferences.admincommission, responseBody['data']['admin_commission'].toString());
        Preferences.setString(Preferences.walletBalance, responseBody['data']['amount'].toString());
        Preferences.setBoolean(Preferences.documentVerified, responseBody['data']['is_verified'].toString() == "1" ? true : false);
        log("--${responseBody['data']}");
        API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
        return UserModel.fromJson(responseBody);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error'].toString());
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
