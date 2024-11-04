import 'package:flutter/material.dart';

class ContainerBox extends StatelessWidget {
  // Constructor to create a ContainerBox with a specified color and child widget
  const ContainerBox({Key? key, required this.boxColor, required this.childwidget}) : super(key: key);

  // Color of the container
  final Color boxColor;

  // The widget to be displayed inside the container
  final Widget childwidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set margin around the container
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        // Rounded corners for the container
        borderRadius: BorderRadius.circular(10.0),
        // Background color of the container
        color: boxColor,
      ),
      // Child widget displayed inside the container
      child: childwidget,
    );
  }
}
