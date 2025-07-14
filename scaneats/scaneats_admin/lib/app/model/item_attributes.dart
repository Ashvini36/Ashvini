class ItemAttributes {
  List<Attributes>? attributes;
  List<Variants>? variants;

  ItemAttributes({this.attributes, this.variants});

  ItemAttributes.fromJson(Map<String, dynamic> json) {
    List<Attributes> attribute = json.containsKey('attributes') ? List<Attributes>.from((json['attributes'] as List<dynamic>).map((e) => Attributes.fromJson(e))).toList() : [];

    List<Variants> variant = json.containsKey('variants') ? List<Variants>.from((json['variants'] as List<dynamic>).map((e) => Variants.fromJson(e))).toList() : [];
    if (json['attributes'] != null) attributes = attribute;
    variants = variant;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (attributes != null) data['attributes'] = attributes!.map((e) => e.toJson()).toList();
    data['variants'] = variants!.map((e) => e.toJson()).toList();
    return data;
  }
}

class Attributes {
  String? attributesId;
  List<dynamic>? attributeOptions;

  Attributes({this.attributesId, this.attributeOptions});

  Attributes.fromJson(Map<String, dynamic> json) {
    attributesId = json['attribute_id'];
    attributeOptions = json['attribute_options'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributesId;
    data['attribute_options'] = attributeOptions;
    return data;
  }
}

class Variants {
  String? variantId;
  String? variantImage;
  String? variantPrice;
  String? variantQuantity;
  String? variantSku;
  int? qty;

  Variants({this.variantId, this.variantImage, this.variantPrice, this.variantQuantity, this.variantSku, this.qty});

  Variants.fromJson(Map<String, dynamic> json) {
    if (json['qty'] != null) qty = json['qty'] ?? 0;
    variantId = json['variant_id'];
    variantImage = json['variant_image'];
    variantPrice = json['variant_price'] ?? '0';
    variantQuantity = json['variant_quantity'];
    variantSku = json['variant_sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (qty != null) data['qty'] = qty ?? 0;
    data['variant_id'] = variantId;
    data['variant_image'] = variantImage;
    data['variant_price'] = variantPrice ?? '0';
    data['variant_quantity'] = variantQuantity;
    data['variant_sku'] = variantSku;
    return data;
  }
}

class AttributesModel {
  String? id;
  String? title;

  AttributesModel({this.id, this.title});

  AttributesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
