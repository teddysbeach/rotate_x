import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rotate_x/utils.dart';
import 'package:rotate_x/src/rotate_x_controller.dart';

/// A widget that provides image rotation functionality with optional scale adjustment
///
/// Features:
/// - Smooth image rotation with angle control
/// - Optional scale adjustment during rotation to maintain visibility
/// - Built-in controller for external rotation control
/// - Image capture/export capability
class RotateX extends StatefulWidget {
  /// The image to be rotated
  final Image image;

  /// Whether the image should scale to maintain visibility during rotation
  final bool scaleFollowsRotation;

  /// Optional controller to manage rotation state externally
  final RotateXController? controller;

  const RotateX({
    super.key,
    required this.image,
    this.scaleFollowsRotation = false,
    this.controller,
  });

  @override
  State<RotateX> createState() => _RotateXState();
}

class _RotateXState extends State<RotateX> {
  Size? _originalSize;
  late final RotateXController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? RotateXController();
    _loadImageDimensions();
  }

  Future<void> _loadImageDimensions() async {
    final size = await getImageWidthHeight(widget.image);
    if (mounted) {
      setState(() => _originalSize = size);
    }
  }

  /// Calculates dimensions and scale factor for the rotated image
  (Size rotatedSize, double scaleFactor) _calculateRotatedDimensions() {
    final angle = _controller.angle;
    final originalWidth = _originalSize!.width;
    final originalHeight = _originalSize!.height;

    final cosAngle = cos(angle).abs();
    final sinAngle = sin(angle).abs();

    final rotatedWidth = originalWidth * cosAngle + originalHeight * sinAngle;
    final rotatedHeight = originalWidth * sinAngle + originalHeight * cosAngle;

    final scaleFactor = max(
      rotatedWidth / originalWidth,
      rotatedHeight / originalHeight,
    );

    return (Size(rotatedWidth, rotatedHeight), scaleFactor);
  }

  @override
  Widget build(BuildContext context) {
    if (_originalSize == null) {
      return const SizedBox.shrink();
    }

    final (_, scaleFactor) = _calculateRotatedDimensions();

    return RepaintBoundary(
      key: _controller.imageKey,
      child: ClipRRect(
        child: Transform.scale(
          scale: widget.scaleFollowsRotation ? scaleFactor : 1.0,
          child: Transform.rotate(
            angle: _controller.angle,
            child: widget.image,
          ),
        ),
      ),
    );
  }
}
