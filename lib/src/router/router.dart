import 'package:anitierlist/src/features/anime/presentation/anime_list/anime_list_screen.dart';
import 'package:anitierlist/src/features/characters/presentation/character_list/character_list_screen.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_list_screen.dart';
import 'package:anitierlist/src/router/app_scaffold.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _animeNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter router(RouterRef ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: '/anilist',
    debugLogDiagnostics: kDebugMode,
    observers: [
      BotToastNavigatorObserver(),
    ],
  );
}

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<AnimeBranchData>(
      routes: [
        TypedGoRoute<AnimeRouteData>(
          path: '/anilist',
        ),
      ],
    ),
    TypedStatefulShellBranch<CharactersBranchData>(
      routes: [
        TypedGoRoute<TierListsRouteData>(
          path: '/tierlists',
          routes: [
            TypedGoRoute<TierListRouteData>(
              path: ':id',
            ),
          ],
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return MainShellScaffold(
      navigationShell: navigationShell,
    );
  }
}

class AnimeBranchData extends StatefulShellBranchData {
  const AnimeBranchData();

  static final $navigatorKey = _animeNavigatorKey;
}

class CharactersBranchData extends StatefulShellBranchData {
  const CharactersBranchData();
}

class AnimeRouteData extends GoRouteData {
  const AnimeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AnimeListScreen();
  }
}

class TierListsRouteData extends GoRouteData {
  const TierListsRouteData();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: PageScaffold(
        body: (_) => TierListListScreen(
          key: state.pageKey,
        ),
      ),
    );
  }
}

class TierListRouteData extends GoRouteData {
  const TierListRouteData(this.id);

  final String id;

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: PageScaffold(
        body: (_) => TierListListScreen(
          key: state.pageKey,
          selectedId: id,
        ),
        secondaryBody: (_) => CharacterListScreen(tierListId: id),
      ),
    );
  }
}
