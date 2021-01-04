import 'dart:convert';

import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/data/remote/realtime_repository.dart';
import 'package:easy_buy/features/category/add_subcategory_view.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../action_report.dart';
import 'realtime_actions.dart';

List<Middleware<AppState>> createRealtimeMiddleware([
  RealtimeRepository _repository = const RealtimeRepository(),

]) {
  final deleteCategory = _deleteCategory(_repository);
  final getCategory = _getCategory(_repository);
  final getSubCategories= _getSubCategories(_repository);
  final addSubCategory= _addSubCategory(_repository);
  final getProducts = _getProducts(_repository);
  final addCategory = _addCategory(_repository);
  final addProduct = _addProduct(_repository);
  final deleteProduct = _deleteProduct(_repository);
  final getOrders = _getOrders(_repository);
  final addOrder = _addOrder(_repository);
  return [
    TypedMiddleware<AppState, DeleteCategoryAction>(deleteCategory),
    TypedMiddleware<AppState, GetCategoriesAction>(getCategory),
    TypedMiddleware<AppState, AddCategoryAction>(addCategory),
    TypedMiddleware<AppState, GetSubCategoryAction>(getSubCategories),
    TypedMiddleware<AppState, GetProductsAction>(getProducts),
    TypedMiddleware<AppState, AddSubCategoryAction>(addSubCategory),
    TypedMiddleware<AppState, AddProductAction>(addProduct),
    TypedMiddleware<AppState, DeleteProductAction>(deleteProduct),
    TypedMiddleware<AppState, GetOrdersAction>(getOrders),
    TypedMiddleware<AppState, AddOrderAction>(addOrder),
  ];
}

Middleware<AppState> _getCategory(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    store.state.realtimeState.categories.clear();
    repository.getCategories().then((data) {
      next(SyncCategoriesAction(categories: data));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _getSubCategories(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.getSubCategories(action.category.catId).then((data) {
      (action as GetSubCategoryAction).category.subCategories=data;
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _getProducts(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.getProducts(action.category.catId).then((data) {
      (action as GetProductsAction).category.products=data;
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _addCategory(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.addCategory(action.categoryModel, action.img).then((data) {
      next(SyncCategoryAction(category: data));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _addSubCategory(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.addSubCategory(action.subCat, action.file).then((data) {
      (action as AddSubCategoryAction).category.subCategories.add(data);
      completed(next, action);
      next(SyncCategoryAction(category: (action as AddSubCategoryAction).category));
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _addProduct(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.addProduct(action.product, action.file).then((data) {
      print(jsonEncode(data));
      (action as AddProductAction).category.products.add(data);
      next(SyncCategoryAction(category: (action as AddProductAction).category));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _getOrders(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    store.state.realtimeState.orders.clear();
    repository.getOrders(action.id).then((data) {
      next(SyncOrdersAction(orders: data));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _addOrder(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.addOrder(action.order).then((data) {
      next(SyncOrderAction(order: data));
      Product p=data.product;
      p.quantity-=p.orderQuantity;
      p.orderQuantity=null;
      p.productId=action.order.pId;
      print(jsonEncode(p));
      repository.updateProduct(p);
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _deleteCategory(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.delete(action.path).then((data) {
      next(SyncDeleteCategoryAction(id: action.id));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _deleteProduct(RealtimeRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.delete(action.path).then((data) {
      (action as DeleteProductAction).categoryModel.products.remove(action.product);
      next(SyncCategoryAction(category: (action as DeleteProductAction).categoryModel));
      completed(next, action);
    }).catchError((error) {
      print(error);
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(RealtimeStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: error.toString())));
}

void completed(NextDispatcher next, action) {
  next(RealtimeStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void running(NextDispatcher next, action) {
  next(RealtimeStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(RealtimeStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
