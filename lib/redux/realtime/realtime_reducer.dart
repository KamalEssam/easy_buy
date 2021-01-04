import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:redux/redux.dart';
import 'realtime_actions.dart';
import 'realtime_state.dart';

final realtimeReducer = combineReducers<RealtimeState>([
  TypedReducer<RealtimeState, RealtimeStatusAction>(_syncRealtimeState),
  TypedReducer<RealtimeState, SyncCategoriesAction>(_syncCategories),
  TypedReducer<RealtimeState, SyncCategoryAction>(_syncCategory),
  TypedReducer<RealtimeState, SyncDeleteCategoryAction>(_syncDeletecategories),
  TypedReducer<RealtimeState, SyncOrdersAction>(_syncOrders),
  TypedReducer<RealtimeState, SyncOrderAction>(_syncOrder),
]);

RealtimeState _syncRealtimeState(
    RealtimeState state, RealtimeStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

RealtimeState _syncCategory(
    RealtimeState state, SyncCategoryAction action) {
  state.categories.update(
    action.category.catId.toString(),
        (v) => v,
    ifAbsent: () => action.category,
  );

  return state.copyWith(categories: state.categories);
}

RealtimeState _syncOrder(
    RealtimeState state, SyncOrderAction action) {
  state.orders.update(
    action.order.orderId.toString(),
        (v) =>  action.order,
    ifAbsent: () => action.order,
  );

  return state.copyWith(orders: state.orders);
}

RealtimeState _syncOrders(
    RealtimeState state, SyncOrdersAction action) {
  for (Order item in action.orders) {
    state.orders.update(
      item.orderId.toString(),
          (v) =>  item,
      ifAbsent: () => item,
    );
  }


  return state.copyWith(orders: state.orders);
}

RealtimeState _syncDeletecategories(
    RealtimeState state, SyncDeleteCategoryAction action) {
  return state.copyWith(categories:  state.categories..remove(action.id));
}

RealtimeState _syncCategories(
    RealtimeState state, SyncCategoriesAction action) {
  for (CategoryModel item in action.categories) {
    state.categories.update(
      item.catId.toString(),
          (v) => item,
      ifAbsent: () => item,
    );
  }
  return state.copyWith(categories: state.categories);
}

