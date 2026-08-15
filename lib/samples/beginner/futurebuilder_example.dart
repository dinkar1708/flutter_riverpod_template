import 'package:flutter/material.dart';

class FutureBuilderExample extends StatefulWidget {
  const FutureBuilderExample({super.key});

  @override
  State<FutureBuilderExample> createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
  late Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchData();
  }

  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded successfully at ${DateTime.now().toString().substring(11, 19)}';
  }

  void _reload() {
    setState(() {
      _future = _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FutureBuilder Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FutureBuilder handles async data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Shows loading, data, and error states automatically',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: FutureBuilder<String>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading data...'),
                        ],
                      );
                    }

                    if (snapshot.hasError) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                        ],
                      );
                    }

                    if (snapshot.hasData) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                snapshot.data!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Text('No data');
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
