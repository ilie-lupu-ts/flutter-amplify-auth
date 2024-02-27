import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_reducer.dart';

AppState appReducer(AppState currentState, dynamic action) {
  return AppState(
    authState: authReducer(currentState.authState, action),
  );
}
