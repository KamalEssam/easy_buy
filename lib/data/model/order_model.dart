import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/data/model/user_model.dart';

class Order {
  String orderId;
  Product product;
  String orderBy;
  String pId;

  Order({
    this.orderId,
    this.product,
    this.orderBy,
    this.pId
  });

  Order.fromJson(Map<dynamic, dynamic> json)
    :orderId = json['orderId'],
    product =Product.fromJson( json['product']),
    orderBy = json['orderBy'];


  Map<String, dynamic> toJson() => {
    "orderBy": orderBy,
    "product": product.toJson(),
  };
}