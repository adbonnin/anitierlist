import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareZipFile(String name, Uint8List bytes) async {
  final file = XFile(
    '$name.zip',
    bytes: bytes,
  );

  await Share.shareXFiles([file]);
}

Future<void> saveZipFile(String name, Uint8List bytes) async {
  const ext = '.zip';
  const mimeType = MimeType.zip;

  if (bytes.isEmpty) {
    return;
  } //
  else if (kIsWeb) {
    await FileSaver.instance.saveFile(
      name: name,
      bytes: bytes,
      ext: ext,
      mimeType: mimeType,
    );
  } //
  else {
    final filePath = await FileSaver.instance.saveAs(
      name: name,
      bytes: bytes,
      ext: ext,
      mimeType: mimeType,
    );

    if (filePath != null) {
      await File(filePath).writeAsBytes(bytes);
    }
  }
}
