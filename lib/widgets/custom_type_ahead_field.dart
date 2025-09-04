/*
 * Created by Abdullah Razzaq on 01/05/2025.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/helpers/app_utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTypeAheadField<T> extends StatelessWidget {
  final Future<List<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  final String? title;
  final String? hint;
  final void Function(T) onSelected;
  final TextEditingController controller;

  const CustomTypeAheadField({
    super.key,
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.title,
    this.hint,
    required this.onSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsCallback: suggestionsCallback,
      itemBuilder: itemBuilder,
      errorBuilder: (context, error) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title == null ? "" : "Unable to Load $title",
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        );
      },
      loadingBuilder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: 50,
          height: 50,
          child: const CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
      builder: (context, controller, focusNode) => TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        style: const TextStyle(fontSize: 14),
        keyboardType: title == null ? TextInputType.none : null,
        readOnly: title == null ? true : false,
        decoration: AppUtils.buildInputDecoration(hint: hint, isTextField: false),
      ),
      controller: controller,
      onSelected: onSelected,
    );
  }
}
