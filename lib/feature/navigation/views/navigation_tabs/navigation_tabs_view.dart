import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class NavigationTabsView extends StatelessWidget {
  final TabsRouter tabsRouter;

  const NavigationTabsView(this.tabsRouter, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: (index) {
        tabsRouter.setActiveIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
