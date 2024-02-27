import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/amplifyconfiguration.dart';
import 'package:flutter_amplify_auth/app.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_service.dart';
import 'package:flutter_amplify_auth/models/ModelProvider.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/store_factory.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();

  final store = _buildStore();

  runApp(App(store: store));
}

Store<AppState> _buildStore() {
  final amplifyAuth = Amplify.Auth;

  return createStore(
    initialState: AppState.initial(),
    authService: AuthService(amplifyAuth: amplifyAuth),
  );
}

Future<void> _configureAmplify() async {
  try {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final auth = AmplifyAuthCognito();

    await Amplify.addPlugins([api, auth]);
    await Amplify.configure(amplifyconfig);

    debugPrint("Amplify configured");
  } catch (error) {
    debugPrint("Could not configure Amplify: $error");
  }
}
