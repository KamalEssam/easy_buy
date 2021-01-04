import 'package:flutter/cupertino.dart';

import 'category_model.dart';

class Product {
  String productId;
  String name;
  int quantity;
  int orderQuantity;
  String photo;
  num price;
  num rate;
  String categoryId;
  String subCategoryId;
  List <String> sizes;
  List <Color> colors;

  Product({
    this.name,
    this.photo="https://firebasestorage.googleapis.com/v0/b/easybuy-e7517.appspot.com/o/package.png?alt=media&token=c8677400-8bbf-4d51-b604-17d8cc7d37ab",
    this.price,
    this.categoryId,
    this.subCategoryId,
    this.quantity,
    this.productId,
    this.orderQuantity,
  });

  Product.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
    price = json['price'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    rate = json['rating'] ?? 0;
    quantity = json['quantity'] ?? 1;
    orderQuantity = json['orderQuantity'] ?? 1;
  }

  Map<String, dynamic> toJson() => {
      "productId": productId,
      'quantity': quantity,
      'name': name,
      'photo': photo,
      'price': price,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'colors': colors,
      'sizes': sizes,
      'orderQuantity':orderQuantity
    };
}