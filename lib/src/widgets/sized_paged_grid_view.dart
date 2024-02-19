import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SizedPagedGridView<PageKeyType, ItemType> extends StatelessWidget {
  const SizedPagedGridView({
    super.key,
    required this.itemBuilder,
    required this.itemWidth,
    required this.itemHeight,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.pagingController,
  });

  final ItemWidgetBuilder<ItemType> itemBuilder;
  final double itemWidth;
  final double itemHeight;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final PagingController<PageKeyType, ItemType> pagingController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth + crossAxisSpacing;
      final crossAxisCount = width ~/ itemWidth;

      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: (width * crossAxisCount).floor().toDouble(),
          child: PagedGridView(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(itemBuilder: _buildItem),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              crossAxisCount: crossAxisCount,
              mainAxisExtent: itemHeight,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildItem(BuildContext context, ItemType item, int index) {
    return SizedBox(
      width: itemWidth,
      height: itemHeight,
      child: itemBuilder(context, item, index),
    );
  }
}
