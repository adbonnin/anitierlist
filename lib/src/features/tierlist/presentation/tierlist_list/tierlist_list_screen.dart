import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/router/router.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TierListListScreen extends ConsumerWidget {
  const TierListListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTierLists = ref.watch(tierListsSnapshotsProvider);

    return AsyncValueWidget(
      asyncTierLists,
      data: (tierLists) => ListView.separated(
        itemCount: tierLists.length,
        separatorBuilder: (_, __) => Gaps.p4,
        itemBuilder: (_, index) => _buildItem(context, tierLists[index]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, TierList tierList) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(tierList.name),
        onTap: () => _onItemTap(context, tierList),
      ),
    );
  }

  void _onItemTap(BuildContext context, TierList tierList) {
    return TierListRouteData(tierList.id).go(context);
  }
}
