import 'package:flutter_amplify_auth/infrastructure/auth/auth_middleware.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_service.dart';
import 'package:flutter_amplify_auth/redux/app_reducer.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:redux/redux.dart';

Store<AppState> createStore({
  required AppState initialState,
  required AuthService authService,
}) {
  return Store<AppState>(
    appReducer,
    initialState: initialState,
    middleware: [
      AuthMiddleware(authService: authService),
    ],
  );
}
