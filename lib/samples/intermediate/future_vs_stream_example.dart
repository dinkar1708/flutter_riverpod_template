import 'package:flutter/material.dart';
import 'dart:async';

/// Future vs Stream Example - Understand the difference
class FutureVsStreamExample extends StatelessWidget {
  const FutureVsStreamExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Future vs Stream'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Comparison Card
          Card(
            color: Colors.indigo.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Future vs Stream',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Future - Single value in the future (one-time)'),
                  Text('Stream - Multiple values over time (continuous)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Future Example
          _buildSectionHeader('1. Future - One Value'),
          const SizedBox(height: 8),
          const _FutureExample(),
          const SizedBox(height: 16),

          // Stream Example
          _buildSectionHeader('2. Stream - Multiple Values'),
          const SizedBox(height: 8),
          const _StreamExample(),
          const SizedBox(height: 16),

          // Comparison Table
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
                  _buildComparisonRow('Returns', 'Single value', 'Multiple values'),
                  _buildComparisonRow('When', 'One time', 'Over time'),
                  _buildComparisonRow('Widget', 'FutureBuilder', 'StreamBuilder'),
                  _buildComparisonRow('Example', 'API call', 'Chat messages'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildComparisonRow(String label, String future, String stream) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
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
              child: Text(future, style: const TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(stream, style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

// Future Example - Single value
class _FutureExample extends StatefulWidget {
  const _FutureExample();

  @override
  State<_FutureExample> createState() => _FutureExampleState();
}

class _FutureExampleState extends State<_FutureExample> {
  Future<String> _fetchData() async {
    debugPrint('🔵 [FUTURE] Starting to fetch data...');
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('🔵 [FUTURE] Data fetched: "Hello from Future"');
    return 'Hello from Future';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Future Example',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading...'),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          snapshot.data!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                return const Text('No data');
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Future completes once with single value',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// Stream Example - Multiple values
class _StreamExample extends StatefulWidget {
  const _StreamExample();

  @override
  State<_StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<_StreamExample> {
  Stream<int> _countStream() async* {
    debugPrint('🟣 [STREAM] Starting count stream...');
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('🟣 [STREAM] Emitting value: $i');
      yield i;
    }
    debugPrint('🟣 [STREAM] Stream completed');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.stream, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Stream Example',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StreamBuilder<int>(
              stream: _countStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Waiting for stream...'),
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.active) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.update, color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Count: ${snapshot.data ?? 0}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.done_all, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Stream completed!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return const Text('No data');
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Stream emits multiple values over time (1-5)',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
