import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

class MainShellScaffold extends StatelessWidget {
  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: AdaptiveScaffold(
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
            label: context.loc.characters_title,
          ),
        ],
        body: (_) => Padding(
          padding: const EdgeInsets.all(Insets.p16),
          child: navigationShell,
        ),
        useDrawer: false,
      ),
    );
  }

  void _onSelectedIndexChange(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }
}
