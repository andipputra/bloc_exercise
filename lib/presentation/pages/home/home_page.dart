import 'package:day_22_riverpod_exercise/presentation/pages/authentication/authentication_page.dart';
import 'package:day_22_riverpod_exercise/presentation/view_models/authentication/authentication_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authenticationViewModelProvider, (previous, next) {
      if (next.isLoading) {
        showDialog(
          context: context,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );
      } else {
        final canPop = Navigator.canPop(context);
        if (canPop) {
          Navigator.pop(context);
        }
      }
    });

    final authState = ref.watch(authenticationViewModelProvider);

    final user = authState.value;

    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: user == null
            ? GoToLoginButton()
            : UserInfo(
                user: user,
                onLogout: ref
                    .read(authenticationViewModelProvider.notifier)
                    .logout,
              ),
      ),
    );
  }
}

class GoToLoginButton extends StatelessWidget {
  const GoToLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AuthenticationPage()));
      },
      child: Text('Go to Login'),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.user, required this.onLogout});

  final User user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('User Email: ${user.email}'),
        Text('User UID: ${user.uid}'),
        ElevatedButton(
          onPressed: onLogout,
          child: Text('Logout'),
        ),
      ],
    );
  }
}
