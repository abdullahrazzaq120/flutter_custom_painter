/*
 * Created by Abdullah Razzaq on 29/08/2025.
*/
import 'package:flutter/material.dart';

import '../widgets/custom_type_ahead_field.dart';

class CustomerForm extends StatefulWidget {

  CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final TextEditingController _searchCustomerEmail = TextEditingController();

  final TextEditingController _searchCustomerName = TextEditingController();

  final TextEditingController _searchCustomerReferenceNo = TextEditingController();

  final TextEditingController _searchDriverName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['test1@gmail.com','teste2@gmail.com'],
          title: 'Customer Email',
          hint: 'Customer Email',
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
          onSelected: (email) {
            _searchCustomerEmail.text = email;
          },
          controller: _searchCustomerEmail,
        ),
        SizedBox(height: 10),
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['John','Walter'],
          title: 'Customer Name',
          hint: 'Customer Name',
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
          onSelected: (name) {
            _searchCustomerName.text = name;
          },
          controller: _searchCustomerName,
        ),
        SizedBox(height: 10),
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['Ref1','Ref2'],
          title: 'Reference Number',
          hint: 'Reference Number',
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
          onSelected: (refNo) {
            _searchCustomerReferenceNo.text = refNo;
          },
          controller: _searchCustomerReferenceNo,
        ),
        SizedBox(height: 10),
        CustomTypeAheadField<String>(
          suggestionsCallback: (query) async => ['Driver1','Driver2'],
          title: 'Driver/Staff Name',
          hint: 'Driver/Staff Name',
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
          onSelected: (driver) {
            _searchDriverName.text = driver;
          },
          controller: _searchDriverName,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
