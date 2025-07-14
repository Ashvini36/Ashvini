import 'dart:io';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

class FileHandleApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();
    final File file;
    ShowToastDialog.showLoader("Your Invoice downloading...".tr);

    if (Platform.isAndroid) {
      file = File('/storage/emulated/0/Download/$name');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      file = File('${dir.path}/$name');
    }
    await file.writeAsBytes(bytes);
    await Future.delayed(const Duration(seconds: 1));
    await ShowToastDialog.closeLoader();
    ShowToastDialog.showToast("Invoice downloaded successfully.".tr);
    return file;
  }

  // open pdf file function
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
