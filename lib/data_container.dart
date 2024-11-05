import 'package:flutter/material.dart';

// Define text styles for different UI elements
const textStyle1 = TextStyle(color: Color(0xFFFFFFFF), fontSize: 20.0); // Style for normal text
const textStyle2 = TextStyle(color: Color(0xFFFFFFFF), fontSize: 60.0, fontWeight: FontWeight.w900); // Style for larger, bold text
const textStyle3 = TextStyle(color: Color(0xFFFFFFFF), fontSize: 30.0, fontWeight: FontWeight.w900); // Style for medium-sized bold text

// A stateless widget that represents a data container with an icon and a title
class DataContainer extends StatelessWidget {
  // Constructor for DataContainer, requires an icon and a title
  const DataContainer({super.key, required this.icon, required this.title});

  final IconData icon; // Icon data to be displayed
  final String title; // Title text to be displayed

  @override
  Widget build(BuildContext context) {
    // Build method that returns a column containing the icon and title
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the children vertically
      children: [
        Icon(icon, size: 80.0, color: Colors.white), // Display the icon with specified size and color
        const SizedBox(height: 15.0), // Add spacing between the icon and title
        Text(title, style: textStyle1), // Display the title text with the defined text style
      ],
    );
  }
}
