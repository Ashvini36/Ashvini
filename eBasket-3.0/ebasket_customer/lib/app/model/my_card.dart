class CardData {
  String? id;
  String? cardHolderName;
  String? cardNumber;
  String? cvvCode;
  String? expiryDate;
  String? userId;

  CardData({this.id, this.cardHolderName, this.cardNumber, this.cvvCode, this.expiryDate,this.userId});

  CardData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardHolderName = json['cardHolderName'];
    cardNumber = json['cardNumber'];
    cvvCode = json['cvvCode'];
    expiryDate = json['expiryDate'];
    userId = json["user_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cardHolderName'] = cardHolderName;
    data['cardNumber'] = cardNumber;
    data['cvvCode'] = cvvCode;
    data['expiryDate'] = expiryDate;
    data['user_id'] = userId;
    return data;
  }
}
