import 'package:anitierlist/src/features/tierlist/application/tierlist_providers.dart';
import 'package:anitierlist/src/features/tierlist/application/tierlist_service.dart';
import 'package:anitierlist/src/features/tierlist/domain/tierlist.dart';
import 'package:anitierlist/src/features/tierlist/presentation/tierlist_edit/tierlist_edit_dialog.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/src/router/router.dart';
import 'package:anitierlist/src/widgets/async_value_widget.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TierListListScreen extends ConsumerStatefulWidget {
  const TierListListScreen({
    super.key,
    this.selectedId,
  });

  final String? selectedId;

  @override
  ConsumerState<TierListListScreen> createState() => _TierListListScreenState();
}

class _TierListListScreenState extends ConsumerState<TierListListScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncTierLists = ref.watch(tierListsSnapshotsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FloatingActionButton.extended(
          elevation: 0,
          onPressed: _onCreateTierListPressed,
          label: Text(context.loc.tierlist_createButton),
          icon: const Icon(Icons.add),
        ),
        Gaps.p16,
        Expanded(
          child: AsyncValueWidget(
            asyncTierLists,
            data: (tierLists) => ListView.separated(
              itemCount: tierLists.length,
              separatorBuilder: (_, __) => Gaps.p4,
              itemBuilder: (context, index) => _buildItem(context, tierLists[index]),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onCreateTierListPressed() async {
    final service = ref.read(tierListServiceProvider);
    final tierList = await showTierListEditDialog(context: context);

    if (tierList == null) {
      return;
    }

    final id = await service.createTierList(tierList);

    if (mounted) {
      TierListRouteData(id).go(context);
    }
  }

  Widget _buildItem(BuildContext context, TierList tierList) {
    return Card(
      child: ListTile(
        selected: tierList.id == widget.selectedId,
        onTap: () => _onItemTap(context, tierList),
        title: Text(tierList.name),
      ),
    );
  }

  void _onItemTap(BuildContext context, TierList tierList) {
    return TierListRouteData(tierList.id).go(context);
  }
}
