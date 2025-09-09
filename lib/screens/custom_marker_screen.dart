/*
 * Created by Abdullah Razzaq on 08/09/2025.
*/
import 'package:flutter/material.dart';
import 'package:image_marker/mark.dart';
import 'package:image_marker/marker_controller.dart';
import 'package:image_marker/marker_screen.dart';

import 'signature_screen.dart';

class CustomMarkerScreen extends StatelessWidget {
  CustomMarkerScreen({super.key});

  static String routeName = 'custom_marker_screen';
  final markerController = MarkerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Marks Exterior'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              markerController.clearAllMarks();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              markerController.saveAllMarks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MarkerScreen(
              image: 'https://app.speedautosystems.com/app/images/suv_exterior.jpg',
              defaultMarks: [
                Mark(position: const Offset(161, 209), type: 1),
                Mark(
                  position: const Offset(133, 122),
                  type: 1,
                ),
                Mark(
                  position: const Offset(151, 255),
                  endPosition: const Offset(150, 349),
                  type: 3,
                ),
                Mark(position: const Offset(31, 332), type: 2),
              ],
              onMarkAdded: (mark) {
                print('Mark added: ${mark.position}');
              },
              onMarkImagesClick: (images){
                print('Mark images: $images');
              },
              showImages: false,
              controller: markerController,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(SignatureScreen.routeName);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Next"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                // Text color
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                shadowColor: Colors.teal.withOpacity(0.5), // Shadow color
              ).copyWith(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.red.shade700; // Splash color when pressed
                  return null; // Defer to the widget's default.
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
