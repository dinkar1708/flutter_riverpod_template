import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // initial route mange login, logout etc in splash page decided navigation
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SplashRoute.page, initial: true),
        // other pages routes
        AutoRoute(page: HomeWithTabsRoute.page, children: [
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: ExploreRoute.page),
          AutoRoute(page: ProfileRoute.page),
        ]),
        AutoRoute(page: UsersRoute.page),
        AutoRoute(page: RepositoryListRoute.page),
        AutoRoute(page: CounterRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: CommonWebviewRoute.page),
        AutoRoute(page: NavigationRoute.page, children: [
          AutoRoute(page: NavigationChild1Route.page),
          AutoRoute(page: NavigationChild2Route.page),
        ]),
      ];
}
