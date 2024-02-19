import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_card.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/utils/iterable_extensions.dart';
import 'package:anitierlist/src/widgets/loading_icon.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TierListGroupList extends StatefulWidget {
  const TierListGroupList({
    super.key,
    required this.tierLists,
    required this.exporting,
    required this.onTierListTap,
    this.toGroupLabel,
    required this.onExportPressed,
  });

  final Iterable<TierList> tierLists;
  final bool exporting;
  final void Function(TierList tierList) onTierListTap;
  final String Function(String group)? toGroupLabel;
  final VoidCallback onExportPressed;

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
    final animeScreenshotsByFormat = buildTierListScreenshotsByFormat();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Insets.p16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: animeScreenshotsByFormat.entries //
                      .where((etr) => etr.value.isNotEmpty)
                      .map((etr) => _build(etr.key, etr.value))
                      .intersperse((_, __) => Gaps.p18)
                      .toList(),
                ),
              ),
            ),
            Gaps.p12,
            Row(
              children: [
                FilledButton.icon(
                  onPressed: (widget.exporting || widget.tierLists.isEmpty) ? null : widget.onExportPressed,
                  icon: LoadingIcon(Icons.file_download, loading: widget.exporting),
                  label: Text(widget.exporting //
                      ? context.loc.anime_tierlist_exportingThumbnails
                      : context.loc.anime_tierlist_exportThumbnails),
                ),
              ],
            ),
          ],
        ),
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
