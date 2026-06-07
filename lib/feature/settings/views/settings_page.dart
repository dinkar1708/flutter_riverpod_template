import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/my_app.dart' show themeModeProvider;
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/ui_utils.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                  },
                  title: const Text('Dark Mode'),
                  subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Help & Support Section
          _buildSectionHeader(context, 'Help & Support'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.router.push(
                      CommonWebviewRoute(
                        title: 'Help Center',
                        url: 'https://www.google.com',
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.contact_support_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Contact Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.router.push(
                      CommonWebviewRoute(
                        title: 'Contact Support',
                        url: 'https://www.google.com',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // About Section
          _buildSectionHeader(context, 'About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.router.push(
                      CommonWebviewRoute(
                        title: 'Privacy Policy',
                        url: 'https://www.google.com',
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.router.push(
                      CommonWebviewRoute(
                        title: 'Terms of Service',
                        url: 'https://www.google.com',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Danger Zone Section
          _buildSectionHeader(context, 'Danger Zone'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text('Permanently delete your account and data'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onTap: () => _showDeleteAccountDialog(context, ref),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteAccount(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Delete'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual account deletion logic
    // TODO: Call API to delete account
    // TODO: Clear local data and preferences
    // TODO: Logout user and navigate to login screen

    // Clear demo user session
    ref.read(userSessionProvider.notifier).logout();

    showSnackBar(
      context,
      'Account deleted successfully',
      type: SnackBarType.success,
    );

    // Navigate to login after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.router.replaceAll([LoginRoute(title: 'Login')]);
      }
    });
  }
}
