class LatLngModel {
  String? latitude;
  String? longLatitude;

  LatLngModel({this.latitude, this.longLatitude});

  LatLngModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longLatitude = json['longLatitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longLatitude'] = longLatitude;
    return data;
  }
}
