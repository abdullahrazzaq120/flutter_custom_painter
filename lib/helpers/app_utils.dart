/*
 * Created by Abdullah Razzaq on 25/12/2024.
*/
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/mark.dart';
import 'dart:ui' as ui;

class AppUtils {
  static const double _markRadius = 20.0;

  static Offset getClosestPointForLine(Offset tap, Offset start, Offset end) {
    // Calculate the shortest distance from the tap to the line segment
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;

    // If the line is just a point
    if (dx == 0 && dy == 0) {
      return start;
    }

    // Calculate the parameter t
    double t = ((tap.dx - start.dx) * dx + (tap.dy - start.dy) * dy) /
        (dx * dx + dy * dy);

    // Clamp t to the range [0, 1]
    t = t.clamp(0.0, 1.0);

    // Find the closest point on the line segment
    Offset closestPoint = Offset(
      start.dx + t * dx,
      start.dy + t * dy,
    );

    // Check the distance from the tap to the closest point
    return closestPoint;
  }

  static Mark? getMarkIfExist(List<Mark> marks, Offset tapPosition) {
    try {
      final Mark focusedMark = marks.firstWhere((mark) {
        if (mark.type == 3) {
          final Offset closestPoint = AppUtils.getClosestPointForLine(
              tapPosition, mark.position, mark.endPosition!);
          return (tapPosition - closestPoint).distance <= _markRadius;
        }
        return isMarkPositionNear(mark.position, tapPosition);
      });

      return focusedMark;
    } catch (e) {
      return null;
    }
  }

  static bool isMarkPositionNear(Offset targetedPosition, Offset tapPosition) {
    return (targetedPosition - tapPosition).distance <= _markRadius;
  }

  static Future<ui.Image> getImageDimensions(String imageUrl) async {
    final Completer<ui.Image> completer = Completer();
    final NetworkImage networkImage = NetworkImage(imageUrl);

    networkImage.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    return completer.future;
  }

  static InputDecoration buildInputDecoration(
      {String? hint, required bool isTextField}) {
    return InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      suffixIcon: isTextField == true
          ? null
          : const Icon(
              Icons.expand_more,
              color: Colors.black45,
            ),
      filled: true,
      hintText: hint ?? '',
      hintStyle: const TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
    );
  }

  static void presentDatePicker(BuildContext context, DateTime? currentDate, Function(DateTime) onDatePicked) {
    showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value == null) return;
      onDatePicked(value); // update date
    });
  }

  static Future<void> presentTimePicker(BuildContext context, Function(TimeOfDay) onTimePicked) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select Time",
    );

    if (picked != null) {
      onTimePicked(picked);
    }
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat("h:mm a").format(dt);
  }
}
