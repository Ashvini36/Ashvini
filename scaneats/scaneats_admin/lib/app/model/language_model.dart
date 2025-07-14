class LanguageModel {
  String? id;
  String? name;
  String? code;
  String? image;
  bool? isActive;

  LanguageModel({this.id, this.name,this.image,this.code, this.isActive});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    image = json['image'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['image'] = image;
    data['code'] = code;
    return data;
  }
}
