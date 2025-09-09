import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/screens/custom_marker_screen.dart';
import 'package:flutter_custom_painter/screens/signature_screen.dart';
import 'package:flutter_custom_painter/screens/vehicle_select_screen.dart';

import 'screens/checklist_screen.dart';
import 'screens/home_grid_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Painter Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        SignatureScreen.routeName: (context) => const SignatureScreen(),
        VehicleSelectScreen.routeName: (context) => VehicleSelectScreen(),
        ChecklistScreen.routeName: (context) => ChecklistScreen(),
        CustomMarkerScreen.routeName: (context) => CustomMarkerScreen(),
      },
    );
  }
}
