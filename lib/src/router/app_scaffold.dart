import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.body,
    this.secondaryBody,
    this.emptySecondaryBody,
  });

  final WidgetBuilder body;
  final WidgetBuilder? secondaryBody;
  final WidgetBuilder? emptySecondaryBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        return AdaptiveLayout(
          bodyRatio: 239 / width,
          internalAnimations: false,
          body: SlotLayout(
            config: {
              Breakpoints.small: SlotLayout.from(
                key: const Key('smallBody'),
                builder: secondaryBody ?? body,
              ),
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('mediumBody'),
                builder: body,
              ),
            },
          ),
          secondaryBody: SlotLayout(
            config: {
              Breakpoints.small: SlotLayout.from(
                key: const Key('smallBody'),
                builder: null,
              ),
              Breakpoints.mediumAndUp: SlotLayout.from(
                key: const Key('mediumBody'),
                builder: secondaryBody ?? emptySecondaryBody,
              ),
            },
          ),
        );
      },
    );
  }
}

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return AdaptiveScaffold(
      internalAnimations: false,
      selectedIndex: currentIndex,
      onSelectedIndexChange: _onSelectedIndexChange,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.collections_outlined),
          selectedIcon: const Icon(Icons.collections),
          label: context.loc.anilist_title,
        ),
        NavigationDestination(
          icon: const Icon(Icons.switch_account_outlined),
          selectedIcon: const Icon(Icons.switch_account),
          label: context.loc.tierlist_title,
        ),
      ],
      body: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Insets.p8),
          child: navigationShell,
        ),
      ),
      useDrawer: false,
    );
  }

  void _onSelectedIndexChange(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
