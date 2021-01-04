import 'dart:io';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel {
  final UserModel user;
  Function() signOut;

  HomeViewModel({this.user, this.signOut});

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      user: store.state.authState.user,
      signOut: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove('isLogined');
        preferences.remove('user');
        preferences.clear();
        store.state.authState.user=null;
        FirebaseAuth.instance.signOut();
      },
    );
  }
}
