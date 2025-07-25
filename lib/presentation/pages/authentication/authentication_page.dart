import 'package:bloc_exercise/core/enum/auth_type.dart';
import 'package:bloc_exercise/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthenticationAuthenticated ||
            state is AuthenticationError) {
          Navigator.of(context).pop();
        }

        if (state is AuthenticationAuthenticated) {
          Navigator.of(context).popUntil((route) => route.settings.name == '/');
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Authentication')),
        bottomNavigationBar: BottomAppBar(
          height: kToolbarHeight * 2.5,
          child: Column(
            spacing: 16,
            children: AuthType.values
                .map(
                  (authType) => SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(
                          authType == AuthType.login
                              ? LoginEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                              : RegisterEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                        );
                      },
                      child: Text(authType.name.toUpperCase()),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
