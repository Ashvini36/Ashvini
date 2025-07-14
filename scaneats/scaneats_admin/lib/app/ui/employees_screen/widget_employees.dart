import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaneats/app/controller/employees_controller.dart';
import 'package:scaneats/app/model/branch_model.dart';
import 'package:scaneats/app/model/role_model.dart';
import 'package:scaneats/constant/constant.dart';
import 'package:scaneats/constant/show_toast_dialog.dart';
import 'package:scaneats/responsive/responsive.dart';
import 'package:scaneats/theme/app_theme_data.dart';
import 'package:scaneats/utils/DarkThemeProvider.dart';
import 'package:scaneats/utils/fire_store_utils.dart';
import 'package:scaneats/widgets/container_custom.dart';
import 'package:scaneats/widgets/global_widgets.dart';
import 'package:scaneats/widgets/network_image_widget.dart';
import 'package:scaneats/widgets/pagination.dart';
import 'package:scaneats/widgets/pickup_image_widget.dart';
import 'package:scaneats/widgets/rounded_button_fill.dart';
import 'package:scaneats/widgets/text_field_widget.dart';
import 'package:scaneats/widgets/text_widget.dart';

class AllEmployeesWidget extends StatelessWidget {
  const AllEmployeesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: EmployeesController(),
        builder: (controller) {
          return Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Responsive.isMobile(context)
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceH(),
                            const TextCustom(title: 'Dashboard', fontSize: 20, fontFamily: AppThemeData.medium),
                            Row(
                              children: [
                                const TextCustom(title: 'Dashboard', fontSize: 14, fontFamily: AppThemeData.medium, isUnderLine: true, color: AppThemeData.pickledBluewood600),
                                const TextCustom(title: ' > ', fontSize: 14, fontFamily: AppThemeData.medium, color: AppThemeData.pickledBluewood600),
                                TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: AppThemeData.medium),
                                spaceH(height: 20),
                              ],
                            )
                          ],
                        ),
                  SingleChildScrollView(
                    child: ContainerCustom(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Row(
                          children: [
                            Responsive.isMobile(context)
                                ? const SizedBox()
                                : Expanded(
                                    child: TextCustom(
                                        title: '${controller.title.value} (${controller.customerList.length})', maxLine: 1, fontSize: 18, fontFamily: AppThemeData.semiBold)),
                            Expanded(
                              child: Row(mainAxisAlignment: Responsive.isMobile(context) ? MainAxisAlignment.start : MainAxisAlignment.end, children: [
                                // if (!Responsive.isMobile(context)) spaceW(),
                                // const FilterPopUp(),
                                // spaceW(),
                                // const ExportPopUp(),
                                // spaceW(),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                    ),
                                    value: controller.totalItemPerPage.value,
                                    hint: const TextCustom(title: 'Select'),
                                    onChanged: (String? newValue) {
                                      controller.setPagition(newValue!);
                                    },
                                    decoration: InputDecoration(
                                        iconColor: AppThemeData.crusta500,
                                        isDense: true,
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.black : AppThemeData.white,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500),
                                        ),
                                        hintText: "Select",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.pickledBluewood600 : AppThemeData.pickledBluewood950,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppThemeData.medium)),
                                    items: Constant.numofpageitemList.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: TextCustom(
                                          title: value,
                                          fontFamily: AppThemeData.medium,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood500,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                spaceW(),

                                Constant.selectedRole.permission!.firstWhere((element) => element.title == "Employees").isUpdate == false
                                    ? const SizedBox()
                                    : RoundedButtonFill(
                                        isRight: true,
                                        icon: SvgPicture.asset(
                                          'assets/icons/plus.svg',
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.cover,
                                          color: AppThemeData.pickledBluewood50,
                                        ),
                                        width: 145,
                                        radius: 6,
                                        height: 40,
                                        fontSizes: 14,
                                        title: "Add ${controller.title.value}",
                                        color: AppThemeData.crusta500,
                                        textColor: AppThemeData.pickledBluewood50,
                                        onPress: () {
                                          if (int.parse(Constant.restaurantModel.subscription!.noOfEmployee.toString()) > controller.customerList.length) {
                                            controller.isNotAdded.value = false;
                                            showGlobalDrawer(
                                                duration: const Duration(milliseconds: 400),
                                                barrierDismissible: true,
                                                context: context,
                                                builder: horizontalDrawerBuilder(),
                                                direction: AxisDirection.right);
                                          } else {
                                            ShowToastDialog.showToast(
                                                "Your subscription has reached its maximum limit. Please consider extending it to continue accessing our services.");
                                          }
                                        }),
                              ]),
                            ),
                          ],
                        ),
                        spaceH(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            child: controller.customerList.isEmpty
                                ? Constant.loaderWithNoFound(context, isLoading: controller.isUserLoading.value, isNotFound: controller.customerList.isEmpty)
                                : DataTable(
                                    horizontalMargin: 20,
                                    columnSpacing: 30,
                                    dataRowMaxHeight: 70,
                                    border: TableBorder.all(
                                      color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    headingRowColor:
                                        MaterialStateColor.resolveWith((states) => themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood50),
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.15 : MediaQuery.of(context).size.width * 0.17,
                                          child: const Row(
                                            children: [
                                              TextCustom(title: 'Name'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          child: const Row(
                                            children: [
                                              TextCustom(title: 'Email'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.105,
                                          child: const TextCustom(title: 'Phone Number'),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10,
                                          child: const TextCustom(title: 'Role'),
                                        ),
                                      ),
                                      DataColumn(
                                        label: SizedBox(
                                          width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08,
                                          child: const TextCustom(title: 'Status'),
                                        ),
                                      ),
                                      DataColumn(
                                          label: SizedBox(
                                        width: Responsive.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10,
                                        child: const TextCustom(title: 'Actions'),
                                      ))
                                    ],
                                    rows: controller.currentPageUser
                                        .map(
                                          (e) => DataRow(
                                            cells: [
                                              DataCell(InkWell(
                                                onTap: () {
                                                  controller.editCustomerData(e);
                                                  controller.isNotAdded.value = false;
                                                  showGlobalDrawer(
                                                      duration: const Duration(milliseconds: 200),
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: horizontalDrawerBuilder(isEdit: true, isSave: false),
                                                      direction: AxisDirection.right);
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: NetworkImageWidget(imageUrl: e.profileImage ?? '', placeHolderUrl: Constant.userPlaceholderURL, height: 30, width: 30)),
                                                    spaceW(),
                                                    TextCustom(fontFamily: AppThemeData.medium, title: e.name ?? ''),
                                                  ],
                                                ),
                                              )),
                                              DataCell(TextCustom(title: e.email ?? '')),
                                              DataCell(TextCustom(title: e.mobileNo ?? '')),
                                              DataCell(FutureBuilder<RoleModel?>(
                                                future: FireStoreUtils.getRoleById(roleId: e.roleId.toString()), // async work
                                                builder: (BuildContext context, AsyncSnapshot<RoleModel?> snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.waiting:
                                                      return const TextCustom(title: 'Loading...');
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Text('Error: ${snapshot.error}');
                                                      } else {
                                                        return TextCustom(title: snapshot.data!.title ?? '');
                                                      }
                                                  }
                                                },
                                              )),
                                              DataCell(
                                                e.isActive == true
                                                    ? Center(child: SvgPicture.asset("assets/icons/ic_active.svg"))
                                                    : Center(child: SvgPicture.asset("assets/icons/ic_inactive.svg")),
                                              ),
                                              DataCell(
                                                Row(
                                                  children: [
                                                    Constant.selectedRole.permission!.firstWhere((element) => element.title == "Employees").isUpdate == false
                                                        ? const SizedBox()
                                                        : IconButton(
                                                            onPressed: () {
                                                              controller.editCustomerData(e);
                                                              controller.isNotAdded.value = false;
                                                              showGlobalDrawer(
                                                                  duration: const Duration(milliseconds: 200),
                                                                  barrierDismissible: true,
                                                                  context: context,
                                                                  builder: horizontalDrawerBuilder(isEdit: true),
                                                                  direction: AxisDirection.right);
                                                            },
                                                            icon: const Icon(
                                                              Icons.edit,
                                                              size: 20,
                                                            )),
                                                    spaceW(),
                                                    IconButton(
                                                      onPressed: () {
                                                        controller.editCustomerData(e);
                                                        controller.isNotAdded.value = false;
                                                        showGlobalDrawer(
                                                            duration: const Duration(milliseconds: 200),
                                                            barrierDismissible: true,
                                                            context: context,
                                                            builder: horizontalDrawerBuilder(isEdit: true, isSave: false),
                                                            direction: AxisDirection.right);
                                                      },
                                                      icon: const Icon(
                                                        Icons.visibility_outlined,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    spaceW(),
                                                    Constant.selectedRole.permission!.firstWhere((element) => element.title == "Employees").isDelete == false
                                                        ? const SizedBox()
                                                        : IconButton(
                                                            onPressed: () {
                                                              if (Constant.isDemo()) {
                                                                ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                                              } else {
                                                                controller.deleteUser(e);
                                                              }
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete_outline_outlined,
                                                              size: 20,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList()),
                          ),
                        ),
                        spaceH(),
                        Visibility(
                          visible: controller.totalPage.value > 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: WebPagination(
                                    isDark: themeChange.getThem(),
                                    currentPage: controller.currentPage.value,
                                    totalPage: controller.totalPage.value,
                                    displayItemCount: controller.pageValue(controller.totalItemPerPage.value),
                                    onPageChanged: (page) {
                                      controller.currentPage.value = page;
                                      controller.setPagition(controller.totalItemPerPage.value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ));
        });
  }
}

class FilterPopUp extends StatelessWidget {
  const FilterPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          return ContainerBorderCustom(
            radius: 6,
            fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
            color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
            child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                child: SizedBox(
                  width: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(title: controller.selectedfilter.value == '' ? 'Filters' : controller.selectedfilter.value, fontSize: 15, fontFamily: AppThemeData.medium),
                      SvgPicture.asset(
                        'assets/icons/filter.svg',
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                        color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950,
                      ),
                    ],
                  ),
                ),
                onSelected: (value) {
                  controller.selectedfilter.value = value;
                },
                itemBuilder: (BuildContext bc) {
                  return controller.filterList
                      .map((e) => PopupMenuItem(
                            height: 30,
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black, fontFamily: AppThemeData.medium)),
                              ],
                            ),
                          ))
                      .toList();
                }),
          );
        });
  }
}

