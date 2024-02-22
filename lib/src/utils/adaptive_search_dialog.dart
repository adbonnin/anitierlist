import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:anitierlist/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AdaptiveSearchDialog extends StatefulWidget {
  const AdaptiveSearchDialog({
    super.key,
    this.title,
    required this.onChanged,
    required this.content,
  });

  final Widget? title;
  final ValueChanged<String> onChanged;
  final Widget content;

  @override
  State<AdaptiveSearchDialog> createState() => _AdaptiveSearchDialogState();
}

class _AdaptiveSearchDialogState extends State<AdaptiveSearchDialog> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
    final searchIsEmpty = _controller.text.isEmpty;

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            focusNode: _focusNode,
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: searchIsEmpty
                  ? null
                  : IconButton(
                      onPressed: _onErasePressed,
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(Insets.p8, 0, Insets.p8, Insets.p8),
          child: widget.content,
        ),
      ),
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    final searchIsEmpty = _controller.text.isEmpty;

    return AlertDialog.adaptive(
      title: widget.title,
      content: SizedBox(
        width: Sizes.dialogMinWidth,
        height: Sizes.dialogMinHeight,
        child: Column(
          children: [
            TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchIsEmpty
                    ? null
                    : IconButton(
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
    _focusNode.requestFocus();
  }
}
