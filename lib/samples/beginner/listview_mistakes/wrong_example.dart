import 'package:flutter/material.dart';

/// WRONG: ListView without Expanded (using shrinkWrap workaround)
class ListViewWrongExample extends StatelessWidget {
  const ListViewWrongExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WRONG: No Height Constraint'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Card
            Card(
              color: Colors.red.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Problem',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('ListView in Column without height constraint causes crash'),
                    SizedBox(height: 8),
                    Text(
                      'Using shrinkWrap to avoid crash (bad for performance!)',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Live Demo (WRONG):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // WRONG Implementation
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        border: Border(
                          bottom: BorderSide(color: Colors.red),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Header - Fixed',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // ❌ WRONG: Using shrinkWrap (bad for performance!)
                    ListView.builder(
                      shrinkWrap: true, // ⚠️ Creates all items at once!
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5, // Only 5 items - all rendered immediately
                      itemBuilder: (context, index) {
                        debugPrint('❌ [WRONG] Creating item $index immediately');
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Item ${index + 1}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'No scroll - shrinkWrap',
                                      style: TextStyle(fontSize: 12, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border(
                          top: BorderSide(color: Colors.red),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'All 5 items created at once! Bad for large lists!',
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
