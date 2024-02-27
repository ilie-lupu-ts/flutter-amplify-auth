import 'package:flutter/material.dart';

class AddTodoPage extends StatelessWidget {
  static const routeName = "/addTodoPage";

  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Add Todo"),
          ],
        ),
      ),
    );
  }
}
