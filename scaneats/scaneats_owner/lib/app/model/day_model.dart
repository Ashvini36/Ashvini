class DayModel {
  String? name;
  String? planPrice;
  String? strikePrice;
  bool? enable;

  DayModel({this.enable, this.planPrice, this.strikePrice, this.name});

  DayModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    planPrice = json['planPrice'];
    strikePrice = json['strikePrice'];
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['planPrice'] = planPrice;
    data['strikePrice'] = strikePrice;
    data['enable'] = enable;
    return data;
  }
}
