/*
 * Created by Abdullah Razzaq on 01/09/2023.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/custom_colors.dart';
import 'package:flutter_custom_painter/form_enum.dart';
import 'package:flutter_custom_painter/screens/vehicle_select_screen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        kToolbarHeight // subtract AppBar
        -
        MediaQuery.of(context).padding.top; // subtract status bar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColors.home_bg,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: (screenWidth / 2) / (screenHeight / 8.2),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _HomeGridItem(
                    text: 'Add Vehicle',
                    icon: Icons.car_crash_rounded,
                    color: CustomColors.home_vehicle_bg,
                  ),
                  _HomeGridItem(
                    text: 'Add Customer',
                    icon: Icons.person_add,
                    color: CustomColors.home_customer_bg,
                  ),
                  _HomeGridItem(
                    text: 'Agreement Open',
                    icon: Icons.bookmark_add,
                    color: CustomColors.home_agreement_open_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [FormEnum.customer, FormEnum.date]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Agreement Check-Out',
                    icon: Icons.location_on,
                    color: CustomColors.home_agreement_out_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [
                            FormEnum.vehicle,
                            FormEnum.customer
                          ]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Agreement Check-In',
                    icon: Icons.edit_location_sharp,
                    color: CustomColors.home_agreement_in_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [
                            FormEnum.vehicle,
                            FormEnum.customer,
                            FormEnum.date
                          ]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Agreement Close',
                    icon: Icons.blinds_closed,
                    color: CustomColors.home_agreement_close_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [FormEnum.customer, FormEnum.date]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Staff Check-Out',
                    icon: Icons.car_crash_rounded,
                    color: CustomColors.home_staff_out_bg,
                  ),
                  _HomeGridItem(
                    text: 'Staff Check-In',
                    icon: Icons.person_add,
                    color: CustomColors.home_staff_in_bg,
                  ),
                  _HomeGridItem(
                    text: 'Workshop Check-Out',
                    icon: Icons.garage,
                    color: CustomColors.home_workshop_out_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [FormEnum.date, FormEnum.workshop]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Workshop Check-In',
                    icon: Icons.garage_outlined,
                    color: CustomColors.home_workshop_in_bg,
                    onSelected: () {
                      Navigator.pushNamed(
                          context, VehicleSelectScreen.routeName,
                          arguments: const [
                            FormEnum.vehicle,
                            FormEnum.date,
                            FormEnum.workshop
                          ]);
                    },
                  ),
                  _HomeGridItem(
                    text: 'Reports',
                    icon: Icons.report,
                    color: CustomColors.home_report_bg,
                  ),
                  _HomeGridItem(
                    text: 'How to use',
                    icon: Icons.info,
                    color: CustomColors.home_howto_bg,
                  ),
                  _HomeGridItem(
                    text: 'Web App',
                    icon: Icons.web_asset,
                    color: CustomColors.home_agreement_out_bg,
                  ),
                  _HomeGridItem(
                    text: 'Global Car Rental',
                    icon: Icons.car_rental,
                    color: CustomColors.home_customer_bg,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contact us for queries and suggestions',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'info@speedautosystems.com',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '+1 888-446-7102',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeGridItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onSelected;

  const _HomeGridItem({
    required this.text,
    required this.icon,
    required this.color,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.3), // Water drop/ripple effect
        highlightColor: Colors.white.withOpacity(0.1),
        onTap: onSelected,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
