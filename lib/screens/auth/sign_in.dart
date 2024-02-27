import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_state.dart';
import 'package:flutter_amplify_auth/screens/home.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/signInPage';

  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController(text: "ilie.lupu+1@thinslices.com");
  final TextEditingController _passwordController = TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(SignInCommandAction(
                  username: _usernameController.text,
                  password: _passwordController.text,
                ));
              },
              child: Text("sign in"),
            ),
            ElevatedButton(
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(SignOutCommandAction());
              },
              child: Text("sign out"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      final result = await Amplify.Auth.signIn(
        username: "ilie.lupu+1@thinslices.com",
        password: "12345678",
      );

      print(result);
    } catch (error) {
      print("Login error: $error");
    }
  }
}
