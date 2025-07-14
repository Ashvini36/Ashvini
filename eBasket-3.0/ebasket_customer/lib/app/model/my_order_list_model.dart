class MyOrderListModel {
  List<OrderList>? orderList;

  MyOrderListModel({this.orderList});

  MyOrderListModel.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderList>[];
      json['order_list'].forEach((v) {
        orderList!.add(OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderList != null) {
      data['order_list'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderList {
  String? id;
  String? orderId;
  String? address;
  String? quantity;
  String? status;
  String? date;
  String? price;
  String? image;

  OrderList({this.id, this.orderId, this.address, this.quantity, this.status, this.date, this.price,this.image});

  OrderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    address = json['address'];
    quantity = json['quantity'];
    status = json['status'];
    date = json['date'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['address'] = address;
    data['quantity'] = quantity;
    data['status'] = status;
    data['date'] = date;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}
