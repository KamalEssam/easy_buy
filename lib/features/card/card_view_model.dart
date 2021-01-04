import 'dart:io';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/realtime/realtime_actions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardViewModel {
  final UserModel user;
  Function(Order) order;
  ActionReport addOrderReport;

  CardViewModel({this.user,this.order,this.addOrderReport});

  static CardViewModel fromStore(Store<AppState> store) {
    return CardViewModel(
      user: store.state.authState.user,
      order: (order){
        store.dispatch(AddOrderAction(order: order));
      },
      addOrderReport: store.state.realtimeState.status["AddOrderAction"],
    );
  }
}
