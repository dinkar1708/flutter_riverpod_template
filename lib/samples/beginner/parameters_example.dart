import 'package:flutter/material.dart';

/// Named vs Positional Parameters Example
class ParametersExample extends StatelessWidget {
  const ParametersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parameters: Named vs Positional'),
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Colors.cyan.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.code, color: Colors.cyan),
                      SizedBox(width: 8),
                      Text(
                        'Named vs Positional Parameters',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Positional - Order matters'),
                  Text('Named - Order does not matter'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Positional Example
          const Text(
            '1. Positional Parameters',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _PositionalExample(
            'John',
            25,
            'Developer',
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '_PositionalExample(\n'
                    '  \'John\',      // Must be first\n'
                    '  25,          // Must be second\n'
                    '  \'Developer\', // Must be third\n'
                    ')',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Named Example
          const Text(
            '2. Named Parameters',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const _NamedExample(
            age: 30,
            job: 'Designer',
            name: 'Sarah',
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '_NamedExample(\n'
                    '  age: 30,         // Order does not matter\n'
                    '  job: \'Designer\',\n'
                    '  name: \'Sarah\',\n'
                    ')',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Mixed Example
          const Text(
            '3. Mixed (Positional + Named)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _MixedExample(
            'Alex',
            age: 28,
            job: 'Manager',
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.purple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Code:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '_MixedExample(\n'
                    '  \'Alex\',          // Positional (first)\n'
                    '  age: 28,         // Named (order flexible)\n'
                    '  job: \'Manager\',  // Named (order flexible)\n'
                    ')',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
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
                    'Comparison',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildComparisonRow('Order', 'Matters', 'Flexible'),
                  _buildComparisonRow('Readability', 'Less clear', 'More clear'),
                  _buildComparisonRow('Optional', 'No', 'Yes (with ?)'),
                  _buildComparisonRow('Required', 'All', 'Use required'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String positional, String named) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(positional, style: const TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(named, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

// Positional Parameters Widget
class _PositionalExample extends StatelessWidget {
  final String name;
  final int age;
  final String job;

  const _PositionalExample(this.name, this.age, this.job);

  @override
  Widget build(BuildContext context) {
    debugPrint('[POSITIONAL] name: $name, age: $age, job: $job');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Job: $job'),
          ],
        ),
      ),
    );
  }
}

// Named Parameters Widget
class _NamedExample extends StatelessWidget {
  final String name;
  final int age;
  final String job;

  const _NamedExample({
    required this.name,
    required this.age,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[NAMED] name: $name, age: $age, job: $job');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Job: $job'),
          ],
        ),
      ),
    );
  }
}

// Mixed Parameters Widget
class _MixedExample extends StatelessWidget {
  final String name;
  final int age;
  final String job;

  // ignore: prefer_const_constructors_in_immutables
  _MixedExample(
    this.name, {
    required this.age,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[MIXED] name: $name, age: $age, job: $job');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Job: $job'),
          ],
        ),
      ),
    );
  }
}
