/*
 * Created by Abdullah Razzaq on 04/09/2025.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/helpers/app_utils.dart';
import 'package:flutter_custom_painter/screens/custom_marker_screen.dart';
import 'package:flutter_custom_painter/widgets/checklist_item.dart';

class ChecklistScreen extends StatelessWidget {
  static String routeName = 'checklist-screen';

  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checklist'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return ChecklistItem(
                      title: AppUtils.checklistItems[index],
                    );
                  },
                  itemCount: AppUtils.checklistItems.length,
                ),
              ),
              const SizedBox(height: 14),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CustomMarkerScreen.routeName);
                      },
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
                        shadowColor:
                            Colors.teal.withOpacity(0.5), // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        ));
  }
}
