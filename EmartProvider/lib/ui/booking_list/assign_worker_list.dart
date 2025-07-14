import 'package:emartprovider/constant/constants.dart';
import 'package:emartprovider/constant/show_toast_dialog.dart';
import 'package:emartprovider/controller/assign_worker_controller.dart';
import 'package:emartprovider/model/worker_model.dart';
import 'package:emartprovider/services/firebase_helper.dart';
import 'package:emartprovider/services/send_notification.dart';
import 'package:emartprovider/themes/app_colors.dart';
import 'package:emartprovider/utils/dark_theme_provider.dart';
import 'package:emartprovider/widgets/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AssignWorkerList extends StatelessWidget {
  const AssignWorkerList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<AssignWorkerController>(
        init: AssignWorkerController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getTheme() ? AppColors.colorDark : AppColors.colorWhite,
            appBar: CommonUI.customAppBar(context,
                title: Text(
                  "Worker List".tr,
                  style: TextStyle(color: themeChange.getTheme() ? Colors.white : AppColors.colorDark, fontSize: 18, fontFamily: AppColors.semiBold),
                ),
                isBack: true),
            body: controller.workerModel.isEmpty
                ? emptyView(text: "No online worker available", themeChange: themeChange)
                : ListView.builder(
                    itemCount: controller.workerModel.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      WorkerModel worker = controller.workerModel[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                            color: themeChange.getTheme() ? AppColors.darkContainerBorderColor : AppColors.colorLightGrey,
                          ),
                          child: RadioListTile(
                            selectedTileColor: AppColors.colorPrimary,
                            activeColor: AppColors.colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: controller.selectedWorkerRadioTile.value == worker.id ? AppColors.colorPrimary : Colors.transparent)),
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: worker.id,
                            groupValue: controller.selectedWorkerRadioTile.value,
                            onChanged: (value) {
                              controller.selectedWorkerRadioTile.value = value.toString();
                              controller.fcmToken.value = worker.fcmToken.toString();
                              controller.update();
                            },

                            selected: controller.selectedWorkerRadioTile.value == worker.id ? true : false,

                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: worker.profilePictureURL != ""
                                        ? CircleAvatar(backgroundImage: NetworkImage(worker.profilePictureURL.toString()), radius: 30.0)
                                        : CircleAvatar(backgroundImage: NetworkImage(placeholderImage), radius: 30.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      worker.fullName().toString(),
                                      style: TextStyle(color: themeChange.getTheme() ? Colors.white : AppColors.colorDark, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                        child: Text(
                                          "Online".tr,
                                          style: const TextStyle(
                                            color: AppColors.colorWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //toggleable: true,
                          ),
                        ),
                      );
                    }),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: AppColors.colorPrimary),
                    ),
                    backgroundColor: AppColors.colorPrimary),
                onPressed: () async {
                  if (controller.selectedWorkerRadioTile.value.isEmpty) {
                    ShowToastDialog.showToast('Please select worker.'.tr);
                  } else {
                    ShowToastDialog.showLoader('Please wait...');
                    controller.onProviderOrder.value.workerId = controller.selectedWorkerRadioTile.value.toString();
                    controller.onProviderOrder.value.status = ORDER_STATUS_ASSIGNED;
                    await FireStoreUtils.updateOrder(controller.onProviderOrder.value);
                    Map<String, dynamic> payLoad = <String, dynamic>{"type": "provider_order", "orderId": controller.onProviderOrder.value.id};
                    await SendNotification.sendFcmMessage(workerBookingAssigned, controller.fcmToken.value, payLoad);

                    Get.back();
                    ShowToastDialog.closeLoader();
                  }
                },
                child: Text(
                  'Assign'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeChange.getTheme() ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
