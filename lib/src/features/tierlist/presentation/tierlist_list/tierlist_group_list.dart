import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_card.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/loading_icon.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TierListGroupList extends StatefulWidget {
  const TierListGroupList({
    super.key,
    required this.tierLists,
    this.otherActions = const [],
    required this.isLoading,
    required this.onTierListTap,
    this.toGroupLabel,
    this.onExportPressed,
    this.onSharePressed,
  });

  final Iterable<TierList> tierLists;
  final Iterable<Widget> otherActions;
  final bool isLoading;
  final void Function(TierList tierList) onTierListTap;
  final String Function(String group)? toGroupLabel;
  final VoidCallback? onExportPressed;
  final VoidCallback? onSharePressed;

  @override
  State<TierListGroupList> createState() => TierListGroupListState();
}

class TierListGroupListState extends State<TierListGroupList> {
  late List<ScreenshotController> _screenshotControllers;

  @override
  void initState() {
    super.initState();
    _screenshotControllers = List.generate(widget.tierLists.length, (_) => ScreenshotController());
  }

  @override
  void didUpdateWidget(TierListGroupList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tierLists.length != oldWidget.tierLists.length) {
      _screenshotControllers = List.generate(widget.tierLists.length, (_) => ScreenshotController());
    }
  }

  @override
  void dispose() {
    _screenshotControllers = [];
    super.dispose();
  }

  Map<String?, List<(TierList, ScreenshotController)>> buildTierListScreenshotsByFormat() {
    return widget.tierLists //
        .mapIndexed((i, a) => (a, _screenshotControllers[i]))
        .groupListsBy((element) => element.$1.group);
  }

  @override
  Widget build(BuildContext context) {
    final canExport = widget.isLoading || widget.tierLists.isEmpty;

    final animeScreenshotsByFormat = buildTierListScreenshotsByFormat();

    final tierListGroups = animeScreenshotsByFormat.entries //
        .where((etr) => etr.value.isNotEmpty)
        .map((etr) => _build(etr.key, etr.value))
        .toList();

    final actions = [
      IconButton(
        onPressed: canExport ? null : widget.onExportPressed,
        icon: LoadingIcon(Icons.file_download, loading: widget.isLoading),
        tooltip: widget.isLoading //
            ? context.loc.anime_tierlist_savingThumbnails
            : context.loc.anime_tierlist_saveThumbnails,
      ),
      IconButton(
        onPressed: canExport ? null : widget.onSharePressed,
        icon: LoadingIcon(Icons.share, loading: widget.isLoading),
        tooltip: widget.isLoading //
            ? context.loc.anime_tierlist_sharingThumbnails
            : context.loc.anime_tierlist_shareThumbnails,
      ),
      ...widget.otherActions,
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.p8, Insets.p4, Insets.p8, Insets.p4),
            child: Row(
              children: actions,
            ),
          ),
          const Divider(height: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.p16, 0, Insets.p16, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final tierListGroup in tierListGroups) ...[
                      Gaps.p18,
                      tierListGroup,
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(String? group, List<(TierList, ScreenshotController)> tierListScreenshots) {
    final toGroupLabel = widget.toGroupLabel;
    final groupLabel = (toGroupLabel == null || group == null) ? group : toGroupLabel(group);

    return TierListGroup(
      labelText: groupLabel,
      children: [
        for (final tierListScreenshot in tierListScreenshots)
          Screenshot(
            controller: tierListScreenshot.$2,
            child: TierListCard(
              tierList: tierListScreenshot.$1,
              onTap: () => widget.onTierListTap(tierListScreenshot.$1),
            ),
          )
      ],
    );
  }
}
