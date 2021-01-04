
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';

class SignUpViewModel {
  final Function( String, String,UserModel) signUp;
  final ActionReport signupReport;
  final UserModel user;

  SignUpViewModel({
    this.signUp,
    this.signupReport,
    this.user
  });

  static SignUpViewModel fromStore(Store<AppState> store) {
    return SignUpViewModel(
      signupReport: store.state.authState.status["SignUpAction"],
      signUp: (email, password,user) {
        store.dispatch(SignUpAction(
          email: email,
          password: password,
            user:user
        ));
      },
      user: store.state.authState.user
    );
  }
}
