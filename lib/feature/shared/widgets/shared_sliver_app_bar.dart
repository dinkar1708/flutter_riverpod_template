import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedSliverAppBar extends StatelessWidget {
  const SharedSliverAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SliverAppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text(' User $title Repositories'),
      floating: true,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.light ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            brightness == Brightness.light ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
