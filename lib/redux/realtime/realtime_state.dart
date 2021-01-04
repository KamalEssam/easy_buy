
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:meta/meta.dart';
import '../action_report.dart';

class RealtimeState {
  final Map<String, ActionReport> status;
  final Map<String, CategoryModel> categories;
  final Map<String, Order> orders;
  RealtimeState({
    @required this.status,
    @required this.categories,
    @required this.orders,
  });

  factory RealtimeState.initial() {
    return RealtimeState(
      status: Map(),
      categories: Map(),
      orders: Map(),

    );
  }

  RealtimeState copyWith({
    Map<String, ActionReport> status,
    Map<String, CategoryModel> categories,
    Map<String, Order> orders
  }) {
    return RealtimeState(
      status: status ?? this.status ?? Map(),
      categories: categories ?? this.categories ?? Map(),
      orders: orders ?? this.orders ?? Map(),
    );
  }
}
