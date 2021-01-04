import 'package:easy_buy/redux/realtime/realtime_middleware.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/app/app_reducer.dart';

import 'auth/auth_middleware.dart';

Future<Store<AppState>> createStore() async {
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: []
      ..addAll(createAuthMiddleware())
      ..addAll(createRealtimeMiddleware())
      ..addAll([
        LoggingMiddleware<dynamic>.printer(level: Level.ALL),
      ]),
  );
}