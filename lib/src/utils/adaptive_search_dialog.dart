import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AdaptiveSearchDialog extends StatefulWidget {
  const AdaptiveSearchDialog({
    super.key,
    this.title,
    required this.onChanged,
    required this.focusNode,
    required this.content,
  });

  final Widget? title;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final Widget content;

  @override
  State<AdaptiveSearchDialog> createState() => _AdaptiveSearchDialogState();
}

class _AdaptiveSearchDialogState extends State<AdaptiveSearchDialog> {
  late final FocusNode focusNode;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    focusNode = widget.focusNode;
    focusNode.requestFocus();

    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      body: SlotLayout(
        config: {
          Breakpoints.standard: SlotLayout.from(
            key: const Key('body'),
            builder: _buildAlertDialog,
          ),
          Breakpoints.small: SlotLayout.from(
            key: const Key('smallBody'),
            builder: _buildFullscreenDialog,
          ),
        },
      ),
    );
  }

  Widget _buildFullscreenDialog(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            focusNode: widget.focusNode,
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: _onErasePressed,
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.p8),
          child: widget.content,
        ),
      ),
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog.adaptive(
      title: widget.title,
      content: SizedBox(
        width: Sizes.dialogMinWidth,
        height: Sizes.dialogMinHeight,
        child: Column(
          children: [
            TextField(
              focusNode: widget.focusNode,
              controller: _controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _onErasePressed,
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            Gaps.p8,
            Expanded(
              child: widget.content,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: _onClosePressed,
          child: Text(context.loc.common_close),
        ),
      ],
    );
  }

  void _handleChange() {
    widget.onChanged(_controller.text);
  }

  void _onClosePressed() {
    Navigator.pop(context);
  }

  void _onErasePressed() {
    _controller.text = '';
    widget.focusNode.requestFocus();
  }
}
