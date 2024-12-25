/*
 * Created by Abdullah Razzaq on 25/12/2024.
*/
import 'dart:ui';

import 'mark.dart';

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

  static Mark? getMarkIfExist(List<Mark> marks , Offset tapPosition) {
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

}
