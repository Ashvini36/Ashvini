class ItemCategoryModel {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  String? image;
  ItemCategoryModel({this.id, this.name, this.description, this.image, this.isActive});

  ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isActive'] = isActive;
    data['image'] = image;
    return data;
  }
}
