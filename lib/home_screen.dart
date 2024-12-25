/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_painter/app_utils.dart';
import 'package:image_picker/image_picker.dart';

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
  Mark? globalFocusedMark;

  Offset? _startPoint; // Starting point of the current line
  Offset? _currentPoint; // Current point during drawing a line

  Offset? initialTouchLineOffset;
  bool isTouchedNearStartingPoint = false;
  bool isTouchedNearEndingPoint = false;

  bool isPopupVisible = true;

  void clearFocus() {
    for (var mark in marks) {
      mark.isFocus = false; // Reset focus for all marks
    }
    globalFocusedMark = null;
  }

  void _addMark(Offset position) {
    setState(() {
      clearFocus();
      globalFocusedMark = AppUtils.getMarkIfExist(marks, position);

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
        globalFocusedMark = newMark;
      } else {
        // focus on existing mark
        globalFocusedMark!.isFocus = true;
      }
    });
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

    if (marks.length < markIndex) {
      marks[markIndex] = Mark(
          position: _startPoint!,
          endPosition: endPoint,
          type: globalType,
          isFocus: true);
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
                clearFocus();
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
            child: Stack(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    if (globalType == 5) {
                      return;
                    }

                    if (globalFocusedMark != null &&
                        globalFocusedMark!.type == 3) {
                      // Calculate the initial offset relative to the line's start position
                      initialTouchLineOffset =
                          details.localPosition - globalFocusedMark!.position;
                    }
                  },
                  onPanDown: (details) {
                    if (globalType == 5) {
                      return;
                    }

                    _addMark(details.localPosition); // Add mark on touch

                    if (globalFocusedMark != null &&
                        globalFocusedMark!.type == 3) {
                      if (AppUtils.isMarkPositionNear(
                          globalFocusedMark!.position, details.localPosition)) {
                        isTouchedNearStartingPoint = true;
                        isTouchedNearEndingPoint = false;
                      } else if (AppUtils.isMarkPositionNear(
                          globalFocusedMark!.endPosition!,
                          details.localPosition)) {
                        isTouchedNearStartingPoint = false;
                        isTouchedNearEndingPoint = true;
                      } else {
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
                          if (isTouchedNearStartingPoint) {
                            globalFocusedMark!.position = details.localPosition;
                            globalFocusedMark!.isFocus = true;
                          } else if (isTouchedNearEndingPoint) {
                            globalFocusedMark!.endPosition = details.localPosition;
                            globalFocusedMark!.isFocus = true;
                          } else {
                            final Offset newStart = details.localPosition - initialTouchLineOffset!;
                            final Offset newEnd = newStart + (globalFocusedMark!.endPosition! - globalFocusedMark!.position);

                            globalFocusedMark!.position = newStart;
                            globalFocusedMark!.endPosition = newEnd;
                            globalFocusedMark!.isFocus = true;
                          }
                        } else {
                          globalFocusedMark!.position = details.localPosition;
                          globalFocusedMark!.isFocus = true;
                        }
                        marks[markIndex] = globalFocusedMark!;
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
                if (isPopupVisible && globalFocusedMark != null && globalFocusedMark!.imagePaths != null && globalFocusedMark!.imagePaths!.isNotEmpty)
                  Positioned(
                    left: globalFocusedMark!.position.dx - 0,
                    // Adjust as needed for alignment
                    top: globalFocusedMark!.position.dy - 0,
                    // Popup above the mark
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 120,
                        height: 80,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 40,
                              child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1,
                                    ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: globalFocusedMark!.imagePaths!.length.clamp(0, 2),
                                  itemBuilder: (context, index) {
                                      return Image.file(
                                        File(globalFocusedMark!.imagePaths![index]),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      );
                                    }),
                              ),
                            GestureDetector(
                              onTap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "See More",
                                    style: TextStyle(color: Colors.blue, fontSize: 12),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2.2,
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
        onTap: () async {
          previousGlobalType = globalType;
          setState(() {
            globalType = selectedType;
          });
          if (selectedType == 4) {
            setState(() {
              globalType = previousGlobalType;
              marks.removeWhere((mark) {
                return mark.position == globalFocusedMark?.position;
              });
              clearFocus();
            });
          } else if (selectedType == 5) {
            // camera
            setState(() {
              globalType = previousGlobalType;
            });

            if (globalFocusedMark != null) {
              final int markIndex = marks.indexWhere((mark) {
                return mark.position == globalFocusedMark?.position;
              });

              final File imageTemp;

              try {
                final camera = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );

                if (camera == null) return;
                imageTemp = File(camera.path);

                globalFocusedMark!.imagePaths ??= [];
                globalFocusedMark!.imagePaths!.add(imageTemp.path);

                setState(() {
                  marks[markIndex] = globalFocusedMark!;
                });
              } on PlatformException catch (e) {
                print('Failed to pick image: $e');
              }
            }
          }
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
