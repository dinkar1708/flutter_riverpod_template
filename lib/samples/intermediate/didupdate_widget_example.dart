import 'package:flutter/material.dart';

/// didUpdateWidget Lifecycle Example
class DidUpdateWidgetExample extends StatefulWidget {
  const DidUpdateWidgetExample({super.key});

  @override
  State<DidUpdateWidgetExample> createState() => _DidUpdateWidgetExampleState();
}

class _DidUpdateWidgetExampleState extends State<DidUpdateWidgetExample> {
  int _parentCounter = 0;
  String _color = 'Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('didUpdateWidget Lifecycle'),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Colors.purple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.update, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'didUpdateWidget',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Called when parent widget configuration changes'),
                  Text('Use to react to new widget parameters'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Parent State Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Parent State:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Counter: $_parentCounter'),
                  Text('Color: $_color'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _parentCounter++;
                            });
                            debugPrint('[PARENT] Counter changed: $_parentCounter');
                          },
                          child: const Text('Change Counter'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _color = _color == 'Blue' ? 'Red' : 'Blue';
                            });
                            debugPrint('[PARENT] Color changed: $_color');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                          child: const Text('Change Color'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Child Widget (demonstrates didUpdateWidget)
          _ChildWidget(
            counter: _parentCounter,
            color: _color,
          ),

          const SizedBox(height: 16),

          // Lifecycle Order Card
          Card(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lifecycle Order:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Text('1. initState() - First time only'),
                  Text('2. didUpdateWidget() - When parent changes'),
                  Text('3. build() - Every time state updates'),
                  Text('4. dispose() - When widget removed'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildWidget extends StatefulWidget {
  final int counter;
  final String color;

  const _ChildWidget({
    required this.counter,
    required this.color,
  });

  @override
  State<_ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<_ChildWidget> {
  late int _internalCounter;
  late String _internalColor;

  @override
  void initState() {
    super.initState();
    _internalCounter = widget.counter;
    _internalColor = widget.color;
    debugPrint('[CHILD initState] counter: $_internalCounter, color: $_internalColor');
  }

  @override
  void didUpdateWidget(_ChildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    debugPrint('[CHILD didUpdateWidget] Old counter: ${oldWidget.counter}, New counter: ${widget.counter}');
    debugPrint('[CHILD didUpdateWidget] Old color: ${oldWidget.color}, New color: ${widget.color}');

    // Update internal state if widget properties changed
    if (oldWidget.counter != widget.counter) {
      _internalCounter = widget.counter;
      debugPrint('[CHILD didUpdateWidget] Updated internal counter: $_internalCounter');
    }

    if (oldWidget.color != widget.color) {
      _internalColor = widget.color;
      debugPrint('[CHILD didUpdateWidget] Updated internal color: $_internalColor');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[CHILD build] counter: $_internalCounter, color: $_internalColor');

    return Card(
      color: _internalColor == 'Blue' ? Colors.blue.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.child_care, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Child Widget State:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Internal Counter: $_internalCounter'),
            Text('Internal Color: $_internalColor'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What happens:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '1. Parent changes counter/color\n'
                    '2. didUpdateWidget() called\n'
                    '3. Compare old vs new values\n'
                    '4. Update internal state if needed\n'
                    '5. build() called with new values',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
