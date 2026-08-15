import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

// Simulated network scenarios for testing
enum NetworkScenario {
  success,
  timeout,
  noInternet,
  serverError,
  invalidJson,
}

class NetworkErrorExample extends StatelessWidget {
  const NetworkErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Error Handling')),
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
                        Icons.cloud_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Network Error Handling',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Problem: Network calls can fail (no internet, timeout, errors).\\n'
                    'Solution: Use try-catch with timeout and specific error handling.',
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
            title: 'BAD: No Error Handling',
            description: 'App crashes or hangs when network fails',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [WRONG] Opening network error BAD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NetworkErrorBadExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // GOOD Example
          _buildExampleCard(
            context,
            title: 'GOOD: Proper Error Handling',
            description: 'Handles timeouts, no internet, server errors gracefully',
            color: Colors.green,
            onTap: () {
              debugPrint('✅ [GOOD] Opening network error GOOD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NetworkErrorGoodExample(),
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
              const SizedBox(width: 8),
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

// BAD EXAMPLE: No error handling - crashes or hangs
class NetworkErrorBadExample extends StatefulWidget {
  const NetworkErrorBadExample({super.key});

  @override
  State<NetworkErrorBadExample> createState() => _NetworkErrorBadExampleState();
}

class _NetworkErrorBadExampleState extends State<NetworkErrorBadExample> {
  String? _result;
  String? _error;
  bool _isLoading = false;
  NetworkScenario _selectedScenario = NetworkScenario.success;

  Future<void> _fetchDataBad() async {
    debugPrint('🔴 [WRONG] Fetching data WITHOUT error handling...');

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      // ❌ WRONG: No try-catch, no timeout, no error handling!
      final data = await _simulateNetworkCall(_selectedScenario);

      debugPrint('🔴 [WRONG] Got data: $data');
      debugPrint('💀 [WRONG] If network failed, app would have crashed here!');

      if (!mounted) return;

      setState(() {
        _result = data;
        _isLoading = false;
      });
    } catch (e) {
      // This catch is ONLY for training purposes - to show the error
      // In real BAD code, this wouldn't exist and app would crash!
      debugPrint('💀 [WRONG] APP CRASHED! Error: $e');
      debugPrint('💀 [WRONG] In real code without try-catch, user sees crash screen!');
      if (!mounted) return;
      setState(() {
        _error = 'APP CRASHED!\n\n$e\n\nIn real code, user would see error screen and app might close!';
        _isLoading = false;
      });
    }
  }

  Future<String> _simulateNetworkCall(NetworkScenario scenario) async {
    switch (scenario) {
      case NetworkScenario.success:
        await Future.delayed(const Duration(seconds: 1));
        return '{"status": "success", "data": "Hello World"}';

      case NetworkScenario.timeout:
        debugPrint('💀 [WRONG] Simulating timeout - app will hang forever!');
        await Future.delayed(const Duration(seconds: 30));
        throw TimeoutException('Request timed out');

      case NetworkScenario.noInternet:
        debugPrint('💀 [WRONG] Simulating no internet - app will crash!');
        throw const SocketException('No internet connection');

      case NetworkScenario.serverError:
        debugPrint('💀 [WRONG] Simulating server error - app will crash!');
        throw const HttpException('Server returned 500');

      case NetworkScenario.invalidJson:
        debugPrint('💀 [WRONG] Simulating invalid JSON - app will crash!');
        return 'This is not valid JSON!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: No Error Handling'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'DevTools: Network Tab',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Verify: Open Network tab, trigger error, see failed request',
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
                  '❌ WRONG: No error handling!\\n'
                  'Select a scenario and tap fetch.\\n'
                  'Error scenarios show what WOULD crash in real code.\\n'
                  '(We catch errors for training - real code would crash!)',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Scenario selector
            const Text(
              'Select Test Scenario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildScenarioSelector(),
            const SizedBox(height: 24),

            // Fetch button
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchDataBad,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isLoading ? 'Loading...' : 'Fetch Data (No Error Handling!)'),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text('If scenario is timeout, this will hang forever!'),
            ],

            if (_error != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Crash Demonstration:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],

            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Result:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_result!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioSelector() {
    return Column(
      children: NetworkScenario.values.map((scenario) {
        return RadioListTile<NetworkScenario>(
          title: Text(_getScenarioName(scenario)),
          subtitle: Text(_getScenarioDescription(scenario)),
          value: scenario,
          groupValue: _selectedScenario,
          onChanged: (value) {
            setState(() {
              _selectedScenario = value!;
            });
          },
        );
      }).toList(),
    );
  }

  String _getScenarioName(NetworkScenario scenario) {
    switch (scenario) {
      case NetworkScenario.success:
        return '✅ Success';
      case NetworkScenario.timeout:
        return '⏱️ Timeout';
      case NetworkScenario.noInternet:
        return '📡 No Internet';
      case NetworkScenario.serverError:
        return '🔥 Server Error';
      case NetworkScenario.invalidJson:
        return '💥 Invalid JSON';
    }
  }

  String _getScenarioDescription(NetworkScenario scenario) {
    switch (scenario) {
      case NetworkScenario.success:
        return 'Works fine';
      case NetworkScenario.timeout:
        return 'Request takes 30s (will hang!)';
      case NetworkScenario.noInternet:
        return 'SocketException (will crash!)';
      case NetworkScenario.serverError:
        return 'Server returns 500 (will crash!)';
      case NetworkScenario.invalidJson:
        return 'Invalid JSON response (will crash!)';
    }
  }
}

// GOOD EXAMPLE: Proper error handling with timeout
class NetworkErrorGoodExample extends StatefulWidget {
  const NetworkErrorGoodExample({super.key});

  @override
  State<NetworkErrorGoodExample> createState() =>
      _NetworkErrorGoodExampleState();
}

class _NetworkErrorGoodExampleState extends State<NetworkErrorGoodExample> {
  String? _result;
  String? _error;
  bool _isLoading = false;
  NetworkScenario _selectedScenario = NetworkScenario.success;

  Future<void> _fetchDataGood() async {
    debugPrint('✅ [GOOD] Fetching data WITH proper error handling...');

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      // ✅ GOOD: Timeout prevents hanging forever
      final data = await _simulateNetworkCall(_selectedScenario)
          .timeout(const Duration(seconds: 5));

      debugPrint('✅ [GOOD] Got data successfully: $data');

      if (!mounted) return;

      setState(() {
        _result = data;
        _isLoading = false;
      });
    } on TimeoutException catch (e) {
      // ✅ GOOD: Specific handling for timeout
      debugPrint('✅ [GOOD] Caught TimeoutException: $e');
      _handleError('Request timed out. Please check your connection.');
    } on SocketException catch (e) {
      // ✅ GOOD: Specific handling for no internet
      debugPrint('✅ [GOOD] Caught SocketException: $e');
      _handleError('No internet connection. Please check your network.');
    } on HttpException catch (e) {
      // ✅ GOOD: Specific handling for server errors
      debugPrint('✅ [GOOD] Caught HttpException: $e');
      _handleError('Server error. Please try again later.');
    } on FormatException catch (e) {
      // ✅ GOOD: Specific handling for invalid JSON
      debugPrint('✅ [GOOD] Caught FormatException: $e');
      _handleError('Invalid response from server.');
    } catch (e) {
      // ✅ GOOD: Catch-all for unexpected errors
      debugPrint('✅ [GOOD] Caught unexpected error: $e');
      _handleError('Something went wrong: $e');
    }
  }

  void _handleError(String message) {
    debugPrint('✅ [GOOD] Showing user-friendly error: $message');
    if (!mounted) return;
    setState(() {
      _error = message;
      _isLoading = false;
    });
  }

  Future<String> _simulateNetworkCall(NetworkScenario scenario) async {
    switch (scenario) {
      case NetworkScenario.success:
        await Future.delayed(const Duration(seconds: 1));
        return '{"status": "success", "data": "Hello World"}';

      case NetworkScenario.timeout:
        debugPrint('✅ [GOOD] Simulating timeout - will be caught by timeout()!');
        await Future.delayed(const Duration(seconds: 30));
        throw TimeoutException('Request timed out');

      case NetworkScenario.noInternet:
        debugPrint('✅ [GOOD] Simulating no internet - will be caught!');
        throw const SocketException('No internet connection');

      case NetworkScenario.serverError:
        debugPrint('✅ [GOOD] Simulating server error - will be caught!');
        throw const HttpException('Server returned 500');

      case NetworkScenario.invalidJson:
        debugPrint('✅ [GOOD] Simulating invalid JSON - will be caught!');
        // This will throw FormatException when we try to parse it
        throw const FormatException('Invalid JSON');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Proper Error Handling'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'DevTools: Network Tab',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Verify: Open Network tab, trigger error, see error handled gracefully',
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
                  '✅ CORRECT: Proper error handling!\\n'
                  'Select any scenario - all errors are caught.\\n'
                  'User sees friendly error messages!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Scenario selector
            const Text(
              'Select Test Scenario:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildScenarioSelector(),
            const SizedBox(height: 24),

            // Fetch button
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchDataGood,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isLoading ? 'Loading...' : 'Fetch Data (With Error Handling!)'),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Will timeout after 5 seconds if needed'),
            ],

            if (_error != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Error:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_error!),
                    ],
                  ),
                ),
              ),
            ],

            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.green.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Success:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_result!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioSelector() {
    return Column(
      children: NetworkScenario.values.map((scenario) {
        return RadioListTile<NetworkScenario>(
          title: Text(_getScenarioName(scenario)),
          subtitle: Text(_getScenarioDescription(scenario)),
          value: scenario,
          groupValue: _selectedScenario,
          onChanged: (value) {
            setState(() {
              _selectedScenario = value!;
            });
          },
        );
      }).toList(),
    );
  }

  String _getScenarioName(NetworkScenario scenario) {
    switch (scenario) {
      case NetworkScenario.success:
        return '✅ Success';
      case NetworkScenario.timeout:
        return '⏱️ Timeout';
      case NetworkScenario.noInternet:
        return '📡 No Internet';
      case NetworkScenario.serverError:
        return '🔥 Server Error';
      case NetworkScenario.invalidJson:
        return '💥 Invalid JSON';
    }
  }

  String _getScenarioDescription(NetworkScenario scenario) {
    switch (scenario) {
      case NetworkScenario.success:
        return 'Works fine';
      case NetworkScenario.timeout:
        return 'Request takes 30s (caught by timeout!)';
      case NetworkScenario.noInternet:
        return 'SocketException (caught gracefully!)';
      case NetworkScenario.serverError:
        return 'Server returns 500 (caught gracefully!)';
      case NetworkScenario.invalidJson:
        return 'Invalid JSON response (caught gracefully!)';
    }
  }
}
