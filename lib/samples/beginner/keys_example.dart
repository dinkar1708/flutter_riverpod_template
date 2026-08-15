import 'package:flutter/material.dart';

class KeysExample extends StatefulWidget {
  const KeysExample({super.key});

  @override
  State<KeysExample> createState() => _KeysExampleState();
}

class _KeysExampleState extends State<KeysExample> {
  List<Item> items = [
    Item('Item 1', Colors.blue),
    Item('Item 2', Colors.green),
    Item('Item 3', Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keys Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keys preserve widget state during rebuilds',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap items to change their color, then shuffle to see keys maintain state',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ReorderableListView(
                onReorderStart: (index) {
                  debugPrint('🔄 Started reordering item at index $index');
                },
                onReorderEnd: (index) {
                  debugPrint('✅ Finished reordering');
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    debugPrint('🔄 Reordering from $oldIndex to $newIndex');
                    if (newIndex > oldIndex) {
                      newIndex--;
                    }
                    final movedItem = items.removeAt(oldIndex);
                    items.insert(newIndex, movedItem);
                  });
                },
                children: items.map((item) {
                  return Card(
                    key: ValueKey(item.name),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: StatefulColorTile(
                      key: ValueKey('tile_${item.name}'),
                      item: item,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    items.shuffle();
                  });
                },
                icon: const Icon(Icons.shuffle),
                label: const Text('Shuffle Items'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatefulColorTile extends StatefulWidget {
  const StatefulColorTile({
    required this.item,
    super.key,
  });
  final Item item;

  @override
  State<StatefulColorTile> createState() => _StatefulColorTileState();
}

class _StatefulColorTileState extends State<StatefulColorTile> {
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = widget.item.color;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(widget.item.name),
      subtitle: const Text('Tap to change color'),
      trailing: const Icon(Icons.drag_handle),
      onTap: () {
        setState(() {
          currentColor = currentColor == widget.item.color
              ? Colors.red
              : widget.item.color;
        });
      },
    );
  }
}

class Item {
  Item(this.name, this.color);
  final String name;
  final Color color;
}
