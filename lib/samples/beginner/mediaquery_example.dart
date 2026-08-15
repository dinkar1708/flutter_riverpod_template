import 'package:flutter/material.dart';

class MediaQueryExample extends StatelessWidget {
  const MediaQueryExample({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final orientation = MediaQuery.orientationOf(context);
    final brightness = MediaQuery.platformBrightnessOf(context);

    String getDeviceType(double width) {
      if (width < 600) return 'Phone';
      if (width < 900) return 'Tablet';
      return 'Desktop';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('MediaQuery Example')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'MediaQuery provides device information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            context,
            icon: Icons.devices,
            title: 'Device Type',
            value: getDeviceType(size.width),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.straighten,
            title: 'Screen Width',
            value: '${size.width.toStringAsFixed(0)} px',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.height,
            title: 'Screen Height',
            value: '${size.height.toStringAsFixed(0)} px',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.screen_rotation,
            title: 'Orientation',
            value: orientation == Orientation.portrait
                ? 'Portrait'
                : 'Landscape',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.brightness_6,
            title: 'Brightness',
            value: brightness == Brightness.light ? 'Light' : 'Dark',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.padding,
            title: 'Safe Area Padding',
            value:
                'Top: ${padding.top.toInt()}, Bottom: ${padding.bottom.toInt()}',
          ),
          const SizedBox(height: 24),
          Text(
            'Responsive Layout Demo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (size.width < 600)
            _buildMobileLayout()
          else if (size.width < 900)
            _buildTabletLayout()
          else
            _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(value,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.phone_android, size: 48),
            SizedBox(height: 8),
            Text('Mobile Layout'),
            Text('Single column design'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.tablet_mac, size: 48),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tablet Layout'),
                Text('Two column design'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.desktop_windows, size: 64),
            Column(
              children: [
                Text('Desktop Layout'),
                Text('Multi-column grid design'),
              ],
            ),
            Icon(Icons.view_module, size: 48),
          ],
        ),
      ),
    );
  }
}
