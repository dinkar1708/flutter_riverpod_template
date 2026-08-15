import 'package:flutter/material.dart';

/// InheritedWidget Example - State propagation down widget tree
class InheritedWidgetExample extends StatefulWidget {
  const InheritedWidgetExample({super.key});

  @override
  State<InheritedWidgetExample> createState() => _InheritedWidgetExampleState();
}

class _InheritedWidgetExampleState extends State<InheritedWidgetExample> {
  int _counter = 0;
  String _theme = 'Light';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    debugPrint('[INHERITED] Counter incremented: $_counter');
  }

  void _toggleTheme() {
    setState(() {
      _theme = _theme == 'Light' ? 'Dark' : 'Light';
    });
    debugPrint('[INHERITED] Theme changed: $_theme');
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      counter: _counter,
      theme: _theme,
      onIncrement: _incrementCounter,
      onToggleTheme: _toggleTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InheritedWidget Example'),
          backgroundColor: Colors.indigo,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            // Info Card
            _InfoCard(),
            SizedBox(height: 16),

            // Display Widget (reads from InheritedWidget)
            _DisplayWidget(),
            SizedBox(height: 16),

            // Button Widget (reads from InheritedWidget)
            _ButtonWidget(),
            SizedBox(height: 16),

            // Nested Widget (deeply nested, still accesses InheritedWidget)
            _NestedParent(),
            SizedBox(height: 16),

            // Purpose Card
            _PurposeCard(),
          ],
        ),
      ),
    );
  }
}

// InheritedWidget - holds and propagates state
class AppStateProvider extends InheritedWidget {
  final int counter;
  final String theme;
  final VoidCallback onIncrement;
  final VoidCallback onToggleTheme;

  const AppStateProvider({
    super.key,
    required this.counter,
    required this.theme,
    required this.onIncrement,
    required this.onToggleTheme,
    required super.child,
  });

  // Access method - called from descendant widgets
  static AppStateProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
  }

  // Determines when to notify listeners
  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    final shouldNotify = oldWidget.counter != counter || oldWidget.theme != theme;
    if (shouldNotify) {
      debugPrint('[INHERITED] updateShouldNotify: true (counter or theme changed)');
    }
    return shouldNotify;
  }
}

// Info Card
class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo.shade50,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_tree, color: Colors.indigo),
                SizedBox(width: 8),
                Text(
                  'InheritedWidget',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Share state down widget tree'),
            Text('No need to pass through every widget'),
            Text('Used by Provider, Theme, MediaQuery'),
          ],
        ),
      ),
    );
  }
}

// Display Widget - reads from InheritedWidget
class _DisplayWidget extends StatelessWidget {
  const _DisplayWidget();

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    debugPrint('[DISPLAY] Reading counter: ${state?.counter}');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.visibility, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Display Widget',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Counter: ${state?.counter ?? 0}'),
            Text('Theme: ${state?.theme ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Accesses state via AppStateProvider.of(context)',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Button Widget - reads and modifies via InheritedWidget
class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget();

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.touch_app, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Button Widget',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('[BUTTON] Increment button pressed');
                      state?.onIncrement();
                    },
                    child: const Text('Increment'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint('[BUTTON] Toggle theme button pressed');
                      state?.onToggleTheme();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Toggle Theme'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Nested structure to show deep access
class _NestedParent extends StatelessWidget {
  const _NestedParent();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.layers, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Nested Parent Widget',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _NestedChild(),
          ],
        ),
      ),
    );
  }
}

class _NestedChild extends StatelessWidget {
  const _NestedChild();

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    debugPrint('[NESTED CHILD] Reading counter: ${state?.counter}');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nested Child (deeply nested)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text('Can still access counter: ${state?.counter ?? 0}'),
          const SizedBox(height: 4),
          const Text(
            'No need to pass through parent',
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// Purpose Card
class _PurposeCard extends StatelessWidget {
  const _PurposeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why Use InheritedWidget?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text('1. Share state without passing props'),
            Text('2. Any descendant can access'),
            Text('3. Used by Theme, MediaQuery, Provider'),
            Text('4. Foundation for state management'),
          ],
        ),
      ),
    );
  }
}
