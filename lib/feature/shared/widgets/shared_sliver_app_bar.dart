import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';

class SharedSliverAppBar extends StatelessWidget {
  const SharedSliverAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.color.divider,
      title: Text(' User $title Repositories'),
      floating: true,
    );
  }
}