class ExportPopUp extends StatelessWidget {
  const ExportPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          return ContainerBorderCustom(
            radius: 6,
            fillColor: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100,
            color: themeChange.getThem() ? AppThemeData.pickledBluewood900 : AppThemeData.pickledBluewood100,
            child: PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                child: SizedBox(
                  width: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(title: controller.selectedExport.value == '' ? 'Export as' : controller.selectedExport.value, fontSize: 15, fontFamily: AppThemeData.medium),
                      SvgPicture.asset('assets/icons/down.svg',
                          height: 25, width: 25, fit: BoxFit.cover, color: themeChange.getThem() ? AppThemeData.pickledBluewood50 : AppThemeData.pickledBluewood950),
                    ],
                  ),
                ),
                onSelected: (value) {
                  controller.selectedExport.value = value;
                },
                itemBuilder: (BuildContext bc) {
                  return controller.exportAsList
                      .map((e) => PopupMenuItem(
                            height: 30,
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e, style: TextStyle(color: themeChange.getThem() ? AppThemeData.white : AppThemeData.black, fontFamily: AppThemeData.medium)),
                              ],
                            ),
                          ))
                      .toList();
                }),
          );
        });
  }
}

WidgetBuilder horizontalDrawerBuilder({bool isEdit = false, bool isSave = true}) {
  return (BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          return Drawer(
            width: 500,
            child: Container(
              width: Responsive.width(100, context),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.white, fontFamily: AppThemeData.medium),
                child: IntrinsicWidth(
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          spaceH(),
                          TextCustom(title: controller.title.value, fontSize: 20),
                          spaceH(height: 20),
                          SizedBox(height: 2, child: ContainerCustom(color: themeChange.getThem() ? AppThemeData.pickledBluewood950 : AppThemeData.pickledBluewood100)),
                          spaceH(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (ctxt) => const PickUpImageWidget()).then((value) async {
                                    if (value != null) {
                                      XFile stringFile = value;
                                      controller.profileImage.value = stringFile.path;
                                      controller.profileImageUin8List.value = await stringFile.readAsBytes();
                                    }
                                  });
                                },
                                child: Stack(alignment: Alignment.bottomCenter, children: [
                                  controller.profileImage.isEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: NetworkImageWidget(
                                            imageUrl: Constant.userPlaceholderURL,
                                            placeHolderUrl: Constant.userPlaceholderURL,
                                            fit: BoxFit.fill,
                                            height: Responsive.width(30, context),
                                            width: Responsive.width(30, context),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(60),
                                          child: Constant().hasValidUrl(controller.profileImage.value) == false
                                              ? kIsWeb
                                                  ? controller.profileImageUin8List.value.isEmpty
                                                      ? Constant.loader(
                                                          context,
                                                        )
                                                      : Image.memory(
                                                          controller.profileImageUin8List.value,
                                                          height: Responsive.width(30, context),
                                                          width: Responsive.width(30, context),
                                                          fit: BoxFit.fill,
                                                        )
                                                  : Image.file(
                                                      File(controller.profileImage.value),
                                                      height: Responsive.width(30, context),
                                                      width: Responsive.width(30, context),
                                                      fit: BoxFit.fill,
                                                    )
                                              : NetworkImageWidget(
                                                  imageUrl: controller.profileImage.value.toString(),
                                                  placeHolderUrl: Constant.userPlaceholderURL,
                                                  fit: BoxFit.fill,
                                                  height: Responsive.width(30, context),
                                                  width: Responsive.width(30, context),
                                                ),
                                        ),
                                  Positioned(
                                    bottom: 50,
                                    right: Responsive.width(36, context),
                                    child: InkWell(
                                      onTap: () {},
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.black,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              'assets/icons/ic_edit_profile.svg',
                                              width: 22,
                                              height: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          spaceH(height: 40),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.name.value,
                                  title: 'Name',
                                  isReadOnly: !isSave,
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.email.value,
                                  title: 'Email',
                                  isReadOnly: (isSave && isEdit),
                                )),
                          ]),
                          spaceH(),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: TextFieldWidget(
                                  hintText: '',
                                  controller: controller.phone.value,
                                  title: 'Phone Number',
                                  textInputType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  isReadOnly: !isSave,
                                )),
                            spaceW(width: 15),
                            Expanded(
                                flex: 1,
                                child: customRadioButton(context,
                                    parameter: controller.status.value,
                                    title: 'Status',
                                    radioOne: "Active",
                                    onChangeOne: () {
                                      if (isSave) {
                                        controller.status.value = "Active";
                                        controller.update();
                                      }
                                    },
                                    radioTwo: "Inactive",
                                    onChangeTwo: () {
                                      if (isSave) {
                                        controller.status.value = "Inactive";
                                        controller.update();
                                      }
                                    })),
                          ]),
                          spaceH(),
                          Visibility(
                            visible: !isEdit,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: TextFieldWidget(
                                      hintText: '',
                                      controller: controller.password.value,
                                      title: 'Password',
                                      obscureText: !controller.isPasswordVisible.value,
                                      //This wi
                                      suffix: IconButton(
                                        icon: Icon(
                                          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                        ),
                                        onPressed: () {
                                          controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                        },
                                      ),
                                    )),
                                spaceW(width: 15),
                                Expanded(
                                    flex: 1,
                                    child: TextFieldWidget(
                                      hintText: '',
                                      controller: controller.conPassword.value,
                                      title: 'Confirm Password',
                                      obscureText: !controller.isConformationPasswordVisible.value,
                                      //This will obscure text dynamically
                                      suffix: IconButton(
                                        icon: Icon(
                                          controller.isConformationPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                          color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                        ),
                                        onPressed: () {
                                          controller.isConformationPasswordVisible.value = !controller.isConformationPasswordVisible.value;
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const TextCustom(
                                    title: 'Role',
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField<RoleModel>(
                                    isExpanded: true,
                                    value: controller.selectedRole.value.id == null ? null : controller.selectedRole.value,
                                    hint: const TextCustom(title: 'Select Role'),
                                    onChanged: (RoleModel? newValue) {
                                      controller.selectedRole.value = newValue!;
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
                                    items: controller.roleList.map<DropdownMenuItem<RoleModel>>((RoleModel value) {
                                      return DropdownMenuItem<RoleModel>(
                                        value: value,
                                        child: TextCustom(title: value.title ?? ''),
                                      );
                                    }).toList(),
                                  ),
                                ]),
                              ),
                              spaceW(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextCustom(
                                      title: 'Select Branch',
                                      fontSize: 12,
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<BranchModel>(
                                      isExpanded: true,
                                      value: controller.selectBranchEmp.value.id == null ? null : controller.selectBranchEmp.value,
                                      hint: const TextCustom(title: 'Select Branch'),
                                      onChanged: (BranchModel? newValue) {
                                        controller.selectBranchEmp.value = newValue!;
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
                                          hintText: "Select Branch".tr,
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.pickledBluewood400 : AppThemeData.pickledBluewood950,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppThemeData.medium)),
                                      items: Constant.allBranch.map<DropdownMenuItem<BranchModel>>((BranchModel value) {
                                        return DropdownMenuItem<BranchModel>(
                                          value: value,
                                          child: TextCustom(title: value.name ?? ''),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          spaceH(height: 20),
                          CheckboxListTile(
                            title: const Text("Notification receive"),
                            value: controller.notificationReceive.value,
                            enabled: isSave,
                            activeColor: AppThemeData.crusta500,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                controller.notificationReceive.value = newValue;
                              }
                            },
                            controlAffinity: ListTileControlAffinity.trailing, //  <-- leading Checkbox
                          ),
                          spaceH(height: 20),
                          Row(
                            children: [
                              Visibility(
                                visible: isSave,
                                child: RoundedButtonFill(
                                    width: 120,
                                    radius: 8,
                                    height: 45,
                                    icon: !controller.isNotAdded.value ? const SizedBox() : Constant.loader(context, color: AppThemeData.pickledBluewood50),
                                    title: "Save",
                                    color: AppThemeData.crusta500,
                                    fontSizes: 14,
                                    textColor: AppThemeData.white,
                                    isRight: false,
                                    onPress: () {
                                      if (Constant.isDemo()) {
                                        ShowToastDialog.showToast(Constant.demoAppMsg, duration: Constant.toastDuration);
                                      } else {
                                        controller.loginUser(edit: isEdit);
                                      }
                                    }),
                              ),
                              Visibility(visible: isSave, child: spaceW(width: 15)),
                              RoundedButtonFill(
                                  borderColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  width: 120,
                                  radius: 8,
                                  height: 45,
                                  fontSizes: 14,
                                  title: "Close",
                                  textColor: themeChange.getThem() ? AppThemeData.pickledBluewood200 : AppThemeData.pickledBluewood950,
                                  isRight: false,
                                  onPress: () {
                                    controller.setDefaultData();
                                    Get.back();
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  };
}
