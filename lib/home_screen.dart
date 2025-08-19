/*
 * Created by Abdullah Razzaq on 10/12/2024.
*/
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_painter/app_utils.dart';
import 'package:image_picker/image_picker.dart';

import 'mark.dart';
import 'mark_painter.dart';
import 'dart:ui' as ui;

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

  double imageHeight = 0;
  double imageWidth = 0;
  double availableDeviceHeight = 0;
  double availableDeviceWidth = 0;
  double heightScale = 0;
  double widthScale = 0;

  String imageUrl =
      "https://app.speedautosystems.com/app/images/suv_exterior.jpg";
  final GlobalKey _firstItemKey = GlobalKey();
  double scale = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getCanvasSize();
    await fetchImageSize();
    getDimensionScale();
    setCanvasDimension();
    _initializeDefaultMarks();
  }

  void _initializeDefaultMarks() {
    // Ensure scale is calculated before adding marks
    marks.addAll([
      Mark(position: Offset(161 * scale, 209 * scale), type: 1),
      Mark(
        position: Offset(133 * scale, 122 * scale),
        type: 1,
      ),
      Mark(
        position: Offset(151 * scale, 255 * scale),
        endPosition: Offset(150 * scale, 349 * scale),
        type: 3,
      ),
      Mark(position: Offset(31 * scale, 332 * scale), type: 2),
    ]);
    setState(() {}); // Update UI if marks are added after initial build
  }

  void getCanvasSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _firstItemKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;

      availableDeviceHeight = size.height;
      availableDeviceWidth = size.width;

      print('Available Device Height: $availableDeviceHeight');
      print('Available Device Width: $availableDeviceWidth');
    });
  }

  Future<void> fetchImageSize() async {
    ui.Image image = await AppUtils.getImageDimensions(imageUrl);

    imageHeight = image.height.toDouble();
    imageWidth = image.width.toDouble();

    print('Image Height: $imageHeight');
    print('Image Width: $imageWidth');
  }

  void getDimensionScale() {
    heightScale = availableDeviceHeight / imageHeight;
    widthScale = availableDeviceWidth / imageWidth;
    scale = min(heightScale, widthScale);
  }

  void setCanvasDimension() {
    setState(() {
      imageHeight *= scale;
      imageWidth *= scale;
    });

    print('New Image Height: $imageHeight');
    print('New Image Width: $imageWidth');
  }

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
        final Mark newMark = Mark(
          position: position,
          type: globalType,
          isFocus: true,
          endPosition: globalType == 3 ? position : null,
        );

        if (globalType == 3) {
          _startPoint = position;
          _currentPoint = position;
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
        backgroundColor: Colors.teal,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    key: _firstItemKey,
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: imageHeight,
                      width: imageWidth,
                      child: GestureDetector(
                        // Offset = (horizontal distance from left, vertical distance from top) inside the container.
                        onPanStart: (details) {
                          if (globalType == 5) {
                            return;
                          }

                          if (globalFocusedMark != null &&
                              globalFocusedMark!.type == 3) {
                            // Calculate the initial offset relative to the line's start position
                            initialTouchLineOffset = details.localPosition -
                                globalFocusedMark!.position;
                          }
                        },
                        onPanDown: (details) {
                          if (globalType == 5) {
                            // Type 5 is camera, no drawing action
                            return;
                          }

                          _addMark(details.localPosition);

                          // Determine if the touch is near the start or end of a line mark
                          if (globalFocusedMark?.type == 3) {
                            // Type 3 is line
                            isTouchedNearStartingPoint =
                                AppUtils.isMarkPositionNear(
                                    globalFocusedMark!.position,
                                    details.localPosition);
                            isTouchedNearEndingPoint =
                                AppUtils.isMarkPositionNear(
                                        globalFocusedMark!.endPosition!,
                                        details.localPosition) &&
                                    !isTouchedNearStartingPoint;
                          }
                        },
                        onPanUpdate: (details) {
                          if (globalFocusedMark == null && globalType == 3) {
                            _updateLine(clampToCanvas(details.localPosition));
                          }

                          setState(() {
                            final int markIndex = marks.indexWhere((mark) =>
                                mark.position == globalFocusedMark!.position);

                            if (markIndex == -1) {
                              return; // Should not happen if globalFocusedMark is not null
                            }

                            globalFocusedMark!.isFocus =
                                true; // Ensure focus is maintained

                            if (globalFocusedMark!.type == 3) {
                              if (isTouchedNearStartingPoint) {
                                globalFocusedMark!.position =
                                    clampToCanvas(details.localPosition);
                              } else if (isTouchedNearEndingPoint) {
                                globalFocusedMark!.endPosition =
                                    clampToCanvas(details.localPosition);
                              } else if (initialTouchLineOffset != null) {
                                // Move the entire line
                                final Offset newStart =
                                    clampToCanvas(details.localPosition) -
                                        initialTouchLineOffset!;
                                final Offset newEnd = newStart +
                                    (globalFocusedMark!.endPosition! -
                                        globalFocusedMark!.position);
                                globalFocusedMark!.position =
                                    clampToCanvas(newStart);
                                globalFocusedMark!.endPosition =
                                    clampToCanvas(newEnd);
                              }
                            } else {
                              globalFocusedMark!.position =
                                  clampToCanvas(details.localPosition);
                            }
                            marks[markIndex] = globalFocusedMark!;
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
                            Image.network(
                              imageUrl,
                            ),
                            CustomPaint(
                              size: Size.infinite,
                              painter: MarkPainter(marks: marks),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // captured images
                if (isPopupVisible &&
                    globalFocusedMark != null &&
                    globalFocusedMark!.imagePaths != null &&
                    globalFocusedMark!.imagePaths!.isNotEmpty)
                  Positioned(
                    left: globalFocusedMark!.position.dx - 0,
                    // Adjust as needed for alignment
                    top: globalFocusedMark!.position.dy - 0,
                    // Popup above the mark
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: globalFocusedMark!.imagePaths!.length > 1
                            ? 100
                            : 55,
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
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        globalFocusedMark!.imagePaths!.length >
                                                1
                                            ? 2
                                            : 1,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: globalFocusedMark!
                                      .imagePaths!.length
                                      .clamp(0, 2),
                                  itemBuilder: (context, index) {
                                    return Image.file(
                                      File(globalFocusedMark!
                                          .imagePaths![index]),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    );
                                  }),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "... more",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 10),
                                  ),
                                  // SizedBox(width: 4),
                                  // Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
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

  Offset clampToCanvas(Offset point) {
    return Offset(
      point.dx.clamp(0.0, imageWidth),
      point.dy.clamp(0.0, imageHeight),
    );
  }
}
