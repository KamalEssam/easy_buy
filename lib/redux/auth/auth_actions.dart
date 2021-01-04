import 'dart:io';
import 'package:easy_buy/data/model/user_model.dart';

import '../action_report.dart';
import 'package:meta/meta.dart';

class AuthStatusAction {
  final String actionName = "AuthStatusAction";
  final ActionReport report;

  AuthStatusAction({@required this.report});
}

class LoginAction {
  final String actionName = "LoginAction";
  final String email;
  final String password;
  LoginAction({@required this.email, @required this.password});
}

class SyncUserAction {
  final String actionName = "SyncUserAction";
  final UserModel user;
  SyncUserAction(this.user);
}

class SignUpAction {
  final String actionName = "SignUpAction";
  final String email;
  final String password;
  final UserModel user;

  SignUpAction({
    @required this.email,
    @required this.password,
    @required this.user,
  });
}

class GetUserAction {
  final String actionName = "GetUserAction";
  final UserModel user;
  GetUserAction({
    @required this.user,
  });
}

class EditProfileAction {
  final String actionName = "EditProfileAction";
  final UserModel user;
  final File img;
  EditProfileAction({
    @required this.user,this.img,
  });
}