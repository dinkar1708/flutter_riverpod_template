import 'package:flutter/material.dart';

class SharedSliverAppBar extends StatelessWidget {
  const SharedSliverAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      title: Text(' User $title Repositories'),
      floating: true,
      actions: actions,
    );
  }
}
