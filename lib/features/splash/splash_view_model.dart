import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';

class SplashViewModel {
  final Function(UserModel) setUser;

  SplashViewModel({
    this.setUser,
  });

  static SplashViewModel fromStore(Store<AppState> store) {
    return SplashViewModel(
      setUser: (user) {
        store.dispatch(SyncUserAction(user));
      },
    );
  }
}
