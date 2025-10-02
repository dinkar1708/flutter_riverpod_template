import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    // Navigate to the next screen after a delay
    Timer(
      const Duration(milliseconds: 1600),
      () => context.router.replace(LoginRoute(title: "Login")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // Loop through a few pleasing colors
          final top = _sequenceLerp(t, const [
            Color(0xFF667eea), // blue
            Color(0xFF764ba2), // purple
            Color(0xFFf093fb), // pink
            Color(0xFF67e8f9), // aqua
          ]);
          final bottom = _sequenceLerp((t + 0.33) % 1.0, const [
            Color(0xFFa0c4ff),
            Color(0xFFb8c0ff),
            Color(0xFFcdb4db),
            Color(0xFF99f6e4),
          ]);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [top, bottom],
                  ),
                ),
              ),
              // Floating icons with subtle motion
              _AnimatedIconBurst(controller: _controller),
              // Center logo mark
              Center(
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
                  ),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.flutter_dash,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _sequenceLerp(double t, List<Color> colors) {
    final seg = 1 / colors.length;
    final i = (t ~/ seg).clamp(0, colors.length - 1);
    final j = (i + 1) % colors.length;
    final localT = (t - i * seg) / seg;
    return Color.lerp(
      colors[i],
      colors[j],
      localT,
    )!.withValues(alpha: 1.0); // ensure opaque
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimatedIconBurst extends StatelessWidget {
  const _AnimatedIconBurst({required this.controller});
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return Stack(
          children: [
            _floatingIcon(
              alignment: Alignment(
                _lerp(-0.8, 0.8, (t + 0.10) % 1.0),
                _lerp(-0.9, -0.3, (t + 0.25) % 1.0),
              ),
              icon: Icons.bolt_rounded,
            ),
            _floatingIcon(
              alignment: Alignment(
                _lerp(-0.6, 0.7, (t + 0.45) % 1.0),
                _lerp(0.2, -0.6, (t + 0.70) % 1.0),
              ),
              icon: Icons.star_rounded,
            ),
            _floatingIcon(
              alignment: Alignment(
                _lerp(0.9, -0.8, (t + 0.75) % 1.0),
                _lerp(0.7, -0.1, (t + 0.15) % 1.0),
              ),
              icon: Icons.favorite_rounded,
            ),
          ],
        );
      },
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  Widget _floatingIcon({required Alignment alignment, required IconData icon}) {
    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: 0.5,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
