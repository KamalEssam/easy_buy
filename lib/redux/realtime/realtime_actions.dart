import 'dart:io';

import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:easy_buy/data/model/product_model.dart';

import '../action_report.dart';
import 'package:meta/meta.dart';

class RealtimeStatusAction {
  final String actionName = "RealtimeStatusAction";
  final ActionReport report;

  RealtimeStatusAction({@required this.report});
}

class DeleteAction {
  final String actionName = "DeleteAction";
  final String path;
  final String id;

  DeleteAction({@required this.id, @required this.path});
}


class SyncDeleteCategoryAction {
  final String actionName = "SyncDeleteCategoryAction";
  final String id;

  SyncDeleteCategoryAction({@required this.id});
}

class SyncOrdersAction {
  final String actionName = "SyncOrdersAction";
  final List<Order> orders;

  SyncOrdersAction({@required this.orders});
}
class SyncOrderAction {
  final String actionName = "SyncOrderAction";
  final Order order;

  SyncOrderAction({@required this.order});
}

class AddOrderAction {
  final String actionName = "AddOrderAction";
  final Order order;

  AddOrderAction({@required this.order});
}

class GetOrdersAction {
  final String actionName = "GetOrdersAction";
  String id;
  GetOrdersAction({@required this.id});
}

class DeleteCategoryAction {
  final String actionName = "DeleteCategoryAction";
  final String path;
  final String id;

  DeleteCategoryAction({@required this.id, @required this.path});
}

class DeleteProductAction {
  final String actionName = "DeleteProductAction";
  final String path;
  final String id;
  final Product product;
  final CategoryModel categoryModel;

  DeleteProductAction({@required this.id, @required this.path, @required this.product, @required this.categoryModel});
}

class AddCategoryAction{
  final String actionName = "AddCategoryAction";
  final CategoryModel categoryModel;
  final File img;

  AddCategoryAction({@required this.categoryModel,@required this.img});
}

class SyncCategoryAction{
  final String actionName = "SyncCategoryAction";
  final CategoryModel category;

  SyncCategoryAction({@required this.category});
}

class GetSubCategoryAction{
  final String actionName = "GetSubCategoryAction";
  final CategoryModel category;

  GetSubCategoryAction({@required this.category});
}

class AddSubCategoryAction{
  final String actionName = "AddSubCategoryAction";
  final CategoryModel category;
  final CategoryModel subCat;
  final File file;

  AddSubCategoryAction({@required this.category,@required this.file,this.subCat});
}

class AddProductAction{
  final String actionName = "AddProductAction";
  final CategoryModel category;
  final File file;
  final Product product;

  AddProductAction({@required this.category,@required this.file,this.product});
}

class GetCategoriesAction {
  final String actionName = "GetCategoriesAction";
  GetCategoriesAction();
}

class GetProductsAction {
  final String actionName = "GetProductsAction";
  final CategoryModel category;
  GetProductsAction({@required this.category});
}

class SyncCategoriesAction{
  final String actionName = "SyncCategoriesAction";
  final List<CategoryModel> categories;

  SyncCategoriesAction({@required this.categories});
}