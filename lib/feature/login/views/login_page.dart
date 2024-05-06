import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
import 'package:flutter_riverpod_template/feature/login/providers/login_notifier_provider.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  final String title;

  const LoginPage({
    required this.title,
    super.key,
  });

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // read just once
  LoginNotifier get loginNotifier => ref.read(loginNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    // watch all the times
    final loginState = ref.watch(loginNotifierProvider);

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (loginState.value == APIResultState.loading) {
                    debugPrint(
                        'Previouse click is still in progress...ignoring clicks...');
                    return;
                  }
                  final loginRequestModel = LoginRequestModel(
                    userName: _userNameController.text,
                    password: _passwordController.text,
                  );
                  final loginResponse =
                      await loginNotifier.login(loginRequestModel);
                  if (loginResponse != null) {
                    // TODO fix later
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Successful!')),
                    );
                  }
                },
                child: loginState.value == APIResultState.loading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
