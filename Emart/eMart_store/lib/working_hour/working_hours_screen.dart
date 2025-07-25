import 'package:easy_localization/easy_localization.dart';
import 'package:emartstore/constants.dart';
import 'package:emartstore/main.dart';
import 'package:emartstore/model/WorkingHoursModel.dart';
import 'package:emartstore/services/helper.dart';
import 'package:emartstore/services/show_toast_dailog.dart';
import 'package:flutter/material.dart';

import '../../model/VendorModel.dart';
import '../../services/FirebaseHelper.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({Key? key}) : super(key: key);

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  List<WorkingHoursModel> workingHoursModel = [];

  final description = TextEditingController();

  List<WorkingHoursModel> workingHours = [];

  @override
  void initState() {
    getVendor();
    super.initState();
  }

  VendorModel? vendorModel;

  getVendor() async {
    if(MyAppState.currentUser!.vendorID.isNotEmpty){
      vendorModel = await FireStoreUtils.getVendor(MyAppState.currentUser!.vendorID);
      print(MyAppState.currentUser!.vendorID);
      setState(() {
        if (vendorModel!.workingHours.isEmpty) {
          workingHours = [
            WorkingHoursModel(day: 'Monday', timeslot: []),
            WorkingHoursModel(day: 'Tuesday', timeslot: []),
            WorkingHoursModel(day: 'Wednesday', timeslot: []),
            WorkingHoursModel(day: 'Thursday', timeslot: []),
            WorkingHoursModel(day: 'Friday', timeslot: []),
            WorkingHoursModel(day: 'Saturday', timeslot: []),
            WorkingHoursModel(day: 'Sunday', timeslot: [])
          ];
        } else {
          workingHours = vendorModel!.workingHours;
        }
        //isSpecialSwitched = vendorModel!.specialDiscountEnable;
      });
    }

  }

  List<String> discountType = ['Dine-In Discount', 'Delivery Discount'];
  List<String> type = [currencyData!.symbol, '%'];
  bool isSpecialSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        "Select Working Hours".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                //visible: isSpecialSwitched,
                child: ListView.builder(
                  itemCount: workingHours.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                      ),
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    workingHours[index].day.toString(),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        workingHours[index].timeslot!.add(Timeslot(
                                              from: '',
                                              to: '',
                                            ));
                                      });
                                    },
                                    child: Icon(Icons.add_circle_sharp, color: Color(COLOR_PRIMARY), size: 36),
                                  )
                                ],
                              ),
                              ListView.builder(
                                itemCount: workingHours[index].timeslot!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index1) {
                                  return Form(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () async {
                                                  TimeOfDay? startTime = await _selectTime();
                                                  if (workingHours[index].timeslot![index1].to!.isNotEmpty) {
                                                    if (DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      startTime!.hour,
                                                      startTime.minute,
                                                    ).isAfter(DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      int.parse(workingHours[index].timeslot![index1].to.toString().split(":").first.toString()),
                                                      int.parse(workingHours[index].timeslot![index1].to.toString().split(":").last.toString()),
                                                    ))) {
                                                      workingHours[index].timeslot![index1].from = "";
                                                      ShowToastDialog.showToast("Please enter valid time");
                                                    } else {
                                                      workingHours[index].timeslot![index1].from = DateFormat('HH:mm')
                                                          .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime.hour, startTime.minute));
                                                    }
                                                  } else {
                                                    workingHours[index].timeslot![index1].from = DateFormat('HH:mm')
                                                        .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime!.hour, startTime.minute));
                                                  }
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                    border: Border.all(color: const Color(0XFFB1BCCA)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        workingHours[index].timeslot![index1].from!.isEmpty
                                                            ? 'Start Time'.tr()
                                                            : workingHours[index].timeslot![index1].from.toString(),
                                                        style: TextStyle(
                                                            color: isDarkMode(context)
                                                                ? const Color(0xFFFFFFFF)
                                                                : workingHours[index].timeslot![index1].from!.isEmpty
                                                                    ? Colors.grey
                                                                    : Colors.black,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () async {
                                                  TimeOfDay? startTime = await _selectTime();

                                                  if (workingHours[index].timeslot![index1].from!.isNotEmpty) {
                                                    if (DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      startTime!.hour,
                                                      startTime.minute,
                                                    ).isBefore(DateTime(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day,
                                                      int.parse(workingHours[index].timeslot![index1].from.toString().split(":").first.toString()),
                                                      int.parse(workingHours[index].timeslot![index1].from.toString().split(":").last.toString()),
                                                    ))) {
                                                      workingHours[index].timeslot![index1].to = "";
                                                      ShowToastDialog.showToast("Please enter valid time");
                                                    } else {
                                                      if (startTime.format(context).toString() == "12:00 AM") {
                                                        workingHours[index].timeslot![index1].to =
                                                            DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59));
                                                      } else {
                                                        setState(() {
                                                          workingHours[index].timeslot![index1].to = DateFormat('HH:mm')
                                                              .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime.hour, startTime.minute));
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    if (startTime!.format(context).toString() == "12:00 AM") {
                                                      workingHours[index].timeslot![index1].to =
                                                          DateFormat('HH:mm').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59));
                                                    } else {
                                                      setState(() {
                                                        workingHours[index].timeslot![index1].to = DateFormat('HH:mm')
                                                            .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, startTime.hour, startTime.minute));
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                    border: Border.all(color: const Color(0XFFB1BCCA)),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        workingHours[index].timeslot![index1].to!.isEmpty ? 'End Time'.tr() : workingHours[index].timeslot![index1].to.toString(),
                                                        style: TextStyle(
                                                            color: isDarkMode(context)
                                                                ? const Color(0xFFFFFFFF)
                                                                : workingHours[index].timeslot![index1].to!.isEmpty
                                                                    ? Colors.grey
                                                                    : Colors.black,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              // Expanded(
                                              //   child: TextFormField(
                                              //       textAlignVertical: TextAlignVertical.center,
                                              //       textInputAction: TextInputAction.next,
                                              //       initialValue: specialDiscount[index].timeslot![index1].discount,
                                              //       onChanged: (text) {
                                              //         setState(() {
                                              //           specialDiscount[index].timeslot![index1].discount = text;
                                              //         });
                                              //       },
                                              //       cursorColor: Color(COLOR_PRIMARY),
                                              //       keyboardType: TextInputType.number,
                                              //       decoration: InputDecoration(
                                              //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                              //         hintText: 'Discount',
                                              //         focusedBorder: OutlineInputBorder(
                                              //           borderSide: BorderSide(color: Color(COLOR_PRIMARY)),
                                              //         ),
                                              //         hintStyle: TextStyle(
                                              //           color: isDarkMode(context)
                                              //               ? Color(0xFFFFFFFF)
                                              //               : specialDiscount[index].timeslot![index1].to!.isEmpty
                                              //                   ? Colors.grey
                                              //                   : Colors.black,
                                              //         ),
                                              //         suffix: Text(specialDiscount[index].timeslot![index1].type == "amount" ? symbol : "%"),
                                              //         enabledBorder: OutlineInputBorder(
                                              //           borderSide: BorderSide(color: Color(0XFFB1BCCA)),
                                              //           // borderRadius: BorderRadius.circular(8.0),
                                              //         ),
                                              //       )),
                                              // ),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    workingHours[index].timeslot!.removeAt(index1);
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(top: 10),
                                          //   child: Row(
                                          //     children: [
                                          //       Container(
                                          //         decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.all(Radius.circular(4)),
                                          //           border: Border.all(color: Color(0XFFB1BCCA)),
                                          //         ),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.symmetric(horizontal: 10),
                                          //           child: DropdownButton<String>(
                                          //             underline: SizedBox(),
                                          //             value: specialDiscount[index].timeslot![index1].discount_type == "dinein"
                                          //                 ? "Dine-In Discount"
                                          //                 : "Delivery Discount",
                                          //             onChanged: (newValue) {
                                          //               if (newValue == "Dine-In Discount") {
                                          //                 setState(() {
                                          //                   specialDiscount[index].timeslot![index1].discount_type = "dinein";
                                          //                 });
                                          //               } else {
                                          //                 setState(() {
                                          //                   specialDiscount[index].timeslot![index1].discount_type = "delivery";
                                          //                 });
                                          //               }
                                          //               print(newValue);
                                          //               print(specialDiscount[index].timeslot![index1].discount_type);
                                          //             },
                                          //             style: TextStyle(
                                          //               color: isDarkMode(context)
                                          //                   ? Color(0xFFFFFFFF)
                                          //                   : specialDiscount[index].timeslot![index1].to!.isEmpty
                                          //                       ? Colors.grey
                                          //                       : Colors.black,
                                          //             ),
                                          //             items: discountType.map((String user) {
                                          //               return DropdownMenuItem<String>(
                                          //                 value: user,
                                          //                 child: new Text(
                                          //                   user,
                                          //                   style: new TextStyle(
                                          //                     color: isDarkMode(context)
                                          //                         ? Color(0xFFFFFFFF)
                                          //                         : specialDiscount[index].timeslot![index1].to!.isEmpty
                                          //                             ? Colors.grey
                                          //                             : Colors.black,
                                          //                   ),
                                          //                 ),
                                          //               );
                                          //             }).toList(),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       SizedBox(
                                          //         width: 10,
                                          //       ),
                                          //       Container(
                                          //         decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.all(Radius.circular(4)),
                                          //           border: Border.all(color: Color(0XFFB1BCCA)),
                                          //         ),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.symmetric(horizontal: 10),
                                          //           child: DropdownButton<String>(
                                          //             underline: SizedBox(),
                                          //             value: specialDiscount[index].timeslot![index1].type == "amount" ? symbol : "%",
                                          //             onChanged: (newValue) {
                                          //               if (newValue == symbol) {
                                          //                 setState(() {
                                          //                   specialDiscount[index].timeslot![index1].type = "amount";
                                          //                 });
                                          //               } else {
                                          //                 setState(() {
                                          //                   specialDiscount[index].timeslot![index1].type = "percentage";
                                          //                 });
                                          //               }
                                          //               print(newValue);
                                          //               print(specialDiscount[index].timeslot![index1].type);
                                          //             },
                                          //             style: TextStyle(
                                          //               color: isDarkMode(context)
                                          //                   ? Color(0xFFFFFFFF)
                                          //                   : specialDiscount[index].timeslot![index1].to!.isEmpty
                                          //                       ? Colors.grey
                                          //                       : Colors.black,
                                          //             ),
                                          //             items: type.map((String user) {
                                          //               return DropdownMenuItem<String>(
                                          //                 value: user,
                                          //                 child: new Text(
                                          //                   user,
                                          //                   style: new TextStyle(
                                          //                     color: isDarkMode(context)
                                          //                         ? Color(0xFFFFFFFF)
                                          //                         : specialDiscount[index].timeslot![index1].to!.isEmpty
                                          //                             ? Colors.grey
                                          //                             : Colors.black,
                                          //                   ),
                                          //                 ),
                                          //               );
                                          //             }).toList(),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            backgroundColor: Color(COLOR_PRIMARY),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Color(COLOR_PRIMARY),
              ),
            ),
          ),
          onPressed: () {
            if (MyAppState.currentUser!.vendorID.isEmpty) {
              final snackBar = SnackBar(
                content: Text('Please add a store first').tr(),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              bool isEmptyField = false;
              print(MyAppState.currentUser!.vendorID);
              workingHours.forEach((element) {
                print(element.day);
                // print(element.timeslot![0].from);
                // print(element.timeslot![0].to);

                var emptyList = element.timeslot!.where((element) => element.from!.isEmpty || element.to!.isEmpty);
                if (element.timeslot!.isNotEmpty && emptyList.isNotEmpty && !isEmptyField) {
                  final snackBar = SnackBar(
                    content: Text('Please enter valid details').tr(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  isEmptyField = true;
                }
              });
              if (!isEmptyField) {
                saveWorkingHours();
              }
            }
          },
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode(context) ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  saveWorkingHours() async {
    ShowToastDialog.showLoader("Please wait..");
    FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    if (vendorModel != null) {
      vendorModel!.workingHours = workingHours;

      await FireStoreUtils.updateVendor(vendorModel!).then((value) async {
        ShowToastDialog.showToast("Working hours Updated!");
      });
    }
  }

  Future<TimeOfDay?> _selectTime() async {
    FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      return newTime;
    }
    return null;
  }
}
