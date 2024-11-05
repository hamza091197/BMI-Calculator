import 'dart:math'; // Importing dart:math for mathematical calculations
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'container_box.dart'; // Importing custom widget ContainerBox
import 'data_container.dart'; // Importing custom widget DataContainer
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

// Constants for colors and text styles
const activeColor = Color(0xff0073dd);
const inActiveColor = Color(0xFF212121);
const textStyle1 = TextStyle(fontSize: 18.0, color: Colors.white);
const textStyle2 = TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900, color: Colors.white);
const textStyle3 = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState(); // Creating state for MainScreen
}

class _MainScreenState extends State<MainScreen> {
  // State variables for UI elements
  Color maleBoxColor = activeColor; // Color for male selection box
  Color femaleBoxColor = inActiveColor; // Color for female selection box
  int height = 165; // Default height in cm
  int weight = 80; // Default weight in kg
  int age = 27; // Default age
  String result = ""; // Result variable for BMI calculation

  // Function to update the color of gender selection boxes
  void updateBoxColor(int gender) {
    if (gender == 1) {
      // If male is selected
      maleBoxColor = (maleBoxColor == inActiveColor) ? activeColor : inActiveColor;
      femaleBoxColor = (maleBoxColor == inActiveColor) ? inActiveColor : activeColor;
    } else {
      // If female is selected
      femaleBoxColor = (femaleBoxColor == inActiveColor) ? activeColor : inActiveColor;
      maleBoxColor = (femaleBoxColor == activeColor) ? inActiveColor : activeColor;
    }
  }

  // Function to calculate BMI
  String calculateBmi(int weight, int height) {
    double bmi = weight / pow(height / 100, 2); // BMI formula
    return bmi.toStringAsFixed(1); // Return BMI rounded to one decimal place
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")), // App bar title
      body: SingleChildScrollView( // Allow scrolling if the content is too large
        child: Column(
          children: <Widget>[
            // Gender selection row
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => updateBoxColor(1)), // Update color for male
                    child: ContainerBox(
                      boxColor: maleBoxColor,
                      childwidget: const DataContainer(icon: FontAwesomeIcons.male, title: 'MALE'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => updateBoxColor(2)), // Update color for female
                    child: ContainerBox(
                      boxColor: femaleBoxColor,
                      childwidget: const DataContainer(icon: FontAwesomeIcons.female, title: 'FEMALE'),
                    ),
                  ),
                ),
              ],
            ),
            // Height selection container
            ContainerBox(
              boxColor: inActiveColor,
              childwidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('HEIGHT', style: textStyle1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(height.toString(), style: textStyle2),
                      const Text('cm', style: textStyle1),
                    ],
                  ),
                  Slider(
                    value: height.toDouble(),
                    min: 120,
                    max: 220,
                    activeColor: activeColor,
                    inactiveColor: inActiveColor,
                    onChanged: (newValue) => setState(() => height = newValue.round()), // Update height
                  ),
                ],
              ),
            ),
            // Row for weight and age selection
            Row(
              children: <Widget>[
                Expanded(
                  child: ContainerBox(
                    boxColor: inActiveColor,
                    childwidget: buildWeightContainer(), // Weight selection widget
                  ),
                ),
                Expanded(
                  child: ContainerBox(
                    boxColor: inActiveColor,
                    childwidget: buildAgeContainer(), // Age selection widget
                  ),
                ),
              ],
            ),
            // Developed by section
            buildDevelopedBySection(),
            // Calculate button
            GestureDetector(
              onTap: () {
                setState(() {
                  result = calculateBmi(weight, height); // Calculate BMI on tap
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: inActiveColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          color: inActiveColor,
                          height: 200.0,
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Your BMI', style: textStyle1),
                              Text(result.toString(), style: textStyle2), // Display BMI result
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: activeColor,
                margin: const EdgeInsets.only(top: 10.0),
                child: const Center(child: Text('Calculate', style: textStyle3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for weight selection
  Column buildWeightContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('WEIGHT', style: textStyle1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weight.toString(), style: textStyle2),
            const Text('kg', style: textStyle1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => setState(() => weight++), // Increment weight
              backgroundColor: activeColor,
              child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              onPressed: () => setState(() => weight > 0 ? weight-- : weight), // Decrement weight
              backgroundColor: activeColor,
              child: const Icon(FontAwesomeIcons.minus, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // Widget for age selection
  Column buildAgeContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('AGE', style: textStyle1),
        Text(age.toString(), style: textStyle2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => setState(() => age < 100 ? age++ : age), // Increment age
              backgroundColor: activeColor,
              child: const Icon(FontAwesomeIcons.plus, color: Colors.white),
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              onPressed: () => setState(() => age > 0 ? age-- : age), // Decrement age
              backgroundColor: activeColor,
              child: const Icon(FontAwesomeIcons.minus, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  // Section displaying developer information
  Column buildDevelopedBySection() {
    return Column(
      children: <Widget>[
        ContainerBox(
          boxColor: inActiveColor,
          childwidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Developed with ❤ by Hamza Khalid', style: textStyle1),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildSocialMediaIcons(), // Build social media icons
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for social media icons
  List<Widget> buildSocialMediaIcons() {
    return [
      FloatingActionButton(
        elevation: 0,
        onPressed: () => launch('https://github.com/hamza091197?tab=repositories'), // Launch GitHub
        backgroundColor: inActiveColor,
        child: const Icon(FontAwesomeIcons.github, color: Colors.white),
      ),
      const SizedBox(width: 10.0),
      FloatingActionButton(
        elevation: 0,
        onPressed: () => launch('https://www.linkedin.com/in/hamza-khalid-357b4327b/'), // Launch LinkedIn
        backgroundColor: inActiveColor,
        child: const Icon(FontAwesomeIcons.linkedin, color: Colors.white),
      ),
    ];
  }
}