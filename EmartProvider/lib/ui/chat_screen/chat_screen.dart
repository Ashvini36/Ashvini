import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emartprovider/constant/constants.dart';
import 'package:emartprovider/constant/show_toast_dialog.dart';
import 'package:emartprovider/main.dart';
import 'package:emartprovider/model/chat_video_container.dart';
import 'package:emartprovider/model/conversation_model.dart';
import 'package:emartprovider/model/inbox_model.dart';
import 'package:emartprovider/model/worker_model.dart';
import 'package:emartprovider/services/firebase_helper.dart';
import 'package:emartprovider/services/send_notification.dart';
import 'package:emartprovider/themes/app_colors.dart';
import 'package:emartprovider/ui/chat_screen/full_screen_image_viewer.dart';
import 'package:emartprovider/ui/chat_screen/full_screen_video_viewer.dart';
import 'package:emartprovider/utils/dark_theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../model/user.dart';

class ChatScreens extends StatefulWidget {
  final String? orderId;
  final String? customerId;
  final String? customerName;
  final String? customerProfileImage;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantProfileImage;
  final String? token;
  final String? chatType;
  final String? type;

  const ChatScreens(
      {Key? key,
      this.orderId,
      this.customerId,
      this.customerName,
      this.customerProfileImage,
      this.token,
      this.chatType,
      this.restaurantId,
      this.restaurantName,
      this.restaurantProfileImage,
      this.type})
      : super(key: key);

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    if (_controller.hasClients) {
      Timer(const Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("${widget.customerName.toString()}\n#${widget.orderId.toString()}",
            maxLines: 2, style: TextStyle(color: themeChange.getTheme() ? Colors.white : Colors.black, fontSize: 14)),
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    // currentRecordingState = RecordingState.HIDDEN;
                  });
                },
                child: PaginateFirestore(
                  scrollController: _controller,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, documentSnapshots, index) {
                    ConversationModel inboxModel = ConversationModel.fromJson(documentSnapshots[index].data() as Map<String, dynamic>);
                    return chatItemView(inboxModel.senderId == FireStoreUtils.getCurrentUid(), inboxModel);
                  },
                  onEmpty: Center(child: Text("No Conversion found".tr)),
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance
                      .collection(widget.chatType == "Driver"
                          ? 'chat_driver'
                          : widget.chatType == "Provider"
                              ? 'chat_provider'
                              : widget.chatType == "Worker"
                                  ? 'chat_worker'
                                  : 'chat_store')
                      .doc(widget.orderId)
                      .collection("thread")
                      .orderBy('createdAt', descending: false),
                  //Change types customerId
                  itemBuilderType: PaginateBuilderType.listView,
                  // to fetch real-time data
                  isLive: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: themeChange.getTheme() ? Colors.grey.shade900 : AppColors.colorPrimary, width: 2.0)),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeChange.getTheme() ? Colors.grey.shade900 : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          if (_messageController.text.isNotEmpty) {
                            _sendMessage(_messageController.text, null, '', 'text');
                            _messageController.clear();
                            setState(() {});
                          } else {
                            ShowToastDialog.showToast("Please enter text".tr);
                          }
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () async {
                          _onCameraClick();
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                      hintText: 'Start typing ...'.tr,
                    ),
                    onSubmitted: (value) async {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(_messageController.text, null, '', 'text');
                        Timer(const Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
                        _messageController.clear();
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatItemView(bool isMe, ConversationModel data) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  data.messageType == "text"
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorPrimary,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            data.message.toString(),
                            style: TextStyle(
                                color: data.senderId == FireStoreUtils.getCurrentUid()
                                    ? themeChange.getTheme()
                                        ? Colors.black
                                        : Colors.white
                                    : Colors.black),
                          ),
                        )
                      : data.messageType == "image"
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 50,
                                maxWidth: 200,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                child: Stack(alignment: Alignment.center, children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(FullScreenImageViewer(
                                        imageUrl: data.url!.url,
                                      ));
                                    },
                                    child: Hero(
                                      tag: data.url!.url,
                                      child: CachedNetworkImage(
                                        imageUrl: data.url!.url,
                                        placeholder: (context, url) => loader(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ]),
                              ))
                          : FloatingActionButton(
                              mini: true,
                              heroTag: data.id,
                              onPressed: () {
                                Get.to(FullScreenVideoViewer(
                                  heroTag: data.id.toString(),
                                  videoUrl: data.url!.url,
                                ));
                              },
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                  const SizedBox(
                    height: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Me".tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                      Text(DateFormat('MMM d, yyyy hh:mm aa').format(DateTime.fromMillisecondsSinceEpoch(data.createdAt!.millisecondsSinceEpoch)),
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    data.messageType == "text"
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                              color: Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              data.message.toString(),
                              style: TextStyle(color: data.senderId == FireStoreUtils.getCurrentUid() ? Colors.white : Colors.black),
                            ),
                          )
                        : data.messageType == "image"
                            ? ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 200,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  child: Stack(alignment: Alignment.center, children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(FullScreenImageViewer(
                                          imageUrl: data.url!.url,
                                        ));
                                      },
                                      child: Hero(
                                        tag: data.url!.url,
                                        child: CachedNetworkImage(
                                          imageUrl: data.url!.url,
                                          placeholder: (context, url) => loader(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ))
                            : FloatingActionButton(
                                mini: true,
                                heroTag: data.id,
                                onPressed: () {
                                  Get.to(FullScreenVideoViewer(
                                    heroTag: data.id.toString(),
                                    videoUrl: data.url!.url,
                                  ));
                                },
                                child: const Icon(
                                  Icons.play_arrow,
                                ),
                              ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.customerName.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                    Text(DateFormat('MMM d, yyyy hh:mm aa').format(DateTime.fromMillisecondsSinceEpoch(data.createdAt!.millisecondsSinceEpoch)),
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
    );
  }

  String? token;

  _sendMessage(String message, Url? url, String videoThumbnail, String messageType) async {
    InboxModel inboxModel = InboxModel(
        customerId: widget.customerId,
        customerName: widget.customerName,
        restaurantId: widget.restaurantId,
        restaurantName: widget.restaurantName,
        createdAt: Timestamp.now(),
        orderId: widget.orderId,
        customerProfileImage: widget.customerProfileImage,
        restaurantProfileImage: widget.restaurantProfileImage,
        lastMessage: _messageController.text,
        chatType: widget.chatType);

    if (widget.chatType == "Provider") {
      await FireStoreUtils.addProviderInbox(inboxModel);
    } else if (widget.chatType == "Worker") {
      await FireStoreUtils.addWorkerInbox(inboxModel);
    }
    ConversationModel conversationModel = ConversationModel(
        id: const Uuid().v4(),
        message: message,
        senderId: widget.restaurantId,
        receiverId: widget.customerId,
        createdAt: Timestamp.now(),
        url: url,
        orderId: widget.orderId,
        messageType: messageType,
        videoThumbnail: videoThumbnail);

    if (url != null && url.mime.toString().isNotEmpty) {
      if (url.mime.contains('image')) {
        conversationModel.message = "sent an image";
      } else if (url.mime.contains('video')) {
        conversationModel.message = "sent an Video";
      } else if (url.mime.contains('audio')) {
        conversationModel.message = "Sent a voice message";
      }
    } else if (messageType.toString() != "text") {
      conversationModel.message = messageType.toString() == "image"
          ? "sent An Image"
          : messageType.toString() == "video"
              ? "sent A Video"
              : "sent A VoiceMessage";
    }
    if (widget.chatType == "Driver") {
      await FireStoreUtils.addDriverChat(conversationModel);
    } else if (widget.chatType == "Provider") {
      await FireStoreUtils.addProviderChat(conversationModel);
    } else if (widget.chatType == "Worker") {
      await FireStoreUtils.addWorkerChat(conversationModel);
    } else {
      await FireStoreUtils.addRestaurantChat(conversationModel);
    }
    Map<String, dynamic> payLoad = <String, dynamic>{};
    if (widget.type == "provider_chat") {
      if (widget.chatType == 'Worker') {
        WorkerModel? worker = await FireStoreUtils.getWorker(widget.restaurantId.toString());
        token = worker!.fcmToken;
      } else {
        User? provider = await FireStoreUtils.getCurrentUser(widget.restaurantId.toString());
        token = provider!.fcmToken;
      }

      payLoad = {
        "type": "provider_chat",
        "customerName": widget.customerName.toString(),
        "restaurantName": widget.restaurantName.toString(),
        "orderId": widget.orderId,
        "restaurantId": widget.restaurantId,
        "customerId": widget.customerId,
        "customerProfileImage": widget.customerProfileImage,
        "restaurantProfileImage": widget.restaurantProfileImage,
        "token": token,
        "chatType": widget.chatType,
      };
    } else {
      // Inbox screen
      User? restaurantUser = await FireStoreUtils.getCurrentUser(widget.restaurantId.toString());
      token = restaurantUser!.fcmToken;
      payLoad = {
        "customerName": widget.customerName.toString(),
        "restaurantName": widget.restaurantName.toString(),
        "orderId": widget.orderId,
        "restaurantId": widget.restaurantId,
        "customerId": widget.customerId,
        "customerProfileImage": widget.customerProfileImage,
        "restaurantProfileImage": widget.restaurantProfileImage,
        "token": token,
        "chatType": widget.chatType,
      };
    }

    SendNotification.sendChatFcmMessage(
        "${MyAppState.currentUser!.fullName()} ${messageType == "image" ? "sent image to you" : messageType == "video" ? "sent video to you" : "sent message to you"}",
        conversationModel.message.toString(),
        widget.token.toString(),
        payLoad);
  }

  final ImagePicker _imagePicker = ImagePicker();

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Send Media'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url url = await FireStoreUtils().uploadChatImageToFireStorage(File(image.path));
              _sendMessage('', url, '', 'image');
            }
          },
          child: Text("Choose image from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? galleryVideo = await _imagePicker.pickVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer videoContainer = await FireStoreUtils().uploadChatVideoToFireStorage(File(galleryVideo.path));
              _sendMessage('', videoContainer.videoUrl, videoContainer.thumbnailUrl, 'video');
            }
          },
          child: Text("Choose video from gallery".tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
            if (image != null) {
              Url url = await FireStoreUtils().uploadChatImageToFireStorage(File(image.path));
              _sendMessage('', url, '', 'image');
            }
          },
          child: Text("Take a Photo".tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            XFile? recordedVideo = await _imagePicker.pickVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer videoContainer = await FireStoreUtils().uploadChatVideoToFireStorage(File(recordedVideo.path));
              _sendMessage('', videoContainer.videoUrl, videoContainer.thumbnailUrl, 'video');
            }
          },
          child: Text("Record video".tr),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
