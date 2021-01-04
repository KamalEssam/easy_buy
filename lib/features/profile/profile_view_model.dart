import 'dart:io';
import 'package:easy_buy/data/model/order_model.dart';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/auth/auth_actions.dart';
import 'package:easy_buy/redux/realtime/realtime_actions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel {

  final UserModel user;
  final Function() signOut;
  final ActionReport editProfileReport;
  final Function(UserModel, File) editProfile;
  final Function(String) getOrders;
  final ActionReport getOrdersReport;
  final List<Order> orders;

  ProfileViewModel({
    this.user,
    this.signOut,
    this.editProfileReport,
    this.editProfile,
    this.getOrders,this.getOrdersReport,this.orders
  });

  static ProfileViewModel fromStore(Store<AppState> store) {
    return ProfileViewModel(
        user: store.state.authState.user,
      signOut: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('isLogined');
        preferences.remove('user');
        preferences.clear();
        store.state.authState.user=null;
        FirebaseAuth.instance.signOut();
      },
      editProfileReport: store.state.authState.status["EditProfileAction"],
      editProfile: (user,file){
          store.dispatch(EditProfileAction(user: user,img: file));
      },
      getOrders: (id){
          store.dispatch(GetOrdersAction(id: id));
      },
      getOrdersReport: store.state.realtimeState.status["GetOrdersAction"],
      orders: store.state.realtimeState.orders.values.toList(),
    );
  }
}
