class CurrenciesModel {
  String? id;
  String? name;
  String? symbol;
  bool? symbolAtRight;
  String? code;
  bool? isActive;
  String? decimalDigits;

  CurrenciesModel({this.id, this.name,this.symbol,this.code, this.isActive,this.symbolAtRight,this.decimalDigits});

  CurrenciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    symbol = json['symbol'];
    code = json['code'];
    symbolAtRight = json['symbolAtRight'];
    symbolAtRight = json['symbolAtRight'];
    decimalDigits = json['decimalDigits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['symbol'] = symbol;
    data['code'] = code;
    data['symbolAtRight'] = symbolAtRight;
    data['decimalDigits'] = decimalDigits;
    return data;
  }
}
