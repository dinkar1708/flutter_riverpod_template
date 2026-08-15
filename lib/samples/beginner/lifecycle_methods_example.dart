import 'package:flutter/material.dart';

class LifecycleMethodsExample extends StatefulWidget {
  const LifecycleMethodsExample({super.key});

  @override
  State<LifecycleMethodsExample> createState() =>
      _LifecycleMethodsExampleState();
}

class _LifecycleMethodsExampleState extends State<LifecycleMethodsExample> {
  int _counter = 0;
  late String _initTime;
  int _buildCount = 0;
  int _didChangeDependenciesCount = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 [LifecycleExample] createState() called (before this)');
    _initTime = DateTime.now().toString().substring(11, 19);
    debugPrint('✅ [LifecycleExample] initState() - Called ONCE when widget is inserted into tree');
    debugPrint('   └─ Good for: Controllers, listeners, initial data fetch');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _didChangeDependenciesCount++;
    debugPrint('🔄 [LifecycleExample] didChangeDependencies() - Called after initState and when InheritedWidget changes');
    debugPrint('   └─ Call count: $_didChangeDependenciesCount');
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    debugPrint('🎨 [LifecycleExample] build() - Building UI (call #$_buildCount)');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lifecycle Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Toggle to trigger didUpdateWidget',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LifecycleMethodsExample(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
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
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'StatefulWidget Lifecycle',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check your IDE console/debug output to see lifecycle logs',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lifecycle Flow Card
          _buildMethodCard(
            context,
            step: '1',
            method: 'createState()',
            description: 'Creates the State object',
            whenCalled: 'When widget is first inserted into tree',
            color: Colors.blue,
          ),

          _buildMethodCard(
            context,
            step: '2',
            method: 'initState()',
            description: 'Initialize controllers, listeners, fetch initial data',
            whenCalled: 'Called ONCE after createState()',
            color: Colors.green,
            goodFor: 'TextEditingController, AnimationController, API calls',
          ),

          _buildMethodCard(
            context,
            step: '3',
            method: 'didChangeDependencies()',
            description: 'Called when InheritedWidget changes',
            whenCalled: 'After initState() and when Theme/MediaQuery updates',
            color: Colors.orange,
            callCount: _didChangeDependenciesCount,
          ),

          _buildMethodCard(
            context,
            step: '4',
            method: 'build()',
            description: 'Renders the UI - called frequently',
            whenCalled: 'After above methods and every setState()',
            color: Colors.purple,
            callCount: _buildCount,
          ),

          _buildMethodCard(
            context,
            step: '5',
            method: 'didUpdateWidget()',
            description: 'Parent rebuilt with new widget config',
            whenCalled: 'When parent passes new properties',
            color: Colors.teal,
            isOptional: true,
          ),

          _buildMethodCard(
            context,
            step: '6',
            method: 'setState()',
            description: 'Marks widget dirty and triggers rebuild',
            whenCalled: 'Called manually to update state',
            color: Colors.indigo,
            isAction: true,
          ),

          _buildMethodCard(
            context,
            step: '7',
            method: 'deactivate()',
            description: 'Widget temporarily removed from tree',
            whenCalled: 'Navigation pop, route change',
            color: Colors.deepOrange,
          ),

          _buildMethodCard(
            context,
            step: '8',
            method: 'dispose()',
            description: 'MUST dispose controllers to prevent memory leaks',
            whenCalled: 'Widget permanently removed',
            color: Colors.red,
            critical: true,
            goodFor: 'Dispose controllers, cancel streams, remove listeners',
          ),

          const SizedBox(height: 16),

          // Interactive Demo Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive Demo',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Widget created at:', _initTime),
                  _buildInfoRow('build() called:', '$_buildCount times'),
                  _buildInfoRow('Counter value:', '$_counter'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _counter++;
                          debugPrint('🔵 [User Action] setState() called - Counter: $_counter');
                          debugPrint('   └─ This will trigger build() to re-render UI');
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Increment (Triggers setState)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DemoChildWidget(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.navigate_next),
                      label: const Text('Open Child Widget'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        debugPrint('⬅️ [User Action] Navigator.pop() called');
                        debugPrint('   └─ This will trigger deactivate() then dispose()');
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Pop (Triggers dispose)'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Console Output Example
          Card(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Expected Console Output',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.green,
                              fontFamily: 'monospace',
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '📱 createState() called\n'
                    '✅ initState() - Called ONCE\n'
                    '🔄 didChangeDependencies() - Call count: 1\n'
                    '🎨 build() - Building UI (call #1)\n'
                    '🔵 setState() called - Counter: 1\n'
                    '🎨 build() - Building UI (call #2)\n'
                    '⚠️ deactivate() - Removing from tree\n'
                    '❌ dispose() - CLEANUP RESOURCES',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required String step,
    required String method,
    required String description,
    required String whenCalled,
    required Color color,
    String? goodFor,
    int? callCount,
    bool isOptional = false,
    bool isAction = false,
    bool critical = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  step,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          method,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                        ),
                      ),
                      if (callCount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'x$callCount',
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isOptional)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Optional',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      if (isAction)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Manual',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      if (critical)
                        const Icon(Icons.warning_amber, color: Colors.red, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'When: $whenCalled',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                  ),
                  if (goodFor != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Use for: $goodFor',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    debugPrint('⚠️ [LifecycleExample] deactivate() - Widget being removed from tree');
    debugPrint('   └─ Called before dispose() during navigation pop');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('❌ [LifecycleExample] dispose() - CLEANUP TIME!');
    debugPrint('   └─ Dispose controllers, cancel streams, remove listeners here');
    debugPrint('   └─ Widget will never be used again after this');
    super.dispose();
  }
}

// Demo child widget to show parent-child lifecycle
class DemoChildWidget extends StatefulWidget {
  const DemoChildWidget({super.key});

  @override
  State<DemoChildWidget> createState() => _DemoChildWidgetState();
}

class _DemoChildWidgetState extends State<DemoChildWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint('🟢 [ChildWidget] initState() called');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 [ChildWidget] build() called');
    return Scaffold(
      appBar: AppBar(title: const Text('Child Widget')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.child_care, size: 64),
            const SizedBox(height: 16),
            const Text('This is a child widget'),
            const SizedBox(height: 8),
            const Text('Check console for lifecycle logs'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                debugPrint('⬅️ [ChildWidget] Popping back to parent');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('❌ [ChildWidget] dispose() - Child widget cleanup');
    super.dispose();
  }
}
