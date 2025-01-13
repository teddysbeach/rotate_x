import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<Uint8List> toUint8List(GlobalKey imageKey) async {
  try {
    RenderRepaintBoundary? boundary =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return Uint8List(0);
    }

    await Future.delayed(Duration.zero);
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List() ?? Uint8List(0);
  } catch (e) {
    debugPrint('Error converting to Uint8List: $e');
    return Uint8List(0);
  }
}

Future<ui.Size?> getImageWidthHeight(Image image) async {
  Completer<ui.Image> completer = Completer<ui.Image>();
  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener(
        (ImageInfo info, bool _) => completer.complete(info.image),
      ));
  var result = await completer.future;
  return Size(result.width.toDouble(), result.height.toDouble());
}
