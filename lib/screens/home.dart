import 'package:flutter/material.dart';
import 'package:flutter_amplify_auth/design/constants/text_styles.dart';
import 'package:flutter_amplify_auth/design/theme/app_theme.dart';
import 'package:flutter_amplify_auth/infrastructure/auth/auth_presenter.dart';
import 'package:flutter_amplify_auth/redux/app_state.dart';
import 'package:flutter_amplify_auth/redux/auth/auth_action.dart';
import 'package:flutter_amplify_auth/screens/auth/sign_in.dart';
import 'package:flutter_amplify_auth/screens/home/add_todo.dart';
import 'package:flutter_amplify_auth/screens/home/todos.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/homePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        actions: const [_LogoutActionButton()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.getColors().brand.primary,
        backgroundColor: AppTheme.getColors().background.tertiary,
        selectedLabelStyle: TextStyles.small,
        onTap: (value) => setState(() => _selectedIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "Todos"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add todo"),
        ],
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    if (_selectedIndex == 1) {
      return const AddTodoPage();
    }

    return const TodosPage();
  }

  String _getPageTitle() {
    if (_selectedIndex == 1) {
      return "Add Todo";
    }

    return "Todos";
  }
}

class _LogoutActionButton extends StatelessWidget {
  const _LogoutActionButton();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      distinct: true,
      converter: (store) => AuthPresenter.present(authState: store.state.authState),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is AuthInitialViewModel) {
          Navigator.pushNamedAndRemoveUntil(context, SignInPage.routeName, (route) => false);
        }
      },
      builder: (context, viewModel) => IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    StoreProvider.of<AppState>(context).dispatch(SignOutCommandAction());
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout),
      ),
    );
  }
}
