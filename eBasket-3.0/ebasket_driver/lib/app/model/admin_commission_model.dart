class AdminCommission {
  String? amount;
  bool? enable;
  String? type;

  AdminCommission({this.amount, this.enable, this.type});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    amount = json['fix_commission'].toString();
    enable = json['isEnabled'];
    type = json['commissionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fix_commission'] = amount;
    data['isEnabled'] = enable;
    data['commissionType'] = type;
    return data;
  }
}
