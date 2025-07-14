class FavouriteItemModel {
  String? id;
  String? userId;
  String? productId;

  FavouriteItemModel({this.id,this.userId, this.productId});

  factory FavouriteItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return FavouriteItemModel(id: parsedJson["id"] ?? "",userId: parsedJson["user_id"] ?? "", productId: parsedJson["product_id"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id, "user_id": userId, "product_id": productId};
  }
}
