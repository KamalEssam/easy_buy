import 'package:easy_buy/data/model/user_model.dart';
import 'package:meta/meta.dart';
import '../action_report.dart';

class AuthState {
  UserModel user;
  final Map<String, ActionReport> status;

  AuthState({
    @required this.user,
    @required this.status,
  });

  factory AuthState.initial() {
    return AuthState(
      user: null,
      status: Map(),
    );
  }

  AuthState copyWith({
    UserModel user,
    Map<String, ActionReport> status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status ?? Map(),
    );
  }
}
