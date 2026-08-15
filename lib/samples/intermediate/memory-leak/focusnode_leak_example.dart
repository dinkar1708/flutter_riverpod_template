import 'package:flutter/material.dart';

// WRONG EXAMPLE: FocusNode not disposed
class FocusNodeLeakExample extends StatefulWidget {
  const FocusNodeLeakExample({super.key});

  @override
  State<FocusNodeLeakExample> createState() => _FocusNodeLeakExampleState();
}

class _FocusNodeLeakExampleState extends State<FocusNodeLeakExample> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    debugPrint('🔴 [LEAK] FocusNode created - ID: ${_focusNode.hashCode}');
    debugPrint('⚠️ [LEAK] This FocusNode will NEVER be disposed!');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('⚠️ [LEAK] Widget is being removed but FocusNode is NOT disposed!');
    debugPrint('💀 [LEAK] FocusNode ${_focusNode.hashCode} will stay in memory FOREVER!');
  }

  // ❌ ERROR: FocusNode not disposed - MEMORY LEAK!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: FocusNode Not Disposed'),
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
                          'DevTools: Memory Tab',
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
                      'Verify: Search "FocusNode" in diff, should show instance count > 0',
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
                  '❌ WRONG: FocusNode NOT disposed!\n'
                  'FocusNode must be disposed like controllers.\n'
                  'Check console when you navigate back.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Tap to focus',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _focusNode.requestFocus();
                debugPrint('🔴 [LEAK] Focus requested');
              },
              child: const Text('Request Focus'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'FocusNode remains in memory!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// RIGHT EXAMPLE: FocusNode properly disposed
class FocusNodeGoodExample extends StatefulWidget {
  const FocusNodeGoodExample({super.key});

  @override
  State<FocusNodeGoodExample> createState() => _FocusNodeGoodExampleState();
}

class _FocusNodeGoodExampleState extends State<FocusNodeGoodExample> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    debugPrint('✅ [GOOD] FocusNode created - ID: ${_focusNode.hashCode}');
  }

  @override
  void dispose() {
    debugPrint('✅ [GOOD] Disposing FocusNode - ID: ${_focusNode.hashCode}');
    _focusNode.dispose(); // ✅ PROPERLY DISPOSED
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: FocusNode Disposed'),
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
                          'DevTools: Memory Tab',
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
                      'Verify: FocusNode instances should be 0 after GC',
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
                  '✅ CORRECT: FocusNode properly disposed!\n'
                  'No memory leak.\n'
                  'Check console when you navigate back.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Tap to focus',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _focusNode.requestFocus();
                debugPrint('✅ [GOOD] Focus requested');
              },
              child: const Text('Request Focus'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'FocusNode is properly cleaned up!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
