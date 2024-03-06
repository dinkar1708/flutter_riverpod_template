import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class NavigationTabsView extends StatelessWidget {
  final TabsRouter tabsRouter;

  const NavigationTabsView(this.tabsRouter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: tabsRouter.activeIndex,
      onTap: (index) {
        tabsRouter.setActiveIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.ac_unit_sharp),
          label: 'Child1',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_sharp),
          label: 'child2',
        ),
      ],
    );
  }
}
