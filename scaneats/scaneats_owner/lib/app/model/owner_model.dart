class OwnerModel {
  String? password;
  String? email;
  String? name;

  OwnerModel({this.password, this.email,this.name});

  OwnerModel.fromJson(Map<String, dynamic> json) {

    email = json['email'];
    password = json['password'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    return data;
  }
}
