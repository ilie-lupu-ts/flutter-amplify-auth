import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/theme/default.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/screens/add_todo.dart';
import 'package:flutter_amplify_auth/screens/auth/sign_in.dart';
import 'package:flutter_amplify_auth/screens/home.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget {
  final Store<AppState> store;

  const App({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: defaultTheme,
        initialRoute: SignInPage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          AddTodoPage.routeName: (context) => const AddTodoPage(),
          SignInPage.routeName: (context) => const SignInPage(),
        },
      ),
    );
  }
}