/*
 * Created by Abdullah Razzaq on 01/09/2025.
*/
import 'package:flutter/material.dart';

import '../helpers/app_utils.dart';
import '../widgets/custom_type_ahead_field.dart';

class WorkshopForm extends StatefulWidget {

  const WorkshopForm({super.key});

  @override
  State<WorkshopForm> createState() => _WorkshopFormState();
}

class _WorkshopFormState extends State<WorkshopForm> {
  final TextEditingController _searchWorkshopName = TextEditingController();

  final TextEditingController _workshopType = TextEditingController();

  final TextEditingController _workshopService = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['Workshop1','Workshop2'],
          title: 'Workshop Name',
          hint: 'Workshop Name',
          itemBuilder: (context, String data) {
            return SizedBox(
              height: 50,
              child: ListTile(
                textColor: Theme.of(context).primaryColor,
                title: Text(
                  data,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
          onSelected: (workshop) {
            _searchWorkshopName.text = workshop;
          },
          controller: _searchWorkshopName,
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Workshop Type', isTextField: true),
                controller: _workshopType,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Service', isTextField: true),
                controller: _workshopService,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
