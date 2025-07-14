class ThemeModel {
  String? name;
  String? logo;
  String? favIcon;
  String? color;

  ThemeModel({this.logo,this.color,this.name,this.favIcon});

  ThemeModel.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    color = json['color'];
    name = json['name'];
    favIcon = json['favIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logo'] = logo;
    data['color'] = color;
    data['name'] = name;
    data['favIcon'] = favIcon;
    return data;
  }
}
