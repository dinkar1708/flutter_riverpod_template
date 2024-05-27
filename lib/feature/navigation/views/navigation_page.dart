import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod_template/feature/navigation/views/navigation_tabs/navigation_tabs_view.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';

@RoutePage()
class NavigationPage extends HookWidget {
  final String title;

  const NavigationPage({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        NavigationChild1Route(
          title: "NavigationChild1Route",
        ),
        NavigationChild2Route(
          title: 'NavigationChild2Route',
        ),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationTabsView(tabsRouter);
      },
    );
  }
}
