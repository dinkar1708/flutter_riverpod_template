import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        // initial route mange login, logout etc in splash page decided navigation
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SplashRoute.page, initial: true),
        // other pages routes
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: UsersRoute.page),
        AutoRoute(page: RepositoryListRoute.page),
        AutoRoute(page: CounterRoute.page),
        AutoRoute(page: NavigationRoute.page, children: [
          AutoRoute(page: NavigationChild1Route.page),
          AutoRoute(page: NavigationChild2Route.page),
        ]),
      ];
}
