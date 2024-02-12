import 'dart:ui' as ui;

extension ImageExtension on ui.Image {
  toByteArray() async {
    final byteData = await toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
