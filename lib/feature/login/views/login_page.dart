import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
import 'package:flutter_riverpod_template/feature/login/models/login_state_model.dart';
import 'package:flutter_riverpod_template/feature/login/providers/login_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/ui_utils.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/common_text_field.dart';

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
  bool _obscurePassword = true;

  LoginNotifier get loginNotifier => ref.read(loginProvider.notifier);

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 50,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome Text
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 48),

                // Login Form
                _buildLoginFormView(loginState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFormView(AsyncValue<LoginStateModel> loginState) {
    return Column(
      children: [
        // Error Message
        if (loginState.value?.errorMessage != null &&
            loginState.value!.errorMessage.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loginState.value!.errorMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Username Field
        CommonTextField(
          controller: _userNameController,
          hintText: 'Enter your username',
          labelText: 'Username',
          prefixIcon: const Icon(Icons.person_outline),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password Field
        CommonTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          labelText: 'Password',
          obscureText: _obscurePassword,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleLogin(),
        ),
        const SizedBox(height: 24),

        // Login Button
        _buildLoginButtonView(loginState),

        const SizedBox(height: 16),

        // Guest Login Button
        OutlinedButton(
          onPressed: _handleGuestLogin,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Continue as Guest'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Forgot Password
        TextButton(
          onPressed: () {
            // Handle forgot password
          },
          child: const Text('Forgot Password?'),
        ),
      ],
    );
  }

  Widget _buildLoginButtonView(AsyncValue<LoginStateModel> loginState) {
    final isLoading =
        loginState.value?.apiResultState == APIResultState.loading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Sign In'),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final loginState = ref.read(loginProvider);
    if (loginState.value?.apiResultState == APIResultState.loading) {
      debugPrint('Previous click is still in progress...ignoring clicks...');
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
        'Welcome ${loginStateModel.loginResponseModel!.userName}!',
        type: SnackBarType.success,
      );
      context.router.replaceAll([const HomeWithTabsRoute()]);
    } else {
      showSnackBar(
        context,
        loginStateModel.errorMessage.isNotEmpty
            ? loginStateModel.errorMessage
            : 'Login failed. Please try again.',
        type: SnackBarType.error,
      );
    }
  }

  void _handleGuestLogin() {
    showSnackBar(context, 'Welcome Guest!', type: SnackBarType.success);
    context.router.replaceAll([const HomeWithTabsRoute()]);
  }
}
