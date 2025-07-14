class TaxModel {
  String? id;
  String? name;
  String? rate;
  bool? isActive;
  bool? isFix;
  TaxModel({this.id, this.name, this.rate, this.isActive,this.isFix});

  TaxModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rate = json['rate'];
    isActive = json['isActive'];
    isFix = json['isFix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rate'] = rate;
    data['isActive'] = isActive;
    data['isFix'] = isFix;
    return data;
  }
}
