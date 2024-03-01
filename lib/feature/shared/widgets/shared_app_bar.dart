import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.mint2,
      title: Text(title),
    );
  }
}
