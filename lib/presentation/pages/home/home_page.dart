import 'package:bloc_exercise/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return UserInfo(
                user: state.user,
                onLogout: () {
                  context.read<AuthenticationBloc>().add(LogoutEvent());
                },
              );
            }

            return GoToLoginButton();
          },
          listener: (context, state) {
            if (state is AuthenticationLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          listenWhen: (previous, current) =>
              current is AuthenticationLoading ||
              previous is AuthenticationLoading,
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
        Navigator.of(context).pushNamed('/auth');
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
        ElevatedButton(onPressed: onLogout, child: Text('Logout')),
      ],
    );
  }
}
