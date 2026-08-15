import 'package:flutter/material.dart';

/// TextEditingController Example
class TextEditingControllerExample extends StatefulWidget {
  const TextEditingControllerExample({super.key});

  @override
  State<TextEditingControllerExample> createState() =>
      _TextEditingControllerExampleState();
}

class _TextEditingControllerExampleState
    extends State<TextEditingControllerExample> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    // Listen to changes
    _controller.addListener(() {
      debugPrint('[CONTROLLER] Text changed: ${_controller.text}');
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Important: prevent memory leak
    debugPrint('[CONTROLLER] Disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextEditingController'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'TextEditingController',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Manages TextField state programmatically'),
                  Text('Read, modify, clear text from code'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // TextField with Controller
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Text Field:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type something...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Display Text
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Text:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _displayText.isEmpty ? '(empty)' : _displayText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          const Text(
            'Controller Actions:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          // Get Text Button
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _displayText = _controller.text;
              });
              debugPrint('[CONTROLLER] Get text: $_displayText');
            },
            icon: const Icon(Icons.download),
            label: const Text('Get Text'),
          ),
          const SizedBox(height: 8),

          // Set Text Button
          ElevatedButton.icon(
            onPressed: () {
              _controller.text = 'Hello from code!';
              debugPrint('[CONTROLLER] Set text: ${_controller.text}');
            },
            icon: const Icon(Icons.upload),
            label: const Text('Set Text'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          const SizedBox(height: 8),

          // Clear Text Button
          ElevatedButton.icon(
            onPressed: () {
              _controller.clear();
              setState(() {
                _displayText = '';
              });
              debugPrint('[CONTROLLER] Cleared text');
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Text'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          const SizedBox(height: 16),

          // Use Cases Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Use Cases:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildUseCase('Read text value', 'controller.text'),
                  _buildUseCase('Set text value', 'controller.text = "value"'),
                  _buildUseCase('Clear text', 'controller.clear()'),
                  _buildUseCase('Listen to changes', 'controller.addListener()'),
                  _buildUseCase('Dispose', 'controller.dispose() in dispose()'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Important Note
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Important',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Always dispose controllers to prevent memory leaks'),
                  SizedBox(height: 4),
                  Text(
                    '@override\nvoid dispose() {\n  controller.dispose();\n  super.dispose();\n}',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCase(String title, String code) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
