import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/auth/auth_reducer.dart';
import 'package:easy_buy/redux/realtime/realtime_reducer.dart';

///register all the Reducer here
///auto add new reducer when using haystack plugin
AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    authState: authReducer(state.authState, action),
    realtimeState: realtimeReducer(state.realtimeState, action),
  );
}