import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rotate_x/utils.dart';

/// A controller class that manages rotation state and operations for an image widget
class RotateXController {
  /// Global key to identify and access the image widget in the widget tree
  final GlobalKey imageKey = GlobalKey();

  /// Current rotation angle in degrees
  double _angle = 0.0;

  /// Callback function that gets triggered whenever the angle changes
  /// Allows parent widgets to react to rotation changes
  final void Function(double)? onAngleChanged;

  /// Creates a new RotateXController instance
  /// [onAngleChanged] - Optional callback for angle change notifications
  RotateXController({this.onAngleChanged});

  /// Gets the current rotation angle
  double get angle => _angle;

  /// Sets a new rotation angle and notifies listeners if any
  set angle(double newAngle) {
    _angle = newAngle;
    onAngleChanged?.call(_angle);
  }

  /// Captures the current state of the image widget and returns it as a Uint8List
  /// Useful for saving or exporting the rotated image
  Future<Uint8List> save() async => await toUint8List(imageKey);
}
