import 'dart:io';

import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tier_item_card.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_list/tierlist_group_title.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/widgets/loading_icon.dart';
import 'package:anitierlist/src/widgets/screenshot.dart';
import 'package:anitierlist/styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TierListGroupList extends StatefulWidget {
  const TierListGroupList({
    super.key,
    required this.items,
    this.otherActions = const [],
    this.emptyBuilder,
    required this.isLoading,
    required this.onItemTap,
    this.groupTitleBuilder,
    this.onExportPressed,
    this.onSharePressed,
  });

  final Iterable<TierListItem> items;
  final Iterable<Widget> otherActions;
  final WidgetBuilder? emptyBuilder;
  final bool isLoading;
  final void Function(TierListItem item) onItemTap;
  final Widget Function(BuildContext context, String group)? groupTitleBuilder;
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
    _screenshotControllers = List.generate(widget.items.length, (_) => ScreenshotController());
  }

  @override
  void didUpdateWidget(TierListGroupList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length != oldWidget.items.length) {
      _screenshotControllers = List.generate(widget.items.length, (_) => ScreenshotController());
    }
  }

  @override
  void dispose() {
    _screenshotControllers = [];
    super.dispose();
  }

  Map<String?, List<(TierListItem, ScreenshotController)>> buildTierListScreenshotsByFormat() {
    return widget.items //
        .mapIndexed((i, a) => (a, _screenshotControllers[i]))
        .groupListsBy((element) => element.$1.group);
  }

  @override
  Widget build(BuildContext context) {
    final canExport = widget.isLoading || widget.items.isEmpty;

    final animeScreenshotsByFormat = buildTierListScreenshotsByFormat();

    final tierListGroups = animeScreenshotsByFormat.entries //
        .where((etr) => etr.value.isNotEmpty)
        .map((etr) => _buildGroup(etr.key, etr.value));

    final actions = [
      IconButton(
        onPressed: canExport ? null : widget.onExportPressed,
        icon: LoadingIcon(Icons.file_download, loading: widget.isLoading),
        tooltip: widget.isLoading //
            ? context.loc.anime_tierlist_savingThumbnails
            : context.loc.anime_tierlist_saveThumbnails,
      ),
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid))
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
            padding: const EdgeInsets.symmetric(vertical: Insets.p4, horizontal: Insets.p8),
            child: Row(
              children: actions,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: tierListGroups.isEmpty
                ? widget.emptyBuilder?.call(context) ?? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.p16),
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

  Widget _buildGroup(String? group, List<(TierListItem, ScreenshotController)> tierListScreenshots) {
    final groupTitleBuilder = widget.groupTitleBuilder;
    final groupTitle = group == null ? null : (groupTitleBuilder ?? _buildDefaultGroupTitle)(context, group);

    return TierListGroup(
      title: groupTitle,
      children: [
        for (final tierListScreenshot in tierListScreenshots) //
          _buildItem(tierListScreenshot.$1, tierListScreenshot.$2)
      ],
    );
  }

  Widget _buildDefaultGroupTitle(BuildContext context, String group) {
    return TierListGroupTitle(
      titleText: group,
    );
  }

  Widget _buildItem(TierListItem tierList, ScreenshotController controller) {
    return Screenshot(
      controller: controller,
      child: InkWell(
        onTap: () => widget.onItemTap(tierList),
        child: TierItemCard(
          item: tierList,
        ),
      ),
    );
  }
}
