import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaneats_owner/constant/show_toast_dialog.dart';
import 'package:scaneats_owner/utils/DarkThemeProvider.dart';
import 'package:scaneats_owner/widgets/container_custom.dart';
import 'package:scaneats_owner/widgets/global_widgets.dart';
import 'package:scaneats_owner/widgets/rounded_button_fill.dart';
import 'package:scaneats_owner/widgets/text_widget.dart';

import '../theme/app_theme_data.dart';

class PickUpImageWidget extends StatefulWidget {
  const PickUpImageWidget({super.key});

  @override
  State<PickUpImageWidget> createState() => _PickUpImageWidgetState();
}

class _PickUpImageWidgetState extends State<PickUpImageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    if (kIsWeb) {
      pickFile(source: ImageSource.gallery);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return kIsWeb
        ? const SizedBox()
        : AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: const TextCustom(title: 'Select any one option', fontSize: 18),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 1,
                    child: ContainerCustom(
                      color: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood50,
                    ),
                  ),
                  spaceH(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text("Camera"),
                            ),
                          ],
                        ),
                      ),
                      spaceW(width: 10),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Text("Gallery"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RoundedButtonFill(
                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                  width: 80,
                  radius: 8,
                  height: 40,
                  fontSizes: 14,
                  title: "Close",
                  icon: SvgPicture.asset('assets/icons/close.svg',
                      height: 20, width: 20, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800),
                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood800,
                  isRight: false,
                  onPress: () {
                    Get.back();
                  }),
            ],
          );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image != null) {
        Get.back(result: image);
      } else {
        Get.back();
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
