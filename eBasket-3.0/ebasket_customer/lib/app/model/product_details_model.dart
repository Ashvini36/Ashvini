class ProductDetailsModel {
  String? id;
  String? name;
  String? description;
  String? weight;
  String? price;
  String? disPrice;
  String? image;
  String? quantity;
  List<VariantItem>? variantItem;
  String? disclaimer_desc;

  ProductDetailsModel({this.id, this.name, this.description, this.weight, this.price, this.disPrice, this.image, this.quantity,this.variantItem,this.disclaimer_desc});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    weight = json['weight'];
    price = json['price'];
    disPrice = json['disPrice'];
    image = json['image'];
    quantity = json['quantity'];
    if (json['variant'] != null) {
      variantItem = <VariantItem>[];
      json['variant'].forEach((v) {
        variantItem!.add(VariantItem.fromJson(v));
      });
    }
    disclaimer_desc = json['disclaimer_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['weight'] = weight;
    data['price'] = price;
    data['disPrice'] = disPrice;
    data['image'] = image;
    data['quantity'] = quantity;
    if (variantItem != null) {
      data['variant'] = variantItem!.map((v) => v.toJson()).toList();
    }
    data['disclaimer_desc'] = disclaimer_desc;
    return data;
  }
}

class VariantItem {
  String? id;
  String? weight;
  String? price;

  VariantItem({this.id, this.weight, this.price});

  VariantItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weight'] = weight;
    data['price'] = price;
    return data;
  }
}
