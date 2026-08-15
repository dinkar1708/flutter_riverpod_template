import 'package:flutter/material.dart';

/// Hot Reload vs Hot Restart Example
class HotReloadExample extends StatefulWidget {
  const HotReloadExample({super.key});

  @override
  State<HotReloadExample> createState() => _HotReloadExampleState();
}

class _HotReloadExampleState extends State<HotReloadExample> {
  int _counter = 0;
  final DateTime _createdAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    debugPrint('[HOT RELOAD] Widget created at: $_createdAt');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[HOT RELOAD] Build called - counter: $_counter');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Reload vs Hot Restart'),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Colors.amber.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Hot Reload vs Hot Restart',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Hot Reload - Preserves state (fast)'),
                  Text('Hot Restart - Resets state (slower)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Counter Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Test Hot Reload:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Counter: $_counter',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _counter++;
                      });
                    },
                    child: const Text('Increment'),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Try this:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('1. Increment counter to 5'),
                        Text('2. Hot Reload (r) - Counter stays at 5'),
                        Text('3. Hot Restart (R) - Counter resets to 0'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Created Time Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Widget Created At:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _createdAt.toString().substring(11, 19),
                    style: const TextStyle(fontSize: 24, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observe:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Hot Reload - Time stays same'),
                        Text('Hot Restart - Time changes'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Keyboard Shortcuts Card
          Card(
            color: Colors.purple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.keyboard, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Keyboard Shortcuts',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('Hot Reload: Press "r" in terminal'),
                  Text('Hot Restart: Press "R" in terminal'),
                  Text('Quit: Press "q" in terminal'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // When to Use Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'When to Use Each:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildUseCaseRow(
                    'Hot Reload',
                    'UI changes, widget updates, styling',
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  _buildUseCaseRow(
                    'Hot Restart',
                    'main() changes, global variables, initState issues',
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCaseRow(String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
