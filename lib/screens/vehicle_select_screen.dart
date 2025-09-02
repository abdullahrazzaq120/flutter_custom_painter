/*
 * Created by Abdullah Razzaq on 26/08/2025.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/forms/customer_form.dart';
import 'package:flutter_custom_painter/forms/date_time_form.dart';
import 'package:flutter_custom_painter/forms/vehicle_form.dart';
import 'package:flutter_custom_painter/forms/workshop_form.dart';
import 'package:flutter_custom_painter/screens/exterior_screen.dart';

import '../form_enum.dart';

class VehicleSelectScreen extends StatelessWidget {
  VehicleSelectScreen({super.key});
  static String routeName = 'vehicle-select-screen';

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as List<FormEnum>;
    print(args);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vehicle Select Screen'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              args.contains(FormEnum.vehicle) ? VehicleForm() : const SizedBox(),
              args.contains(FormEnum.customer) ? CustomerForm() : const SizedBox(),
              args.contains(FormEnum.workshop) ? WorkshopForm() : const SizedBox(),
              args.contains(FormEnum.date) ? DateTimeForm() : const SizedBox(),
              const SizedBox(height: 14),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ExteriorScreen.routeName);
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
        ),
      ),
    );
  }
}
