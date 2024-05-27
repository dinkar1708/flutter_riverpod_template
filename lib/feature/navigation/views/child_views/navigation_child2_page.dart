import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_app_bar.dart';

@RoutePage()
class NavigationChild2Page extends StatelessWidget {
  final String title;

  const NavigationChild2Page({
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
              'Child 2',
            ),
            Text(
              'Value',
              style: AppTextStyle.labelMedium
                  .copyWith(color: context.color.textPrimary),
            ),
            // it is not recommented to jump to same navigation page better push to new screen without navigation
            TextButton(
                onPressed: () => context.router
                    .push(NavigationRoute(title: 'Navigation Example')),
                child: const Text('Counter Example')),
          ],
        ),
      ),
    );
  }
}
