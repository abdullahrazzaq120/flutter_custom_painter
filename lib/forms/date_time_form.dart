/*
 * Created by Abdullah Razzaq on 01/09/2025.
*/

import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/helpers/app_utils.dart';
import 'package:intl/intl.dart' as intl;

class DateTimeForm extends StatefulWidget {

  DateTimeForm({super.key});

  @override
  State<DateTimeForm> createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  DateTime? _date;

  TimeOfDay? _time;

  DateTime? _closingDate;

  TimeOfDay? _closingTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(
                    isTextField: true,
                    hint: _date == null ? 'Date' : intl.DateFormat('yyyy-MM-dd').format(_date!)),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  AppUtils.presentDatePicker(context, _date, (picked) => _date = picked);
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(
                    isTextField: true,
                    hint: _time == null ? 'Time' : AppUtils.formatTimeOfDay(_time!)),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  AppUtils.presentTimePicker(context, (picked) => _time = picked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(
                    isTextField: true,
                    hint: _closingDate == null ? 'Closing Date' : intl.DateFormat('yyyy-MM-dd').format(_closingDate!)),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  AppUtils.presentDatePicker(context, _closingDate, (picked) => _closingDate = picked);
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: AppUtils.buildInputDecoration(
                    isTextField: true,
                    hint: _closingTime == null ? 'Closing Time' : AppUtils.formatTimeOfDay(_closingTime!)),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  AppUtils.presentTimePicker(context, (picked) => _closingTime = picked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
