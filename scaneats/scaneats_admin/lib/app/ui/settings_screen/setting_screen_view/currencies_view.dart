import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/settting_currencies_controller.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class CurrenciesView extends StatelessWidget {
  const CurrenciesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        global: true,
        init: SettingsCurrenciesController(),
        builder: (controller) {
          return ContainerCustom(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(title: controller.title.value, fontFamily: AppThemeData.bold, fontSize: 18),
                    RoundedButtonFill(
                        radius: 6,
                        width: 170,
                        height: 40,
                        icon: SvgPicture.asset('assets/icons/plus.svg', height: 20, width: 20, fit: BoxFit.cover, color: AppThemeData.pickledBluewood50),
                        title: "Add Currencies",
                        color: AppThemeData.crusta500,
                        fontSizes: 14,
                        textColor: AppThemeData.white,
                        isRight: false,
                        onPress: () async {
                          controller.reset();
                          showDialog(context: context, builder: (ctxt) => const AddCurrenciesDialog());
                        }),
                  ],
                ),
                spaceH(height: 20),
                devider(context, height: 2),
                spaceH(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: controller.currenciesList.isEmpty
                      ? Constant.loaderWithNoFound(context, isLoading: controller.isgetItemLoading.value, isNotFound: controller.currenciesList.isEmpty)
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          child: DataTable(
                              horizontalMargin: 20,
                              columnSpacing: 30,
                              dataRowMaxHeight: 70,
                              border: TableBorder.all(
                                color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                              columns: [
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.1,
                                    child: const TextCustom(title: 'NAME'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.05,
                                    child: const TextCustom(title: 'SYMBOL'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? 140 : MediaQuery.of(context).size.width * 0.05,
                                    child: const TextCustom(title: 'SYMBOL\nAT RIGHT'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.05,
                                    child: const TextCustom(title: 'DECIMAL\nDIGIT'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? 90 : MediaQuery.of(context).size.width * 0.05,
                                    child: const TextCustom(title: 'CODE'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.04,
                                    child: const TextCustom(title: 'STATUS'),
                                  ),
                                ),
                                DataColumn(
                                  label: SizedBox(
                                    width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.25 : MediaQuery.of(context).size.width * 0.1,
                                    child: const TextCustom(title: 'ACTION'),
                                  ),
                                ),
                              ],
                              rows: controller.currenciesList
                                  .map(
                                    (e) => DataRow(
                                      cells: [
                                        DataCell(TextCustom(title: e.name ?? '')),
                                        DataCell(TextCustom(title: e.symbol ?? '')),
                                        DataCell(TextCustom(title: e.symbolAtRight.toString().toUpperCase())),
                                        DataCell(TextCustom(title: e.decimalDigits ?? '')),
                                        DataCell(TextCustom(title: e.code ?? '')),
                                        DataCell(
                                          e.isActive == true
                                              ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                              : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    controller.setEditValue(e);
                                                    showDialog(
                                                        context: context,
                                                        builder: (ctxt) => AddCurrenciesDialog(
                                                              itemCategoryId: e.id.toString(),
                                                              isEdit: true,
                                                            ));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                  )),
                                              spaceW(),
                                              IconButton(
                                                onPressed: () {
                                                  controller.setEditValue(e);
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctxt) => AddCurrenciesDialog(
                                                            itemCategoryId: e.id.toString(),
                                                            isReadOnly: true,
                                                          ));
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 20,
                                                ),
                                              ),
                                              spaceW(),
                                              IconButton(
                                                  onPressed: () {
                                                    if (Constant.isDemo()) {
                                                      ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                    } else {
                                                      controller.deleteByItemAttributeId(e.id.toString());
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline_outlined,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()),
                        ),
                ),
              ],
            ),
          );
        });
  }
}

class AddCurrenciesDialog extends StatelessWidget {
  final bool isEdit;
  final bool isReadOnly;
  final String? itemCategoryId;

  const AddCurrenciesDialog({super.key, this.isEdit = false, this.isReadOnly = false, this.itemCategoryId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsCurrenciesController(),
        builder: (controller) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            title: TextCustom(
                title: isEdit == true
                    ? 'Edit Currency'
                    : isReadOnly == true
                        ? 'View Currency'
                        : 'Add Currency',
                fontSize: 18),
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
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(child: TextFieldWidget(hintText: '', controller: controller.nameController.value, title: 'Name')),
                    spaceW(width: 20),
                    Expanded(
                      child: TextFieldWidget(hintText: '', controller: controller.symbolController.value, title: 'Symbol'),
                    ),
                  ]),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          hintText: '',
                          controller: controller.decimalDigitController.value,
                          title: 'Decimal digit',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        child: TextFieldWidget(hintText: '', controller: controller.codeController.value, title: 'Code'),
                      ),
                    ],
                  ),
                  spaceH(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Symbol At Right".toUpperCase(),
                              fontSize: 12,
                            ),
                            spaceH(),
                            DropdownButtonFormField<bool>(
                              isExpanded: true,
                              value: controller.selectedSymbolAtRight.value,
                              hint: const TextCustom(title: 'Symbol At Right'),
                              onChanged: (bool? newValue) {
                                controller.selectedSymbolAtRight.value = newValue!;
                                controller.update();
                              },
                              decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontFamily: AppThemeData.medium, fontSize: 14, color: Colors.red),
                                  isDense: true,
                                  filled: true,
                                  fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.pickledBluewood100,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
                                    ),
                                  ),
                                  hintText: "Select Role".tr,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppThemeData.medium)),
                              items: Constant.booleanList.map<DropdownMenuItem<bool>>((bool value) {
                                return DropdownMenuItem<bool>(
                                  value: value,
                                  child: TextCustom(title: value.toString().toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      spaceW(width: 20),
                      Expanded(
                        flex: 1,
                        child: customRadioButton(context,
                            parameter: controller.status.value,
                            title: 'STATUS',
                            radioOne: "Active",
                            onChangeOne: () {
                              controller.status.value = "Active";
                              controller.update();
                            },
                            radioTwo: "Inactive",
                            onChangeTwo: () {
                              controller.status.value = "Inactive";
                              controller.update();
                            }),
                      ),
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
              Visibility(
                visible: !isReadOnly,
                child: RoundedButtonFill(
                    width: 80,
                    radius: 8,
                    height: 40,
                    fontSizes: 14,
                    title: "Save",
                    icon: controller.isaddItemLoading.value == true
                        ? Constant.loader(context, color: AppThemeData.white)
                        : const Icon(Icons.check_circle_outline, color: AppThemeData.white, size: 20),
                    color: AppThemeData.crusta500,
                    textColor: AppThemeData.white,
                    isRight: false,
                    onPress: () {
                      if (Constant.isDemo()) {
                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                      } else {
                        if (controller.nameController.value.text != '' &&
                            controller.symbolController.value.text != '' &&
                            controller.codeController.value.text != '' &&
                            controller.decimalDigitController.value.text != '') {
                          controller.addCurrenciesData(itemCategoryId: itemCategoryId ?? '', isEdit: isEdit);
                        } else {
                          ShowToastDialog.showToast("All fields are required. Please fill them out.");
                        }
                      }
                    }),
              ),
            ],
          );
        });
  }
}
