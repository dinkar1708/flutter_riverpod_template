import 'package:flutter/material.dart';

/// Null Safety Operators Example
class NullSafetyExample extends StatefulWidget {
  const NullSafetyExample({super.key});

  @override
  State<NullSafetyExample> createState() => _NullSafetyExampleState();
}

class _NullSafetyExampleState extends State<NullSafetyExample> {
  String? _nullableText;
  String _nonNullText = 'Hello';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Null Safety Operators'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Null Safety Operators',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('? - Nullable type'),
                  Text('! - Null assertion (force unwrap)'),
                  Text('?. - Null-aware access'),
                  Text('?? - Null coalescing'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Current State Display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Values:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Nullable: ${_nullableText ?? 'null'}'),
                  Text('Non-null: $_nonNullText'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Operator 1: ? (Nullable)
          const Text(
            '1. ? - Nullable Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'String? can be null or String',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'String? name = null; // OK\nString name = null; // ERROR',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Text('Current: $_nullableText'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _nullableText = 'Now has value!';
                      });
                      debugPrint('[NULL SAFETY] Set nullable to: $_nullableText');
                    },
                    child: const Text('Set Value'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Operator 2: ?. (Null-aware access)
          const Text(
            '2. ?. - Null-aware Access',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Safe access - returns null if object is null',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'text?.length  // Returns null if text is null\ntext.length   // ERROR if text is null',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Text('Length: ${_nullableText?.length ?? 'null'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Operator 3: ?? (Null coalescing)
          const Text(
            '3. ?? - Null Coalescing',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provide default value if null',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'text ?? "default"  // Use "default" if text is null',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Text('Display: ${_nullableText ?? 'No value set'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Operator 4: ! (Null assertion)
          const Text(
            '4. ! - Null Assertion',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Force unwrap - DANGER: crashes if null',
                    style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'text!  // CRASH if text is null\nOnly use when 100% sure not null',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      try {
                        // Intentionally cause error for demo
                        String? nullValue;
                        debugPrint('[NULL SAFETY] Attempting to use ! on null...');
                        final result = nullValue!; // This will throw
                        debugPrint('Result: $result'); // Never reached
                      } catch (e) {
                        debugPrint('[NULL SAFETY] ERROR: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ERROR: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('Demo ! Error (Safe)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Comparison Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'When to Use Each',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildUseCase('?', 'Allow variable to be null', Colors.blue),
                  const SizedBox(height: 8),
                  _buildUseCase('?.', 'Safe access to nullable object', Colors.green),
                  const SizedBox(height: 8),
                  _buildUseCase('??', 'Provide default value', Colors.purple),
                  const SizedBox(height: 8),
                  _buildUseCase('!', 'When 100% sure not null (use sparingly)', Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCase(String operator, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              operator,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(description, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
