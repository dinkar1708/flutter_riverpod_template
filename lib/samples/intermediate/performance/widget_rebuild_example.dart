import 'package:flutter/material.dart';

// Simple widget to track rebuild count
class RebuildCounter extends StatefulWidget {
  const RebuildCounter({super.key});

  @override
  State<RebuildCounter> createState() => _RebuildCounterState();
}

class _RebuildCounterState extends State<RebuildCounter> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('🔄 RebuildCounter rebuilt ${_rebuildCount} times');
    return Text(
      'Rebuilt: $_rebuildCount times',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
}

class WidgetRebuildExample extends StatelessWidget {
  const WidgetRebuildExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Rebuilds')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Widget Rebuild Performance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Problem: setState() rebuilds entire widget tree.\\n'
                    'Solution: Use const widgets to prevent unnecessary rebuilds.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // BAD Example
          _buildExampleCard(
            context,
            title: 'BAD: Rebuilds Everything',
            description: 'Every widget rebuilds on setState, even static ones',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [WRONG] Opening widget rebuild BAD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetRebuildBadExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // GOOD Example
          _buildExampleCard(
            context,
            title: 'GOOD: Only Necessary Rebuilds',
            description: 'const widgets skip rebuilds, only counter updates',
            color: Colors.green,
            onTap: () {
              debugPrint('✅ [GOOD] Opening widget rebuild GOOD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetRebuildGoodExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    color == Colors.red ? Icons.error : Icons.check_circle,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BAD EXAMPLE: All widgets rebuild on every setState
class WidgetRebuildBadExample extends StatefulWidget {
  const WidgetRebuildBadExample({super.key});

  @override
  State<WidgetRebuildBadExample> createState() =>
      _WidgetRebuildBadExampleState();
}

class _WidgetRebuildBadExampleState extends State<WidgetRebuildBadExample> {
  int _counter = 0;

  void _incrementCounter() {
    debugPrint('🔴 [WRONG] Calling setState - ALL widgets will rebuild!');
    setState(() {
      _counter++;
    });
    debugPrint('🔴 [WRONG] Static widgets rebuilt unnecessarily!');
    debugPrint('💀 [WRONG] Wasted CPU cycles rebuilding widgets that never change!');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔴 [WRONG] Building entire widget tree...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: Rebuilds Everything'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DevTools: Performance Tab',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Verify: Check widget rebuild stats, see all widgets rebuild',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '❌ WRONG: All widgets rebuild!\\n'
                  'Watch rebuild counters below - ALL increase.\\n'
                  'Even static text rebuilds unnecessarily!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Static header (but rebuilds every time!)
            _ExpensiveStaticHeader(),
            const SizedBox(height: 16),

            // Counter display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Counter: $_counter',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const RebuildCounter(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Static footer (but rebuilds every time!)
            _ExpensiveStaticFooter(),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Increment (All Widgets Rebuild!)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Expensive widget that should NOT rebuild (but does in BAD example)
class _ExpensiveStaticHeader extends StatefulWidget {
  @override
  State<_ExpensiveStaticHeader> createState() => _ExpensiveStaticHeaderState();
}

class _ExpensiveStaticHeaderState extends State<_ExpensiveStaticHeader> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('🔴 [WRONG] Static header rebuilt ${_rebuildCount} times (should be 1!)');
    return Card(
      color: Colors.orange.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Static Header',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Rebuilt: $_rebuildCount times',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensiveStaticFooter extends StatefulWidget {
  @override
  State<_ExpensiveStaticFooter> createState() => _ExpensiveStaticFooterState();
}

class _ExpensiveStaticFooterState extends State<_ExpensiveStaticFooter> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('🔴 [WRONG] Static footer rebuilt ${_rebuildCount} times (should be 1!)');
    return Card(
      color: Colors.orange.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Static Footer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Rebuilt: $_rebuildCount times',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// GOOD EXAMPLE: Only necessary widgets rebuild
class WidgetRebuildGoodExample extends StatefulWidget {
  const WidgetRebuildGoodExample({super.key});

  @override
  State<WidgetRebuildGoodExample> createState() =>
      _WidgetRebuildGoodExampleState();
}

class _WidgetRebuildGoodExampleState extends State<WidgetRebuildGoodExample> {
  int _counter = 0;

  void _incrementCounter() {
    debugPrint('✅ [GOOD] Calling setState - only counter widget rebuilds!');
    setState(() {
      _counter++;
    });
    debugPrint('✅ [GOOD] const widgets skipped rebuild!');
    debugPrint('✅ [GOOD] CPU saved by not rebuilding static widgets!');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [GOOD] Building widget tree (const widgets skip rebuild)...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Only Necessary Rebuilds'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DevTools: Performance Tab',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Verify: Check widget rebuild stats, only counter widget rebuilds',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '✅ CORRECT: Only counter rebuilds!\\n'
                  'Watch rebuild counters - static ones stay at 1.\\n'
                  'const widgets skip rebuild entirely!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Static header (const - never rebuilds!)
            const _ConstStaticHeader(),
            const SizedBox(height: 16),

            // Counter display (only this rebuilds)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Counter: $_counter',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const RebuildCounter(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Static footer (const - never rebuilds!)
            const _ConstStaticFooter(),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Increment (Only Counter Rebuilds!)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Const widget - NEVER rebuilds after initial build
class _ConstStaticHeader extends StatefulWidget {
  const _ConstStaticHeader();

  @override
  State<_ConstStaticHeader> createState() => _ConstStaticHeaderState();
}

class _ConstStaticHeaderState extends State<_ConstStaticHeader> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('✅ [GOOD] const header rebuilt ${_rebuildCount} times (should stay 1!)');
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'const Static Header',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Rebuilt: $_rebuildCount times',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstStaticFooter extends StatefulWidget {
  const _ConstStaticFooter();

  @override
  State<_ConstStaticFooter> createState() => _ConstStaticFooterState();
}

class _ConstStaticFooterState extends State<_ConstStaticFooter> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('✅ [GOOD] const footer rebuilt ${_rebuildCount} times (should stay 1!)');
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'const Static Footer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Rebuilt: $_rebuildCount times',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
