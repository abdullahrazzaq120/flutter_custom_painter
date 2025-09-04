/*
 * Created by Abdullah Razzaq on 01/09/2023.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/helpers/custom_colors.dart';
import 'package:flutter_custom_painter/enums/form_enum.dart';
import 'package:flutter_custom_painter/screens/vehicle_select_screen.dart';
import 'package:flutter_custom_painter/widgets/home_grid_item.dart';

import '../models/home_grid_model.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'home-screen';

  const HomeScreen({super.key});

  static final List<HomeGridModel> _homeGridItems = [
    const HomeGridModel(
        text: 'Add Vehicle',
        icon: Icons.car_crash_rounded,
        color: CustomColors.home_vehicle_bg),
    const HomeGridModel(
        text: 'Add Customer',
        icon: Icons.person_add,
        color: CustomColors.home_customer_bg),
    const HomeGridModel(
      text: 'Agreement Open',
      icon: Icons.bookmark_add,
      color: CustomColors.home_agreement_open_bg,
      navigationArgs: [FormEnum.customer, FormEnum.date],
    ),
    const HomeGridModel(
      text: 'Agreement Check-Out',
      icon: Icons.location_on,
      color: CustomColors.home_agreement_out_bg,
      navigationArgs: [FormEnum.vehicle, FormEnum.customer],
    ),
    const HomeGridModel(
      text: 'Agreement Check-In',
      icon: Icons.edit_location_sharp,
      color: CustomColors.home_agreement_in_bg,
      navigationArgs: [FormEnum.vehicle, FormEnum.customer, FormEnum.date],
    ),
    const HomeGridModel(
      text: 'Agreement Close',
      icon: Icons.blinds_closed,
      color: CustomColors.home_agreement_close_bg,
      navigationArgs: [FormEnum.customer, FormEnum.date],
    ),
    const HomeGridModel(
        text: 'Staff Check-Out',
        icon: Icons.car_crash_rounded,
        color: CustomColors.home_staff_out_bg),
    const HomeGridModel(
        text: 'Staff Check-In',
        icon: Icons.edit_location_sharp,
        color: CustomColors.home_staff_in_bg),
    const HomeGridModel(
      text: 'Workshop Check-Out',
      icon: Icons.garage,
      color: CustomColors.home_workshop_out_bg,
      navigationArgs: [FormEnum.date, FormEnum.workshop],
    ),
    const HomeGridModel(
      text: 'Workshop Check-In',
      icon: Icons.garage_outlined,
      color: CustomColors.home_workshop_in_bg,
      navigationArgs: [FormEnum.vehicle, FormEnum.date, FormEnum.workshop],
    ),
    const HomeGridModel(
        text: 'Reports',
        icon: Icons.report,
        color: CustomColors.home_report_bg),
    const HomeGridModel(
        text: 'How to use',
        icon: Icons.info,
        color: CustomColors.home_howto_bg),
    const HomeGridModel(
        text: 'Web App',
        icon: Icons.web_asset,
        color: CustomColors.home_agreement_out_bg),
    const HomeGridModel(
        text: 'Global Car Rental',
        icon: Icons.car_rental,
        color: CustomColors.home_customer_bg),
  ];

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
                  children: HomeScreen._homeGridItems.map((item) {
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
