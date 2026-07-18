import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/counter/providers/counter_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_app_bar.dart';

@RoutePage()
class CounterPage extends ConsumerWidget {
  final String title;

  const CounterPage({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the counter provider - UI will rebuild when counter changes
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: SharedAppBar(title: title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              identifier: 'counter_hint',
              label: 'Push plus button to increase counter:',
              child: const Text(
                'Push plus button to increase counter:',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Display counter value
            Text(
              'Value $counter',
              style: AppTextStyle.labelMedium.copyWith(
                color: context.color.textPrimary,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // Additional controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                IconButton.filled(
                  onPressed: counter > 0
                      ? () => ref.read(counterProvider.notifier).decrement()
                      : null,
                  icon: const Icon(Icons.remove),
                  tooltip: 'Decrement',
                ),
                const SizedBox(width: 16),
                // Reset button
                OutlinedButton(
                  onPressed: counter != 0
                      ? () => ref.read(counterProvider.notifier).reset()
                      : null,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                // Increment button
                IconButton.filled(
                  onPressed: () =>
                      ref.read(counterProvider.notifier).increment(),
                  icon: const Icon(Icons.add),
                  tooltip: 'Increment',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
