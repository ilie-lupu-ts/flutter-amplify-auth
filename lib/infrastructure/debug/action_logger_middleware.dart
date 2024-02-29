import 'dart:developer';

import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:redux/redux.dart';

class ActionLoggerMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);

    log(action.runtimeType.toString(), name: "dispatch");
  }
}
