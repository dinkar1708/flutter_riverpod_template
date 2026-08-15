import 'package:flutter/material.dart';

/// BuildContext Example - What is it and how to use it
class BuildContextExample extends StatelessWidget {
  const BuildContextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuildContext Example'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // What is BuildContext
          Card(
            color: Colors.deepPurple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'What is BuildContext?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Handle to location of a widget in the widget tree'),
                  SizedBox(height: 4),
                  Text('Access parent widgets, theme, media query, navigator'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Example 1: Accessing Theme
          _ExampleCard(
            title: '1. Accessing Theme',
            description: 'Get theme colors from context',
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                debugPrint('✅ [BuildContext] Accessing theme via context');
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'This uses theme color from context',
                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Example 2: Accessing MediaQuery
          _ExampleCard(
            title: '2. Accessing MediaQuery',
            description: 'Get screen size from context',
            child: Builder(
              builder: (context) {
                final size = MediaQuery.of(context).size;
                debugPrint('✅ [BuildContext] Screen size: ${size.width} x ${size.height}');
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Screen Width: ${size.width.toStringAsFixed(0)}'),
                      Text('Screen Height: ${size.height.toStringAsFixed(0)}'),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Example 3: Navigator
          _ExampleCard(
            title: '3. Using Navigator',
            description: 'Navigate using context',
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    debugPrint('✅ [BuildContext] Navigating via Navigator.of(context)');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const _SecondScreen(),
                      ),
                    );
                  },
                  child: const Text('Navigate to Second Screen'),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Example 4: ScaffoldMessenger
          _ExampleCard(
            title: '4. Showing SnackBar',
            description: 'Show snackbar using context',
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    debugPrint('✅ [BuildContext] Showing SnackBar via ScaffoldMessenger.of(context)');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('SnackBar shown using context!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Show SnackBar'),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Common Error Card
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Common Error',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Do not use BuildContext across async gaps"',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text('Wrong:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 4, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'await Future.delayed(...);\n'
                      'Navigator.pop(context); // ❌ May crash!',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                    ),
                  ),
                  const Text('Right:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'await Future.delayed(...);\n'
                      'if (mounted) Navigator.pop(context); // ✅ Safe',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 11),
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
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SecondScreen extends StatelessWidget {
  const _SecondScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Navigated using BuildContext!'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                debugPrint('✅ [BuildContext] Popping screen via Navigator.pop(context)');
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
