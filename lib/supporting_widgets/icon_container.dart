import 'package:flutter/material.dart';
import 'package:project_management/core/core_colors.dart';
class IconContainer extends StatelessWidget {
  final String tittle;
  final IconData icon;
  final double height;
  final double width;
  const IconContainer({
    super.key,
    required this.tittle,
    required this.icon,
    required this.height,
    required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: lightBlack,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white, // Change the icon color as needed
            size: 50, // Change the icon size as needed
          ),
          Text(
            tittle,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
