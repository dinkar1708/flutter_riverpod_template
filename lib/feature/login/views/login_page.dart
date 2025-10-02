import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_state_model.dart';
import 'package:flutter_riverpod_template/feature/login/providers/login_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/ui_utils.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/primary_button.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  final String title;

  const LoginPage({required this.title, super.key});

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
          child: _buildLoginFormView(loginState),
        ),
      ),
    );
  }

  Widget _buildLoginFormView(AsyncValue<LoginStateModel> loginState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.app_registration_rounded,
          size: 56,
          color: Colors.white,
        ),
        const SizedBox(height: 100),
        if (loginState.value?.errorMessage != null)
          Text(loginState.value!.errorMessage),
        TextField(
          controller: _userNameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        _buildLoginButtonView(loginState),
      ],
    );
  }

  Widget _buildLoginButtonView(AsyncValue<LoginStateModel> loginState) {
    final isLoading =
        loginState.value?.apiResultState == APIResultState.loading;
    return PrimaryButton(
      label: 'Login',
      icon: Icons.login,
      isLoading: isLoading,
      expanded: false,
      onPressed: () async {
        if (loginState.value?.apiResultState == APIResultState.loading) {
          debugPrint(
            'Previouse click is still in progress...ignoring clicks...',
          );
          return;
        }
        final loginRequestModel = LoginRequestModel(
          userName: _userNameController.text,
          password: _passwordController.text,
        );
        final loginStateModel = await loginNotifier.login(loginRequestModel);
        if (!mounted) return;
        if (loginStateModel.apiResultState == APIResultState.result &&
            loginStateModel.loginResponseModel != null) {
          showSnackBar(
            context,
            'Login success '
            '${loginStateModel.loginResponseModel!.userName}',
          );
          context.router.replaceAll([HomeRoute(title: 'Home')]);
        } else {
          // show error message as snack bar or dailog anything
          showSnackBar(context, 'Login failed ${loginStateModel.errorMessage}');
        }
      },
    );
  }
}
