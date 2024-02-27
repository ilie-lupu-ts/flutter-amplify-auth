import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/models/Todo.dart';
import 'package:flutter_amplify_auth/screens/add_todo.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/homePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _incrementCounter() async {
    try {
      final newTodo = Todo(
        name: 'My first todo',
        description: 'Hello world!',
      );
      final request = ModelMutations.create(newTodo);
      print(Amplify.isConfigured);
      final response = await Amplify.API.mutate(request: request).response;
      final data = response.data;
      print(data);
    } catch (error) {
      print(error);
    }
  }

  void _getAuthenticatedUser() async {
    try {
      final response = await Amplify.Auth.getCurrentUser();
      print(response);
    } catch (error) {
      print(error);
    }
  }

  void _logout() async {
    try {
      await Amplify.Auth.signOut();
    } catch (error) {
      print(error);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          Text(
            'Hello',
          ),
          ElevatedButton(onPressed: _incrementCounter, child: Text("Add todo")),
          ElevatedButton(onPressed: _getAuthenticatedUser, child: Text("Get user")),
          ElevatedButton(onPressed: _signIn, child: Text("Sign in")),
          ElevatedButton(onPressed: _logout, child: Text("Logout")),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AddTodoPage.routeName),
            child: Text("Add todo page"),
          )
        ],
      ),
    );
  }
}
