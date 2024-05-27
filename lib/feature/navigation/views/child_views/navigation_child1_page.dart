import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_app_bar.dart';

@RoutePage()
class NavigationChild1Page extends StatelessWidget {
  final String title;

  const NavigationChild1Page({
    required this.title,
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: SharedAppBar(title: title),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Child 1',
            ),
            Text(
              'Value',
              style: AppTextStyle.labelMedium
                  .copyWith(color: context.color.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
