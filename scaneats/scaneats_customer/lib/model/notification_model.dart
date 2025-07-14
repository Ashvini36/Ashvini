class NotificationModel {
  String? serverKey;

  NotificationModel({this.serverKey});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    serverKey = json['serverKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serverKey'] = serverKey;
    return data;
  }
}
