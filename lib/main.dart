import 'package:flutter/material.dart';
import 'main_screen.dart'; // Importing the main screen of the application

void main() => runApp(MyApp()); // Entry point of the application, running the MyApp widget

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Building the MaterialApp widget
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the app
      theme: ThemeData(
        primaryColor: Colors.black, // Sets the primary color of the app to black
        scaffoldBackgroundColor: Colors.black, // Sets the background color of the scaffold to black
      ),
      home: MainScreen(), // Specifies the home widget of the app
    );
  }
}