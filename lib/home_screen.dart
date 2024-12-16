/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
import 'dart:convert';

import 'package:flutter/material.dart';

import 'mark.dart';
import 'mark_painter.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Mark> marks = [];
  int type = 0;
  final double _markRadius = 10.0;

  Offset? _startPoint; // Starting point of the current line
  Offset? _currentPoint; // Current point during drawing a line

  void _addMark(Offset position) {
    setState(() {
      if (type == 3) {
        _startPoint = position; // Set the starting point
        _currentPoint = position; // Initialize curre|nt point
      } else {
        marks.add(Mark(position: position, type: type)); // Add new mark
      }
    });
  }

  void _removeMark(Offset tapPosition) {
    setState(() {
      // Find the mark or line within a certain radius and remove it
      marks.removeWhere((mark) {
        if (mark.type == 3) {
          // Line marks: check proximity to closest point on the line
          final Offset closestPoint = _getClosestPointForLine(
              tapPosition, mark.position, mark.endPosition!);
          return (tapPosition - closestPoint).distance <= _markRadius;
        }

        // Other marks: check proximity to the center
        return (mark.position - tapPosition).distance <= _markRadius;
      });
    });
  }

  void _setFocus(Offset tapPosition) {
    setState(() {
      for (var mark in marks) {
        mark.isFocus = false; // Reset focus for all marks
      }

      try {
        final Mark focusedMark = marks.firstWhere((mark) {
          if (mark.type == 3) {
            final Offset closestPoint = _getClosestPointForLine(
                tapPosition, mark.position, mark.endPosition!);
            return (tapPosition - closestPoint).distance <= _markRadius;
          }
          return (mark.position - tapPosition).distance <= _markRadius;
        });

        focusedMark.isFocus = true;
        print(json.encode(focusedMark));
        
      } catch (e) {
        // No mark found within the proximity
      }
    });
  }

  Offset _getClosestPointForLine(Offset tap, Offset start, Offset end) {
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

  void _updateLine(Offset currentPoint) {
    setState(() {
      _currentPoint = currentPoint; // Update the current point as user drags
    });
  }

  void _endLine(Offset endPoint) {
    if (_startPoint != null) {
      setState(() {
        marks.add(
            Mark(position: _startPoint!, endPosition: endPoint, type: type));

        for (final m in marks) {
          print("Marks saved: ${m.toJson()}");
        }
        _startPoint = null; // Reset start point
        _currentPoint = null; // Reset current point
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Custom Marks'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              // delete marks
              setState(() {
                marks = [];
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save marks
              for (final m in marks) {
                print("Marks saved: ${m.toJson()}");
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 9,
            child: GestureDetector(
              onPanDown: (details) {
                if (type == 4) {
                  _removeMark(details.localPosition);
                  return;
                }
                if (type == 5) {
                  _setFocus(details.localPosition);
                  return;
                }

                _addMark(details.localPosition); // Add mark on touch
              },
              onPanUpdate: type == 3
                  ? (details) {
                      _updateLine(details
                          .localPosition); // Update the line as user drags
                    }
                  : null,
              onPanEnd: type == 3
                  ? (details) {
                      if (_currentPoint != null) {
                        _endLine(_currentPoint!); // Finish the line
                      }
                    }
                  : null,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/car_interior.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  CustomPaint(
                    size: Size.infinite,
                    painter: MarkPainter(marks: marks),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              height: MediaQuery.of(context).size.height / 2.2,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  markIcon(
                    selectedType: 0,
                    child: const Icon(
                      Icons.circle,
                      color: Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(),
                  markIcon(
                    selectedType: 1,
                    child: const Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(),
                  markIcon(
                    selectedType: 2,
                    child: const Icon(
                      Icons.close_sharp,
                      color: Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(),
                  markIcon(
                    selectedType: 3,
                    child: const Divider(
                      thickness: 4,
                      endIndent: 4,
                      indent: 4,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  markIcon(
                    selectedType: 4,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(),
                  markIcon(
                    selectedType: 5,
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.teal,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget markIcon({required int selectedType, required Widget child}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: type == selectedType
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2.5),
              )
            : null,
        margin: const EdgeInsets.all(2),
        child: InkWell(
          onTap: () {
            setState(() {
              type = selectedType;
            });
          },
          child: child,
        ),
      ),
    );
  }
}
