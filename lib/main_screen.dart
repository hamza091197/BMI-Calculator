import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'container_box.dart';
import 'data_container.dart';
import 'package:url_launcher/url_launcher.dart';

// Constant colors and text styles
const activeColor = Color(0xff0073dd); // Color for active boxes
const inActiveColor = Color(0xFF212121); // Color for inactive boxes
const textStyle1 =
    TextStyle(fontSize: 18.0, color: Colors.white); // Style for regular text
const textStyle2 = TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.w900,
    color: Colors.white); // Style for large text
const textStyle3 = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
    color: Colors.white); // Style for bold text

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variables to store the state of the app
  Color maleBoxColor = activeColor; // Male box color
  Color femaleBoxColor = inActiveColor; // Female box color
  int height = 165, weight = 80, age = 27; // Initial height, weight, and age
  String result = ""; // To store BMI result
  final _weightController =
      TextEditingController(); // Controller for weight input
  final _ageController = TextEditingController(); // Controller for age input

  // Function to update the color of the gender boxes when selected
  void updateBoxColor(int gender) {
    setState(() {
      if (gender == 1) {
        // If male is selected, set male to active and female to inactive
        maleBoxColor = activeColor;
        femaleBoxColor = inActiveColor;
      } else {
        // If female is selected, set female to active and male to inactive
        femaleBoxColor = activeColor;
        maleBoxColor = inActiveColor;
      }
    });
  }

  // Function to calculate BMI based on weight and height
  String calculateBmi(int weight, int height) {
    return (weight / pow(height / 100, 2))
        .toStringAsFixed(1); // Formula for BMI
  }

  // Function to show an input dialog for weight or age
  void showInputDialog(String title, String hintText,
      TextEditingController controller, Function(int) updateValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: [
            // Button to submit the input and update value
            TextButton(
              onPressed: () {
                int value = int.tryParse(controller.text) ??
                    (hintText == 'Weight in kg' ? weight : age);
                if (value > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$title exceeds the maximum limit of 200'),
                    backgroundColor: Colors.redAccent,
                  ));
                } else {
                  updateValue(value); // Update the value based on user input
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to build the container for weight and age selection with increment/decrement buttons
  Widget buildContainer(String title, int value, String unit,
      void Function() increment, void Function() decrement) {
    return ContainerBox(
      boxColor: inActiveColor,
      childwidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: textStyle1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(value.toString(), style: textStyle2),
              Text(unit, style: textStyle1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Increment button
              FloatingActionButton(
                  onPressed: increment,
                  backgroundColor: activeColor,
                  child:
                      const Icon(FontAwesomeIcons.plus, color: Colors.white)),
              SizedBox(width: 20),
              // Decrement button
              FloatingActionButton(
                  onPressed: decrement,
                  backgroundColor: activeColor,
                  child:
                      const Icon(FontAwesomeIcons.minus, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")), // AppBar with title
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Row to display male and female selection boxes
            Row(
              children: <Widget>[
                // Male gender box
                Expanded(
                    child: GestureDetector(
                        onTap: () => updateBoxColor(1),
                        child: ContainerBox(
                            boxColor: maleBoxColor,
                            childwidget: const DataContainer(
                                icon: FontAwesomeIcons.male, title: 'MALE')))),
                // Female gender box
                Expanded(
                    child: GestureDetector(
                        onTap: () => updateBoxColor(2),
                        child: ContainerBox(
                            boxColor: femaleBoxColor,
                            childwidget: const DataContainer(
                                icon: FontAwesomeIcons.female,
                                title: 'FEMALE')))),
              ],
            ),
            // Container for height input with a slider
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
                    onChanged: (newValue) =>
                        setState(() => height = newValue.round()),
                  ),
                ],
              ),
            ),
            // Row to display weight and age containers with input options
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () => showInputDialog(
                            'Enter your weight',
                            'Weight in kg',
                            _weightController,
                            (val) => weight = val),
                        child: buildContainer(
                            'WEIGHT',
                            weight,
                            'kg',
                            () => setState(() => weight++),
                            () => setState(() => weight--)))),
                Expanded(
                    child: GestureDetector(
                        onTap: () => showInputDialog('Enter your age', 'Age',
                            _ageController, (val) => age = val),
                        child: buildContainer(
                            'AGE',
                            age,
                            'years',
                            () => setState(() => age++),
                            () => setState(() => age--)))),
              ],
            ),
            // Footer with developer info and social media links
            Column(
              children: <Widget>[
                ContainerBox(
                  boxColor: inActiveColor,
                  childwidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Developed with ❤ by Hamza Khalid',
                          style: textStyle1),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // GitHub link button
                          FloatingActionButton(
                              onPressed: () => launch(
                                  'https://github.com/hamza091197?tab=repositories'),
                              backgroundColor: inActiveColor,
                              child: const Icon(FontAwesomeIcons.github,
                                  color: Colors.white)),
                          SizedBox(width: 1),
                          // LinkedIn link button
                          FloatingActionButton(
                              onPressed: () => launch(
                                  'https://www.linkedin.com/in/hamza-khalid-357b4327b/'),
                              backgroundColor: inActiveColor,
                              child: const Icon(FontAwesomeIcons.linkedin,
                                  color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Calculate BMI button
            GestureDetector(
              onTap: () {
                setState(() {
                  result = calculateBmi(weight, height); // Calculate BMI
                  // Show BMI result in dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: inActiveColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Container(
                          color: inActiveColor,
                          height: 200.0,
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Your BMI', style: textStyle1),
                              Text(result.toString(), style: textStyle2),
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: activeColor,
                  ),
                  child: const Center(
                      child: Text('Calculate BMI',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)))),
            ),
          ],
        ),
      ),
    );
  }
}
