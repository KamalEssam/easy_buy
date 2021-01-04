import 'package:redux/redux.dart';
import 'auth_actions.dart';
import 'auth_state.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, AuthStatusAction>(_syncAuthState),
  TypedReducer<AuthState, SyncUserAction>(_syncUser),
]);

AuthState _syncAuthState(AuthState state, AuthStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

AuthState _syncUser(AuthState state, SyncUserAction action) {
  return state.copyWith(user: action.user);
}

