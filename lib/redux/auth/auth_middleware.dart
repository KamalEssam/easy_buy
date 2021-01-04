import 'package:easy_buy/data/remote/auth_repository.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';

import '../action_report.dart';
import 'auth_actions.dart';

List<Middleware<AppState>> createAuthMiddleware([
  AuthRepository _repository = const AuthRepository(),
]) {
  final login = _login(_repository);
  final signup = _signup(_repository);
  final editProfile = _editProfile(_repository);

  return [
    TypedMiddleware<AppState, LoginAction>(login),
    TypedMiddleware<AppState, SignUpAction>(signup),
    TypedMiddleware<AppState, EditProfileAction>(editProfile),
  ];
}

Middleware<AppState> _login(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.login(action.email, action.password).then((user) {
      if(!FirebaseAuth.instance.currentUser.emailVerified){
        store.state.authState.user=user;
        next(SyncUserAction(user));
        completed(next, action);
      }
      else
        catchError(next, action, "email not verified");
    }).catchError((error) {
        print(error);
        catchError(next, action, error);
    });
  };
}

Middleware<AppState> _signup(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.signup(action.email, action.password,action.user)
        .then((user) {
      store.state.authState.user=user;
      next(SyncUserAction(user));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
      print(error);});
  };
}

Middleware<AppState> _editProfile(AuthRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updateUser(action.user,action.img)
        .then((user) {
      store.state.authState.user=user;
      next(SyncUserAction(user));
      completed(next, action);
    }).catchError((error) {
      print(error);});
  };
}


void catchError(NextDispatcher next, action, error) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: error.toString())));
}

void completed(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void running(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(AuthStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
