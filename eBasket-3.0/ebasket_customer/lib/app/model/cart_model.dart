class CartModel {
  List<ProductList>? productList;

  CartModel({this.productList});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['product_list'] != null) {
      productList = <ProductList>[];
      json['product_list'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productList != null) {
      data['product_list'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String? id;
  String? name;
  String? weight;
  String? price;
  String? disPrice;
  String? twoKgPrice;
  String? fourKgPrice;
  String? image;
  String? quantity;

  ProductList({this.id, this.name, this.weight, this.price, this.disPrice, this.twoKgPrice, this.fourKgPrice, this.image, this.quantity});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    price = json['price'];
    disPrice = json['disPrice'];
    twoKgPrice = json['2kgPrice'];
    fourKgPrice = json['4kgPrice'];
    image = json['image'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['weight'] = weight;
    data['price'] = price;
    data['disPrice'] = disPrice;
    data['2kgPrice'] = twoKgPrice;
    data['4kgPrice'] = fourKgPrice;
    data['image'] = image;
    data['quantity'] = quantity;
    return data;
  }
}
