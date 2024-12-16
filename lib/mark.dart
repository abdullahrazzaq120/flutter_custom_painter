/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
import 'dart:ui';

import 'package:flutter/material.dart';

class Mark {
  final Offset position;
  final Offset? endPosition;
  final int type;
  bool isFocus;

  Mark({
    required this.position,
    this.endPosition,
    required this.type,
    this.isFocus = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'x': position.dx,
      'y': position.dy,
      'x1': endPosition?.dx,
      'y1': endPosition?.dy,
      'type': type,
      'isFocus': isFocus,
    };
  }

  // Create from JSON
  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      position: Offset(json['x'], json['y']),
      endPosition: Offset(json['x1'], json['y1']),
      type: json['type'] as int,
      isFocus: json['isFocus'] as bool,
    );
  }
}
