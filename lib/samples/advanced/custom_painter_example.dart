import 'dart:math';
import 'package:flutter/material.dart';

class CustomPainterExample extends StatefulWidget {
  const CustomPainterExample({super.key});

  @override
  State<CustomPainterExample> createState() => _CustomPainterExampleState();
}

class _CustomPainterExampleState extends State<CustomPainterExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Custom Canvas Drawing with Paint',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'AnimatedBuilder + CustomPainter for smooth animations',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return RepaintBoundary(
                    child: CustomPaint(
                      size: const Size(double.infinity, double.infinity),
                      painter: WavePainter(
                        progress: _controller.value,
                        primaryColor: Theme.of(context).colorScheme.primary,
                        secondaryColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.stop();
                } else {
                  _controller.repeat();
                }
                setState(() {});
              },
              icon: Icon(_controller.isAnimating ? Icons.pause : Icons.play_arrow),
              label: Text(_controller.isAnimating ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  WavePainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = primaryColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = secondaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    final path2 = Path();

    // First wave
    path1.moveTo(0, size.height * 0.5);
    for (double i = 0; i <= size.width; i++) {
      path1.lineTo(
        i,
        size.height * 0.5 +
            sin((i / size.width * 4 * pi) + (progress * 2 * pi)) * 30,
      );
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    // Second wave
    path2.moveTo(0, size.height * 0.6);
    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height * 0.6 +
            cos((i / size.width * 3 * pi) + (progress * 2 * pi)) * 40,
      );
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);

    // Draw circles
    final circlePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i + (progress * 50) % 50;
      final y = size.height * 0.3 +
          sin((progress * 2 * pi) + (i * pi / 2)) * 20;
      canvas.drawCircle(
        Offset(x, y),
        8,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
