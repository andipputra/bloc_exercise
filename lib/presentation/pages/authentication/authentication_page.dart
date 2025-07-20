import 'package:day_22_riverpod_exercise/core/enum/auth_type.dart';
import 'package:day_22_riverpod_exercise/presentation/view_models/authentication/authentication_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationPage extends ConsumerStatefulWidget {
  const AuthenticationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthenticationPageState();
}

class _AuthenticationPageState extends ConsumerState<AuthenticationPage> {
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

      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
      }

      if (next.value != null) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
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
                      ref
                          .read(authenticationViewModelProvider.notifier)
                          .authUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            authType: authType,
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
    );
  }
}
