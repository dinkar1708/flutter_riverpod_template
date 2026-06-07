import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Commented for demo - uncomment for real implementation:
// import 'package:flutter_riverpod_template/data/remote/api/api_result_state.dart';
// import 'package:flutter_riverpod_template/feature/login/models/login_request_model.dart';
// import 'package:flutter_riverpod_template/feature/login/models/login_state_model.dart';
// import 'package:flutter_riverpod_template/feature/login/providers/login_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/ui_utils.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/common_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Commented for demo - uncomment for real implementation:
  // LoginNotifier get loginNotifier => ref.read(loginProvider.notifier);

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Commented for demo - uncomment for real implementation:
    // final loginState = ref.watch(loginProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Default Username Info Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: colors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Demo Mode: Default username is "dinkar1708"',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colors.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
                _buildLoginFormView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFormView() {
    return Column(
      children: [
        // Error Message (commented for demo - uncomment for real implementation)
        // if (loginState.value?.errorMessage != null &&
        //     loginState.value!.errorMessage.isNotEmpty)
        //   Container(
        //     padding: const EdgeInsets.all(12),
        //     margin: const EdgeInsets.only(bottom: 16),
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
        //       borderRadius: BorderRadius.circular(12),
        //       border: Border.all(
        //         color: Theme.of(context).colorScheme.error,
        //       ),
        //     ),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.error_outline,
        //           color: Theme.of(context).colorScheme.error,
        //         ),
        //         const SizedBox(width: 12),
        //         Expanded(
        //           child: Text(
        //             loginState.value!.errorMessage,
        //             style: TextStyle(
        //               color: Theme.of(context).colorScheme.error,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),

        // Username Field
        CommonTextField(
          controller: _userNameController,
          hintText: 'Enter username',
          labelText: 'Username',
          helperText: 'Default: google | Try: facebook, microsoft, apple, or any GitHub username',
          prefixIcon: const Icon(Icons.person_outline),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),

        // Password Field
        CommonTextField(
          controller: _passwordController,
          hintText: 'Enter password',
          labelText: 'Password',
          helperText: 'Nothing, just for demo',
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
        _buildLoginButtonView(),

        const SizedBox(height: 16),

        // Divider with OR
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: 16),

        // Google Login Button
        OutlinedButton(
          onPressed: _handleGoogleLogin,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.google.com/favicon.ico',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.login,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Continue with Google'),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Apple Login Button
        ElevatedButton(
          onPressed: _handleAppleLogin,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apple,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text('Continue with Apple'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Divider with OR
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

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

        const SizedBox(height: 24),

        // Contact Support Button
        TextButton.icon(
          onPressed: _handleContactSupport,
          icon: const Icon(Icons.email_outlined, size: 18),
          label: const Text('Contact Support'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButtonView() {
    // Commented for demo - uncomment for real implementation:
    // final isLoading =
    //     loginState.value?.apiResultState == APIResultState.loading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _handleLogin,
        child: const Text('Sign In'),
        // For real implementation with loading state:
        // onPressed: isLoading ? null : _handleLogin,
        // child: isLoading
        //     ? const SizedBox(
        //         width: 24,
        //         height: 24,
        //         child: CircularProgressIndicator(
        //           strokeWidth: 2,
        //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //         ),
        //       )
        //     : const Text('Sign In'),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // TODO: Implement real login validation
    // TODO: Validate username and password fields
    // TODO: Call actual login API

    // For demo: Store user session and navigate to home
    // Default to 'dinkar1708' if no username entered (valid GitHub username for demo)
    final username = _userNameController.text.isNotEmpty
        ? _userNameController.text
        : 'dinkar1708';

    ref.read(userSessionProvider.notifier).login(
      username: username,
      email: '${username.toLowerCase().replaceAll(' ', '')}@example.com',
      loginMethod: 'email',
    );

    showSnackBar(
      context,
      'Welcome $username!',
      type: SnackBarType.success,
    );
    context.router.replaceAll([const HomeWithTabsRoute()]);

    /* Real implementation (commented for demo):
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
    */
  }

  void _handleGuestLogin() {
    // TODO: Implement guest session tracking
    // TODO: Set guest user flag in local storage
    // TODO: Track guest analytics

    // For demo: Store guest session
    // Use entered username or default to 'dinkar1708' for valid GitHub repos
    final username = _userNameController.text.isNotEmpty
        ? _userNameController.text
        : 'dinkar1708';

    ref.read(userSessionProvider.notifier).login(
      username: username,
      email: '${username.toLowerCase().replaceAll(' ', '')}@example.com',
      loginMethod: 'guest',
    );

    showSnackBar(context, 'Welcome $username!', type: SnackBarType.success);
    context.router.replaceAll([const HomeWithTabsRoute()]);
  }

  void _handleGoogleLogin() {
    // TODO: Implement Google Sign-In
    // TODO: Add google_sign_in package
    // TODO: Configure Google OAuth credentials (Firebase/Google Cloud Console)
    // TODO: Handle authentication flow and token exchange
    // TODO: Store user credentials securely

    // For demo: Store Google user session
    // Use entered username or default to 'dinkar1708' for valid GitHub repos
    final username = _userNameController.text.isNotEmpty
        ? _userNameController.text
        : 'dinkar1708';

    ref.read(userSessionProvider.notifier).login(
      username: username,
      email: '${username.toLowerCase().replaceAll(' ', '')}@gmail.com',
      loginMethod: 'google',
    );

    showSnackBar(
      context,
      'Welcome $username!',
      type: SnackBarType.success,
    );
    context.router.replaceAll([const HomeWithTabsRoute()]);
  }

  void _handleAppleLogin() {
    // TODO: Implement Apple Sign-In
    // TODO: Add sign_in_with_apple package
    // TODO: Configure Apple Sign In capabilities in Xcode
    // TODO: Add Sign in with Apple capability in Apple Developer Portal
    // TODO: Handle authentication flow and token exchange
    // TODO: Store user credentials securely
    // TODO: Request user's name and email if needed

    // For demo: Store Apple user session
    // Use entered username or default to 'dinkar1708' for valid GitHub repos
    final username = _userNameController.text.isNotEmpty
        ? _userNameController.text
        : 'dinkar1708';

    ref.read(userSessionProvider.notifier).login(
      username: username,
      email: '${username.toLowerCase().replaceAll(' ', '')}@icloud.com',
      loginMethod: 'apple',
    );

    showSnackBar(
      context,
      'Welcome $username!',
      type: SnackBarType.success,
    );
    context.router.replaceAll([const HomeWithTabsRoute()]);
  }

  Future<void> _handleContactSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      queryParameters: {
        'subject': 'Login Support Request',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        showSnackBar(
          context,
          'Could not launch email app',
          type: SnackBarType.error,
        );
      }
    }
  }
}
