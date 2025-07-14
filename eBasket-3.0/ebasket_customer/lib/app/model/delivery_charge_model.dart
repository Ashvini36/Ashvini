import 'dart:core';

class DeliveryChargeModel {
  num? amount;
  num? deliveryChargesPerKm;
  num? minimumDeliveryCharges;
  num? minimumDeliveryChargesWithinKm;

  DeliveryChargeModel({this.amount, this.deliveryChargesPerKm, this.minimumDeliveryCharges, this.minimumDeliveryChargesWithinKm});

  DeliveryChargeModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    deliveryChargesPerKm = json['delivery_charges_per_km'];
    minimumDeliveryCharges = json['minimum_delivery_charges'];
    minimumDeliveryChargesWithinKm = json['minimum_delivery_charges_within_km'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['delivery_charges_per_km'] = deliveryChargesPerKm;
    data['minimum_delivery_charges'] = minimumDeliveryCharges;
    data['minimum_delivery_charges_within_km'] = minimumDeliveryChargesWithinKm;
    return data;
  }
}
