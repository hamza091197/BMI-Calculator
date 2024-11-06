import 'package:flutter/material.dart';
import 'login_screen.dart'; // Importing the login screen

void main() => runApp(const MyApp()); // Entry point of the application, running the MyApp widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Building the MaterialApp widget
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the app
      theme: ThemeData(
        primaryColor: Colors.black,
        // Sets the primary color of the app to black
        scaffoldBackgroundColor:
        Colors.black, // Sets the background color of the scaffold to black
      ),
      home: const LoginScreen(), // Specifies the home widget of the app (login screen)
      routes: {
        '/login': (context) => const LoginScreen(), // Define route for login screen
        // You can add other routes here if necessary
      },
    );
  }
}
