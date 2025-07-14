class CategoryModel {
  String? id;
  String? title;
  String? photo;
  String? description;
  List<dynamic>? reviewAttributes;
  bool? checked;

  CategoryModel({this.id, this.title, this.photo, this.description, this.reviewAttributes,this.checked});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    photo = json['photo'] ?? "";
    description = json['description'] ?? '';
    reviewAttributes = json['review_attributes'] ?? [];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['photo'] = photo;
    data['description'] = description;
    data['review_attributes'] = reviewAttributes;

    return data;
  }
}
