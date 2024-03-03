import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/counter/counter_page.dart';
import 'package:flutter_riverpod_template/feature/home_page.dart';
import 'package:flutter_riverpod_template/feature/repository_list/splash/splash_page.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // initial route mange login, logout etc in splash page decided navigation
        AutoRoute(page: SplashRoute.page, initial: true),
        // other pages routes
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: RepositoryListRoute.page),
        AutoRoute(page: CounterRoute.page)
      ];
}
