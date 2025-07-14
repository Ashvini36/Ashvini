class ItemAttributeModel {
  String? id;
  String? name;
  String? price;
  String? image;
  bool? isActive;
  ItemAttributeModel({this.id, this.name, this.isActive});

  ItemAttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    return data;
  }
}


