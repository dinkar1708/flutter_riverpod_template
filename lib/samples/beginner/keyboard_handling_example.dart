import 'package:flutter/material.dart';

class KeyboardHandlingExample extends StatelessWidget {
  const KeyboardHandlingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keyboard Handling')),
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
                        Icons.keyboard,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Keyboard Handling',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Problem: TextField at bottom gets hidden by keyboard.\n'
                    'Solution: Use SingleChildScrollView to auto-scroll content.',
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
            title: 'BAD: TextField Hidden by Keyboard',
            description: 'TextField at bottom without scroll - gets hidden',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [WRONG] Opening keyboard handling BAD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KeyboardHandlingBadExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // GOOD Example
          _buildExampleCard(
            context,
            title: 'GOOD: TextField Scrolls Into View',
            description: 'SingleChildScrollView scrolls content up for keyboard',
            color: Colors.green,
            onTap: () {
              debugPrint('✅ [GOOD] Opening keyboard handling GOOD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KeyboardHandlingGoodExample(),
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
              const SizedBox(height: 8),
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

// BAD EXAMPLE: TextField gets hidden by keyboard
class KeyboardHandlingBadExample extends StatefulWidget {
  const KeyboardHandlingBadExample({super.key});

  @override
  State<KeyboardHandlingBadExample> createState() =>
      _KeyboardHandlingBadExampleState();
}

class _KeyboardHandlingBadExampleState
    extends State<KeyboardHandlingBadExample> {
  final _topController = TextEditingController();
  final _middleController = TextEditingController();
  final _bottomController = TextEditingController();

  @override
  void dispose() {
    _topController.dispose();
    _middleController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (keyboardVisible) {
      debugPrint('🔴 [WRONG] Keyboard appeared but content cannot scroll!');
      debugPrint('🔴 [WRONG] Bottom TextField is now hidden behind keyboard!');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: Hidden by Keyboard'),
        backgroundColor: Colors.red,
      ),
      // ❌ WRONG: No SingleChildScrollView - content can't scroll
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '❌ WRONG: No scrolling!\n'
                  'Tap bottom TextField - it gets hidden by keyboard.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top content
            Container(
              height: 150,
              color: Colors.blue.shade100,
              alignment: Alignment.center,
              child: const Text('Top Content'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _topController,
              decoration: const InputDecoration(
                labelText: 'Top TextField',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              height: 150,
              color: Colors.green.shade100,
              alignment: Alignment.center,
              child: const Text('Middle Content'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _middleController,
              decoration: const InputDecoration(
                labelText: 'Middle TextField',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // Bottom TextField - will be hidden by keyboard
            TextField(
              controller: _bottomController,
              decoration: const InputDecoration(
                labelText: 'Bottom TextField (Tap me!)',
                border: OutlineInputBorder(),
                helperText: 'This will be hidden by keyboard',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// GOOD EXAMPLE: TextField scrolls into view when keyboard appears
class KeyboardHandlingGoodExample extends StatefulWidget {
  const KeyboardHandlingGoodExample({super.key});

  @override
  State<KeyboardHandlingGoodExample> createState() =>
      _KeyboardHandlingGoodExampleState();
}

class _KeyboardHandlingGoodExampleState
    extends State<KeyboardHandlingGoodExample> {
  final _topController = TextEditingController();
  final _middleController = TextEditingController();
  final _bottomController = TextEditingController();

  @override
  void dispose() {
    _topController.dispose();
    _middleController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    if (keyboardVisible) {
      debugPrint('✅ [GOOD] Keyboard appeared - content is scrolling!');
      debugPrint('✅ [GOOD] Bottom TextField remains visible above keyboard!');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Scrolls for Keyboard'),
        backgroundColor: Colors.green,
      ),
      resizeToAvoidBottomInset: true, // ✅ GOOD: Let Scaffold handle keyboard
      // ✅ GOOD: SingleChildScrollView allows content to scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '✅ CORRECT: With scrolling!\n'
                  'Tap bottom TextField - it scrolls into view.',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Top content
            Container(
              height: 150,
              color: Colors.blue.shade100,
              alignment: Alignment.center,
              child: const Text('Top Content'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _topController,
              decoration: const InputDecoration(
                labelText: 'Top TextField',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              height: 150,
              color: Colors.green.shade100,
              alignment: Alignment.center,
              child: const Text('Middle Content'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _middleController,
              decoration: const InputDecoration(
                labelText: 'Middle TextField',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 200),

            // Bottom TextField - will scroll into view when tapped
            TextField(
              controller: _bottomController,
              decoration: const InputDecoration(
                labelText: 'Bottom TextField (Tap me!)',
                border: OutlineInputBorder(),
                helperText: 'This scrolls into view when keyboard appears',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
