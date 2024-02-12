import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Screenshot extends StatelessWidget {
  const Screenshot({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScreenshotController controller;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller._containerKey,
      child: child,
    );
  }
}

class ScreenshotController {
  final _containerKey = GlobalKey();

  Future<ui.Image?> capture() {
    final renderObject = _containerKey.currentContext?.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      return Future.value(null);
    }

    return renderObject.toImage(pixelRatio: 1);
  }
}
