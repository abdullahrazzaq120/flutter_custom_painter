/*
 * Created by Abdullah Razzaq on 01/09/2023.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/helpers/app_utils.dart';
import 'package:flutter_custom_painter/helpers/custom_colors.dart';
import 'package:flutter_custom_painter/enums/form_enum.dart';
import 'package:flutter_custom_painter/screens/vehicle_select_screen.dart';
import 'package:flutter_custom_painter/widgets/home_grid_item.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToVehicleSelect(BuildContext context, List<FormEnum> args, String title) {
    Navigator.pushNamed(context, VehicleSelectScreen.routeName, arguments: {'title': title, 'args' : args});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    getCanvasSize();
  }

  final GlobalKey _firstItemKey = GlobalKey();
  double screenHeight = 0;

  void getCanvasSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _firstItemKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;

      setState(() {
        screenHeight = size.height - 10;
        print(screenHeight);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height -
    //     kToolbarHeight // subtract AppBar
    //     -
    //     MediaQuery.of(context).padding.top; // subtract status bar

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColors.home_bg,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                key: _firstItemKey,
                alignment: Alignment.center,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: (screenWidth / 2) / (screenHeight / 7.05),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: AppUtils.homeGridItems.map((item) {
                    return HomeGridItem(
                      text: item.text,
                      icon: item.icon,
                      color: item.color,
                      onSelected: item.navigationArgs != null
                          ? () => _navigateToVehicleSelect(context, item.navigationArgs!, item.text)
                          : null,
                    );
                  }).toList(),
                ),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Contact us for queries and suggestions',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'info@speedautosystems.com',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                  Text(
                    '+1 888-446-7102',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
