import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  String author;
  String authorName;

  String id;

  double latitude;

  double longitude;

  String location;
  GeoFireData geoFireData;
  String phonenumber;

  VendorModel({
    this.author = '',
    this.authorName = '',
    this.id = '',
    this.latitude = 0.1,
    this.longitude = 0.1,
    this.location = '',
    geoFireData,
    this.phonenumber = ''
  }) : geoFireData = geoFireData ??
            GeoFireData(
              geohash: "",
              geoPoint: const GeoPoint(0.0, 0.0),
            );

  factory VendorModel.fromJson(Map<String, dynamic> parsedJson) {
    return VendorModel(
      author: parsedJson['author'] ?? '',
      authorName: parsedJson['authorName'] ?? '',
      id: parsedJson['id'] ?? '',
      geoFireData: parsedJson.containsKey('g')
          ? GeoFireData.fromJson(parsedJson['g'])
          : GeoFireData(
              geohash: "",
              geoPoint: const GeoPoint(0.0, 0.0),
            ),
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      location: parsedJson['location'],
      phonenumber: parsedJson['phonenumber'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'author': author,
      'authorName': authorName,
      'id': id,
      "g": geoFireData.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'phonenumber': phonenumber,
    };

    return json;
  }
}

class GeoFireData {
  String? geohash;
  GeoPoint? geoPoint;

  GeoFireData({this.geohash, this.geoPoint});

  factory GeoFireData.fromJson(Map<dynamic, dynamic> parsedJson) {
    return GeoFireData(
      geohash: parsedJson['geohash'] ?? '',
      geoPoint: parsedJson['geopoint'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geohash': geohash,
      'geopoint': geoPoint,
    };
  }
}
