import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPayload {
  String? id;
  String? userId;
  String? role;
  String? body;
  String? title;
  String? notificationType;
  Timestamp? createdAt;
  String? orderId;
  NotificationPayload({
    this.body,
    this.id,
    this.userId,
    this.role,
    this.title,
    this.createdAt,
    this.notificationType,
    this.orderId,
  });
  NotificationPayload.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    id = json['id'];
    userId = json['userId'];
    role = json['role'];
    title = json['title'];
    createdAt = json['createdAt'];
    notificationType = json['notificationType'];
    orderId = json['orderId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['body'] = body;
    data['id'] = id;
    data['userId'] = userId;
    data['role'] = role;
    data['title'] = title;
    data['orderId'] = orderId;
    if (createdAt != null) {
      data['createdAt'] = createdAt;
    }
    data['notificationType'] = notificationType;
    return data;
  }
}
