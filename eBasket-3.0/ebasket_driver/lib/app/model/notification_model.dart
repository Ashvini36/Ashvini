class NotificationModel {
  List<NotificationData>? notification;

  NotificationModel({this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification = <NotificationData>[];
      json['notification'].forEach((v) {
        notification!.add(NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notification != null) {
      data['notification'] = notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  String? title;
  String? description;
  String? type;
  String? dateTime;

  NotificationData({this.id, this.title, this.description, this.type, this.dateTime});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['dateTime'] = dateTime;
    return data;
  }
}
