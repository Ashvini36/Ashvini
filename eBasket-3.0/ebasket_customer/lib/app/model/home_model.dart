class HomeModel {
  List<OfferItem>? dailyOfferItem;


  HomeModel({this.dailyOfferItem});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['offer_item'] != null) {
      dailyOfferItem = <OfferItem>[];
      json['offer_item'].forEach((v) {
        dailyOfferItem!.add(OfferItem.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyOfferItem != null) {
      data['offer_item'] = dailyOfferItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferItem {
  String? id;
  String? name;
  String? weight;
  String? price;
  String? disPrice;
  String? image;

  OfferItem({this.id, this.name, this.weight, this.price, this.disPrice, this.image});

  OfferItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    price = json['price'];
    disPrice = json['disPrice'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['weight'] = weight;
    data['price'] = price;
    data['disPrice'] = disPrice;
    data['image'] = image;
    return data;
  }
}




