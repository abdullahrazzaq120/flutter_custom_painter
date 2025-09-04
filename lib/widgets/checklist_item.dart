/*
 * Created by Abdullah Razzaq on 04/09/2025.
*/
import 'package:flutter/material.dart';

class ChecklistItem extends StatefulWidget {
  final String title;

  const ChecklistItem({super.key, required this.title});

  @override
  _ChecklistItemState createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<ChecklistItem> {
  bool checkbox1 = false;
  bool checkbox2 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      // like activity_horizontal_margin
      constraints: const BoxConstraints(minHeight: 50),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis, // like singleLine="true"
                ),
              ),
              Checkbox(
                value: checkbox1,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() => checkbox1 = value ?? false);
                },
              ),
              Checkbox(
                value: checkbox2,
                activeColor: Colors.teal,
                onChanged: (value) {
                  setState(() => checkbox2 = value ?? false);
                },
              ),
            ],
          ),
          Divider(height: 2,),
        ],
      ),
    );
  }
}
