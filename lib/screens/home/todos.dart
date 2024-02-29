import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/components/screen_scrollable_view.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/models/Todo.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScrollableView(
      padding: const EdgeInsets.symmetric(horizontal: Spacings.screenHorizontal),
      child: Column(
        children: [
          FutureBuilder(
              future: _getTodos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final todos = snapshot.data as List<Todo?>;

                return Column(
                  children: todos.map((todo) {
                    return ListTile(
                      title: Text(todo?.name ?? ""),
                      subtitle: Text(todo?.description ?? ""),
                    );
                  }).toList(),
                );
              })
        ],
      ),
    );
  }

  Future<List<Todo?>> _getTodos() async {
    try {
      final request = ModelQueries.list(Todo.classType);
      final response = await Amplify.API.query(request: request).response;
      final data = response.data;
      final items = data?.items ?? [];

      return items;
    } catch (error) {
      return [];
    }
  }
}
