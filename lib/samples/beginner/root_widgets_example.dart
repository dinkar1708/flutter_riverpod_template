import 'package:flutter/material.dart';

class RootWidgetsExample extends StatelessWidget {
  const RootWidgetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Root/Wrapper Widgets')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Common Root/Wrapper Widgets:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('1. Scaffold - Basic app structure'),
            SizedBox(height: 8),
            Text('2. SafeArea - Avoid notches/system UI'),
            SizedBox(height: 8),
            Text('3. MaterialApp - Root app configuration'),
            SizedBox(height: 8),
            Text('4. Padding - Add spacing around widgets'),
            SizedBox(height: 8),
            Text('5. Center - Center child widget'),
            SizedBox(height: 8),
            Text('6. Container - Combine decoration + sizing'),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text(
              'See documentation for detailed explanations and examples',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
