import 'package:easy_buy/redux/auth/auth_state.dart';
import 'package:easy_buy/redux/realtime/realtime_state.dart';
import 'package:flutter/cupertino.dart';

class AppState {
  final AuthState authState;
  final RealtimeState realtimeState;

  AppState({
    @required this.authState,
    @required this.realtimeState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      realtimeState: RealtimeState.initial(),
    );
  }
}
