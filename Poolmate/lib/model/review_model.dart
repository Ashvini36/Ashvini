import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? comment;
  String? rating;
  String? id;
  String? userId;
  String? publisherUserId;
  Timestamp? date;

  ReviewModel({this.comment, this.rating, this.id, this.date, this.userId, this.publisherUserId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    rating = json['rating'];
    id = json['id'];
    date = json['date'];
    userId = json['userId'];
    publisherUserId = json['publisherUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['rating'] = rating;
    data['id'] = id;
    data['date'] = date;
    data['userId'] = userId;
    data['publisherUserId'] = publisherUserId;
    return data;
  }
}
