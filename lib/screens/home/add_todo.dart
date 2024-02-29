import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_amplify_auth/design/components/amplify_text_field.dart';
import 'package:flutter_amplify_auth/design/components/button.dart';
import 'package:flutter_amplify_auth/design/components/screen_scrollable_view.dart';
import 'package:flutter_amplify_auth/design/constants/spacings.dart';
import 'package:flutter_amplify_auth/models/Todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _loading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ScreenScrollableView(
      padding: const EdgeInsets.symmetric(horizontal: Spacings.screenHorizontal),
      child: Column(
        children: [
          AmplifyTextField(
            label: "Todo title",
            placeholder: "Enter todo title",
            controller: _titleController,
          ),
          const SizedBox(height: Spacings.x_4),
          AmplifyTextField(
            label: "Todo description",
            placeholder: "Enter todo description",
            controller: _descriptionController,
          ),
          const SizedBox(height: Spacings.x_6),
          ListenableBuilder(
            listenable: _loading,
            builder: (context, child) => Button(
              loading: _loading.value,
              text: "Add todo",
              onPressed: _addTodo,
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() async {
    try {
      final newTodo = Todo(
        name: _titleController.text,
        description: _descriptionController.text,
      );
      final request = ModelMutations.create(newTodo);
      _loading.value = true;

      await Amplify.API.mutate(request: request).response;
      _loading.value = false;
    } catch (error) {
      print(error);
      _loading.value = false;
    }
  }
}
