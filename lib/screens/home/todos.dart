import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/design/theme/app_theme.dart';
import 'package:flutter_amplify_auth/models/Todo.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: _getTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final todos = snapshot.data as List<Todo?>;

                if (todos.isEmpty) {
                  return Center(child: Text("No todos found", style: TextStyles.medium));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: todos.length,
                  separatorBuilder: (context, index) => const SizedBox(height: Spacings.x_2_5),
                  itemBuilder: (context, todoIndex) {
                    final todo = todos[todoIndex];

                    return ListTile(
                      title: Text(
                        todo?.name ?? "",
                        style: TextStyles.regular.copyWith(color: AppTheme.getColors().font.interactive),
                      ),
                      subtitle: Text(todo?.description ?? ""),
                      tileColor: AppTheme.getColors().background.tertiary,
                      contentPadding: const EdgeInsets.symmetric(horizontal: Spacings.x_4),
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            })
      ],
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
