/*
 * Created by Abdullah Razzaq on 03/09/2025.
*/
import 'package:flutter/material.dart';

class HomeGridItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onSelected;

  const HomeGridItem({super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 3),
      color: color.withOpacity(.5),
      child: Card(
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
      ),
    );
  }
}