class BrandsModel {
  String? id;
  String? title;
  String? photo;
  bool? isPublish;
  bool? checked;

  BrandsModel({ this.id, this.title,this.photo, this.isPublish,this.checked});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    photo = json['photo'];
    isPublish = json['is_publish'];
    checked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['photo'] = photo;
    data['is_publish'] = isPublish;
    return data;
  }
}
