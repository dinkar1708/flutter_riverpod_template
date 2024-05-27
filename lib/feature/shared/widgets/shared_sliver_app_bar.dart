import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';

class SharedSliverAppBar extends StatelessWidget {
  const SharedSliverAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.color.backgroundPrimary, // background color
      foregroundColor: context.color.textPrimary, // text color
      title: Text(' User $title Repositories'),
      floating: true,
    );
  }
}
