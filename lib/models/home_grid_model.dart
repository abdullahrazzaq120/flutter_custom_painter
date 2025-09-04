/*
 * Created by Abdullah Razzaq on 03/09/2025.
*/
import 'package:flutter/material.dart';

import '../enums/form_enum.dart';

class HomeGridModel {
  final String text;
  final IconData icon;
  final Color color;
  final List<FormEnum>? navigationArgs;

  const HomeGridModel({
    required this.text,
    required this.icon,
    required this.color,
    this.navigationArgs,
  });
}