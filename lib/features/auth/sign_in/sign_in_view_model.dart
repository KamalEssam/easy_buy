
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';

class SignInViewModel {
  final ActionReport getLoginReport;
  final Function(String email, String password) login;
  final UserModel user;

  SignInViewModel({this.login, this.getLoginReport, this.user});

  static SignInViewModel fromStore(Store<AppState> store) {
    return SignInViewModel(
        login: (email, password) => store.dispatch(
              LoginAction(email: email, password: password),
            ),
        getLoginReport: store.state.authState.status["LoginAction"],
        user: store.state.authState.user);
  }
}
