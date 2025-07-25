import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emartconsumer/constants.dart';
import 'package:emartconsumer/main.dart';
import 'package:emartconsumer/model/User.dart';
import 'package:emartconsumer/model/inbox_model.dart';
import 'package:emartconsumer/services/FirebaseHelper.dart';
import 'package:emartconsumer/services/helper.dart';
import 'package:emartconsumer/theme/app_them_data.dart';
import 'package:emartconsumer/ui/chat_screen/chat_screen.dart';
import 'package:emartconsumer/widget/firebase_pagination/src/firestore_pagination.dart';
import 'package:emartconsumer/widget/firebase_pagination/src/models/view_type.dart';
import 'package:flutter/material.dart';


class InboxDriverScreen extends StatefulWidget {
  const InboxDriverScreen({Key? key}) : super(key: key);

  @override
  State<InboxDriverScreen> createState() => _InboxDriverScreenState();
}

class _InboxDriverScreenState extends State<InboxDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? AppThemeData.surfaceDark : AppThemeData.surface,
      body: FirestorePagination(
        //item builder type is compulsory.
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map<String, dynamic>?;
          InboxModel inboxModel = InboxModel.fromJson(data!);
          return InkWell(
            onTap: () async {
              await showProgress("Please wait...".tr(), false);

              User? customer = await FireStoreUtils.getCurrentUser(inboxModel.customerId.toString());
              User? restaurantUser = await FireStoreUtils.getCurrentUser(inboxModel.restaurantId.toString());
              await hideProgress();
              push(
                  context,
                  ChatScreens(
                    customerName: customer!.firstName + " " + customer.lastName,
                    restaurantName: restaurantUser!.firstName + " " + restaurantUser.lastName,
                    orderId: inboxModel.orderId,
                    restaurantId: restaurantUser.userID,
                    customerId: customer.userID,
                    customerProfileImage: customer.profilePictureURL,
                    restaurantProfileImage: restaurantUser.profilePictureURL,
                    token: restaurantUser.fcmToken,
                    chatType: inboxModel.chatType,
                  ));
            },
            child: ListTile(
              leading: ClipOval(
                child: CachedNetworkImage(
                    width: 50,
                    height: 50,
                    imageUrl: inboxModel.restaurantProfileImage.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                        ),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          placeholderImage,
                          fit: BoxFit.cover,
                        ))),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(inboxModel.restaurantName.toString())),
                  Text(DateFormat('MMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch(inboxModel.createdAt!.millisecondsSinceEpoch)),
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              subtitle: Text("Order Id : #".tr() + inboxModel.orderId.toString()),
            ),
          );
        },
        shrinkWrap: true,
        onEmpty: const Center(child: Text("No Conversion found")),
        // orderBy is compulsory to enable pagination
        query: FireStoreUtils.firestore.collection('chat_driver').where("customerId", isEqualTo: MyAppState.currentUser!.userID).orderBy('createdAt', descending: true),
        //Change types customerId
        viewType: ViewType.list,
        initialLoader: const CircularProgressIndicator(),
        // to fetch real-time data
        isLive: true,
      ),
    );
  }
}
