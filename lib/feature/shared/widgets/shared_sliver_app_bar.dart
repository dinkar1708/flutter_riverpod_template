import 'package:flutter/material.dart';

class SharedSliverAppBar extends StatelessWidget {
  const SharedSliverAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(' User $title Repositories'),
      floating: true,
    );
  }
}
