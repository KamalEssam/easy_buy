import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RealtimeRepository {
  const RealtimeRepository();

  Future delete(String path) async {
    await FirebaseDatabase.instance.reference().child(path).remove();
  }

  Future<List<CategoryModel>> getCategories() async {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child("categories");
    var categoriesSnapshot = await databaseReference.once();
    List<CategoryModel> categories = [];
    categoriesSnapshot.value.entries.forEach((e) {
      CategoryModel cat = CategoryModel.fromJson(e.value);
      cat.catId = e.key;
      categories.add(cat);
    });
    return categories;
  }

  Future<List<Product>> getProducts(String id) async {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child("products");
    var productsSnapshot = await databaseReference.orderByChild("categoryId").equalTo(id).once();
    List<Product> products = [];
    productsSnapshot.value.entries.forEach((e) {
      Product product = Product.fromJson(e.value);
      product.productId = e.key;
      print(jsonEncode(product));
      products.add(product);
    });
    return products;
  }

  Future<List<CategoryModel>> getSubCategories(String id) async {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child("subCategories");
    var productsSnapshot = await databaseReference.orderByChild("catId").equalTo(id).once();
    List<CategoryModel> subCategories = [];
    productsSnapshot.value.entries.forEach((e) {
      CategoryModel item = CategoryModel.fromJson(e.value);
      item.id = e.key;
      subCategories.add(item);
    });
    return subCategories;
  }

  Future<CategoryModel> addCategory(CategoryModel category, File img) async {
    if (img == null) {
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("categories").push();
      await databaseReference.set(category.toJson());
      var dataSnapshot = await databaseReference.once();
      category = CategoryModel.fromJson(dataSnapshot.value);
      category.catId = dataSnapshot.key;
      return category;
    } else {
      StorageReference storageReference =
      FirebaseStorage().ref().child(img.toString());
      StorageUploadTask uploadTask = storageReference.putFile(img);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      category.img = await storageSnapshot.ref.getDownloadURL();
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("categories").push();
      await databaseReference.set(category.toJson());
      var dataSnapshot = await databaseReference.once();
      category = CategoryModel.fromJson(dataSnapshot.value);
      category.catId = dataSnapshot.key;
      return category;
    }
  }

  Future<CategoryModel> addSubCategory(CategoryModel category, File img) async {
    if (img == null) {
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("subCategories").push();
      await databaseReference.set(category.toJson());
      var dataSnapshot = await databaseReference.once();
      category = CategoryModel.fromJson(dataSnapshot.value);
      category.id = dataSnapshot.key;
      return category;
    } else {
      StorageReference storageReference =
      FirebaseStorage().ref().child(img.toString());
      StorageUploadTask uploadTask = storageReference.putFile(img);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      category.img = await storageSnapshot.ref.getDownloadURL();
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("subCategories").push();
      await databaseReference.set(category.toJson());
      var dataSnapshot = await databaseReference.once();
      category = CategoryModel.fromJson(dataSnapshot.value);
      category.id = dataSnapshot.key;
      return category;
    }
  }

  Future<Product> addProduct(Product product, File img) async {
    if (img == null) {
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("products").push();
      await databaseReference.set(product.toJson());
      var dataSnapshot = await databaseReference.once();
      product = Product.fromJson(dataSnapshot.value);
      product.productId = dataSnapshot.key;
      return product;
    } else {
      StorageReference storageReference =
      FirebaseStorage().ref().child(img.toString());
      StorageUploadTask uploadTask = storageReference.putFile(img);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      product.photo = await storageSnapshot.ref.getDownloadURL();
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("products").push();
      await databaseReference.set(product.toJson());
      var dataSnapshot = await databaseReference.once();
      product = Product.fromJson(dataSnapshot.value);
      product.productId = dataSnapshot.key;
      return product;
    }
  }

  Future<Order> addOrder(Order order) async {
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("orders").push();
      await databaseReference.set(order.toJson());
      var dataSnapshot = await databaseReference.once();
      order = Order.fromJson(dataSnapshot.value);
      order.orderId = dataSnapshot.key;
      return order;
    }

  Future<Product> updateProduct(Product product) async {
   print(product.productId);
      DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("products").child(product.productId);
      await databaseReference.update(product.toJson());
      var dataSnapshot = await databaseReference.once();
      product = Product.fromJson(dataSnapshot.value);
      product.productId = dataSnapshot.key;
      return product;
  }

  Future<List<Order>> getOrders(String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("orders");
    DataSnapshot ordersSnapshot ;
    if(id==null)
     ordersSnapshot = await databaseReference.once();
    else
       ordersSnapshot = await databaseReference.orderByChild("orderBy").equalTo(id).once();
    List<Order> orders = [];
    ordersSnapshot.value.entries.forEach((e) {
      Order order = Order.fromJson(e.value);
      order.orderId = e.key;
      orders.add(order);
    });
    return orders;
  }

}
