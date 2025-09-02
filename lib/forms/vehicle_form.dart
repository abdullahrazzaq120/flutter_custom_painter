/*
 * Created by Abdullah Razzaq on 29/08/2025.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/app_utils.dart';
import 'package:flutter_custom_painter/widgets/custom_type_ahead_field.dart';

class VehicleForm extends StatelessWidget {

  final TextEditingController _searchVehicleByPlateNo = TextEditingController();
  final TextEditingController _searchNewVehicle = TextEditingController();
  final TextEditingController _searchVehicleByFleetNo = TextEditingController();
  final TextEditingController _make = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _kmOut = TextEditingController();
  final TextEditingController _fuelOut = TextEditingController();
  final TextEditingController _km = TextEditingController();
  final TextEditingController _fuel = TextEditingController();

  VehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['plate123','plate435'],
          title: 'Plate No',
          hint: 'Search Vehicle by Plate No',
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
          onSelected: (plateno) {
            _searchVehicleByPlateNo.text = plateno;
          },
          controller: _searchVehicleByPlateNo,
        ),
        const SizedBox(height: 10),
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['vehicle123','vehicle435'],
          title: 'Vehicle',
          hint: 'New Vehicle',
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
          onSelected: (vehicle) {
            _searchNewVehicle.text = vehicle;
          },
          controller: _searchNewVehicle,
        ),
        const SizedBox(height: 10),
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['fleet123','fleet435'],
          title: 'Fleet No',
          hint: 'Search Vehicle by Fleet No',
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
          onSelected: (fleet) {
            _searchVehicleByFleetNo.text = fleet;
          },
          controller: _searchVehicleByFleetNo,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Make', isTextField: true),
                controller: _make,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Model', isTextField: true),
                controller: _model,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: '000 out', isTextField: true),
                controller: _kmOut,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Fuel level out', isTextField: true),
                controller: _fuelOut,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: '000', isTextField: true),
                controller: _km,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(hint: 'Fuel level', isTextField: true),
                controller: _fuel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
