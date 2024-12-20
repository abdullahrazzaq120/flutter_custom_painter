/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
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
  int globalType = 0;
  int previousGlobalType = 0;
  final double _markRadius = 20.0;
  Offset? focusedMarkInitialPosition;
  Mark? globalFocusedMark;

  Offset? _startPoint; // Starting point of the current line
  Offset? _currentPoint; // Current point during drawing a line

  Offset? initialTouchLineOffset;
  bool isTouchedNearStartingPoint = false;
  bool isTouchedNearEndingPoint = false;

  void clearFocus() {
    for (var mark in marks) {
      mark.isFocus = false; // Reset focus for all marks
    }
  }

  bool isMarkPositionNear(Offset targetedPosition, Offset tapPosition) {
    return (targetedPosition - tapPosition).distance <= _markRadius;;
  }

  Mark? getMarkIfExist(Offset tapPosition) {
    try {
      clearFocus();
      final Mark focusedMark = marks.firstWhere((mark) {
        if (mark.type == 3) {
          final Offset closestPoint = _getClosestPointForLine(
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

  void _addMark(Offset position) {
    setState(() {
      globalFocusedMark = getMarkIfExist(position);

      if (globalFocusedMark == null) {
        // add new mark
        final Mark newMark;
        if (globalType == 3) {
          _startPoint = position;
          _currentPoint = position;

          newMark = Mark(
            position: position,
            endPosition: _currentPoint,
            type: globalType,
            isFocus: true,
          );
        } else {
          newMark = Mark(
            position: position,
            type: globalType,
            isFocus: true,
          );
        }

        marks.add(newMark);
        focusedMarkInitialPosition = newMark.position;
      } else {
        // focus on existing mark
        globalFocusedMark!.isFocus = true;
        focusedMarkInitialPosition = globalFocusedMark!.position;
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
      processLine(currentPoint);
    });
  }

  void _endLine(Offset endPoint) {
    if (_startPoint != null) {
      setState(() {
        processLine(endPoint);
        _startPoint = null;
        _currentPoint = null;
      });
    }
  }

  void processLine(Offset endPoint) {
    final int markIndex = marks.indexWhere((mark) {
      return mark.position == _startPoint;
    });

    marks[markIndex] = Mark(
        position: _startPoint!,
        endPosition: endPoint,
        type: globalType,
        isFocus: true);
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
              onPanStart: (details){
                if (globalFocusedMark != null && globalFocusedMark!.type == 3) {
                  // Calculate the initial offset relative to the line's start position
                  initialTouchLineOffset = details.localPosition - globalFocusedMark!.position;
                }
              },
              onPanDown: (details) {
                if (globalType == 5) {
                  return;
                }

                _addMark(details.localPosition); // Add mark on touch

                if (globalFocusedMark != null && globalFocusedMark!.type == 3){
                  if (isMarkPositionNear(globalFocusedMark!.position, details.localPosition)){
                    isTouchedNearStartingPoint = true;
                    isTouchedNearEndingPoint = false;
                  } else if(isMarkPositionNear(globalFocusedMark!.endPosition!, details.localPosition)){
                    isTouchedNearStartingPoint = false;
                    isTouchedNearEndingPoint = true;
                  } else{
                    isTouchedNearStartingPoint = false;
                    isTouchedNearEndingPoint = false;
                  }
                } else {
                  isTouchedNearStartingPoint = false;
                  isTouchedNearEndingPoint = false;
                }
              },
              onPanUpdate: (details) {
                setState(() {
                  if (globalFocusedMark != null) {
                    final int markIndex = marks.indexWhere((mark) {
                      return mark.position == globalFocusedMark!.position;
                    });

                    if (globalFocusedMark!.type == 3) {
                      if (isTouchedNearStartingPoint){
                        globalFocusedMark = Mark(
                          position: details.localPosition,
                          endPosition: globalFocusedMark!.endPosition,
                          type: 3,
                          isFocus: true,
                        );
                      } else if(isTouchedNearEndingPoint){
                        globalFocusedMark = Mark(
                          position: globalFocusedMark!.position,
                          endPosition: details.localPosition,
                          type: 3,
                          isFocus: true,
                        );
                      } else {
                        // Ensure the drag respects the initial offset
                        final Offset newStart = details.localPosition - initialTouchLineOffset!;
                        final Offset newEnd = newStart + (globalFocusedMark!.endPosition! - globalFocusedMark!.position);

                        globalFocusedMark = Mark(
                          position: newStart,
                          endPosition: newEnd,
                          type: 3,
                          isFocus: true,
                        );
                      }
                    } else {
                      globalFocusedMark = Mark(
                          position: details.localPosition,
                          type: globalFocusedMark!.type,
                          isFocus: true);
                    }
                    marks[markIndex] = globalFocusedMark!;
                    focusedMarkInitialPosition = globalFocusedMark!.position;
                  } else {
                    if (globalType == 3) {
                      _updateLine(details.localPosition);
                    }
                  }
                });
              },
              onPanEnd: (details) {
                if (globalType == 3) {
                  if (_currentPoint != null) {
                    _endLine(_currentPoint!); // Finish the line
                  }
                }
              },
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
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  markIcon(
                    selectedType: 0,
                    child: Icon(
                      Icons.circle,
                      color: globalType == 0 ? Colors.red : Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(height: 1),
                  markIcon(
                    selectedType: 1,
                    child: Icon(
                      Icons.radio_button_unchecked_rounded,
                      color: globalType == 1 ? Colors.red : Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(height: 1),
                  markIcon(
                    selectedType: 2,
                    child: Icon(
                      Icons.close_sharp,
                      color: globalType == 2 ? Colors.red : Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(height: 1),
                  markIcon(
                    selectedType: 3,
                    child: Divider(
                      thickness: 4,
                      endIndent: 4,
                      indent: 4,
                      color: globalType == 3 ? Colors.red : Colors.teal,
                    ),
                  ),
                  const Divider(height: 1),
                  markIcon(
                    selectedType: 4,
                    child: Icon(
                      Icons.delete,
                      color: globalType == 4 ? Colors.red : Colors.teal,
                      size: 25,
                    ),
                  ),
                  const Divider(height: 1),
                  markIcon(
                    selectedType: 5,
                    child: Icon(
                      Icons.camera_alt,
                      color: globalType == 5 ? Colors.red : Colors.teal,
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
      child: InkWell(
        onTap: () {
          setState(() {
            previousGlobalType = globalType;
            globalType = selectedType;
            if (selectedType == 4) {
              globalType = previousGlobalType;
              marks.removeWhere((mark) {
                return mark.position == focusedMarkInitialPosition;
              });
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(2),
          child: child,
        ),
      ),
    );
  }
}
