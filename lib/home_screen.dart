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
  int type = 0;

  Offset? _startPoint; // Starting point of the current line
  Offset? _currentPoint; // Current point during drawing a line

  void _addMark(Offset position) {
    setState(() {
      if (type == 3) {
        _startPoint = position; // Set the starting point
        _currentPoint = position; // Initialize current point
      }

      marks.add(Mark(position: position, type: type)); // Add new mark
    });
  }

  void _updateLine(Offset currentPoint) {
    setState(() {
      _currentPoint = currentPoint; // Update the current point as user drags
    });
  }

  void _endLine(Offset endPoint) {
    if (_startPoint != null) {
      print('Here i am');
      print(_startPoint);
      print(_currentPoint);
      print(endPoint);

      setState(() {
        marks.add(Mark(
            position: _startPoint!,
            endPosition: endPoint,
            type: type));

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
                _addMark(details.localPosition); // Add mark on touch
              },
              onPanUpdate: type == 3 ? (details) {
                _updateLine(details.localPosition); // Update the line as user drags
              } : null,
              onPanEnd: type == 3 ? (details) {
                if (_currentPoint != null) {
                  _endLine(_currentPoint!); // Finish the line
                }
              } : null,
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
              height: MediaQuery.of(context).size.height / 3,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: type == 0
                        ? BoxDecoration(
                            shape:
                                BoxShape.circle, // Makes the container circular
                            border: Border.all(
                                color: Colors.black, width: 2), // Circle border
                          )
                        : null,
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          type = 0;
                        });
                      },
                      child: const Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: type == 1
                        ? BoxDecoration(
                            shape:
                                BoxShape.circle, // Makes the container circular
                            border: Border.all(
                                color: Colors.black, width: 2), // Circle border
                          )
                        : null,
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          type = 1;
                        });
                      },
                      child: const Icon(
                        Icons.radio_button_unchecked_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: type == 2
                        ? BoxDecoration(
                            shape:
                                BoxShape.circle, // Makes the container circular
                            border: Border.all(
                                color: Colors.black, width: 2), // Circle border
                          )
                        : null,
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          type = 2;
                        });
                      },
                      child: const Icon(
                        Icons.close_sharp,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: type == 3
                        ? BoxDecoration(
                      shape:
                      BoxShape.circle, // Makes the container circular
                      border: Border.all(
                          color: Colors.black, width: 2), // Circle border
                    )
                        : null,
                    padding: const EdgeInsets.all(3),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          type = 3;
                        });
                      },
                      child: const Icon(
                        Icons.linear_scale,
                        color: Colors.red,
                        size: 20,
                      ),
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
}
