import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:calculator/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'container_box.dart';
import 'data_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

const activeColor = Color(0xff0073dd);
const inActiveColor = Color(0xFF212121);
const textStyle1 = TextStyle(fontSize: 18.0, color: Colors.white);
const textStyle2 =
    TextStyle(fontSize: 50.0, fontWeight: FontWeight.w900, color: Colors.white);
const textStyle3 =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Color maleBoxColor = activeColor, femaleBoxColor = inActiveColor;
  int height = 165, weight = 80, age = 27;
  String result = "";
  String gender = "Male"; // Set default gender to Male
  final weightController = TextEditingController(),
      ageController = TextEditingController();

  Timer? _timer; // Declare a Timer variable

  // Method to start the timer and increment the value
  void startIncrement(Function increment) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      increment();
    });
  }

  // Method to stop the timer
  void stopIncrement() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set default gender to Male when the screen initializes
    gender = "Male";
  }

  // Generate and download PDF report
  Future<void> downloadReport() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: <pw.Widget>[
            pw.Text('BMI Report',
                style:
                    pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Height: $height cm', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Weight: $weight kg', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Age: $age years', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Gender: $gender', style: pw.TextStyle(fontSize: 20)),
            // Gender field
            pw.SizedBox(height: 20),
            pw.Text('BMI: $result',
                style:
                    pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );
    }));

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/bmi_report.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Report saved at: $filePath')));
      OpenFile.open(filePath); // Open file after saving
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving report: $e')));
    }
  }

  // Update box color based on gender selection
  void updateBoxColor(int genderSelection) {
    setState(() {
      if (genderSelection == 1) {
        maleBoxColor = activeColor;
        femaleBoxColor = inActiveColor;
        gender = 'Male'; // Set gender to Male
      } else {
        femaleBoxColor = activeColor;
        maleBoxColor = inActiveColor;
        gender = 'Female'; // Set gender to Female
      }
    });
  }

  // BMI calculation formula
  String calculateBmi(int weight, int height) =>
      (weight / pow(height / 100, 2)).toStringAsFixed(1);

  // Show input dialog to update weight or age
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
              decoration: InputDecoration(hintText: hintText)),
          actions: [
            TextButton(
              onPressed: () {
                int value = int.tryParse(controller.text) ?? 0;
                if (value > 200 || value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(value > 200
                          ? 'Exceeds max limit'
                          : 'Invalid value')));
                } else {
                  setState(() => updateValue(value));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Create input container for weight/age with increment/decrement functionality
  Widget buildContainer(String title, int value, String unit,
      void Function() increment, void Function() decrement) {
    return ContainerBox(
      boxColor: inActiveColor,
      childwidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title, style: textStyle1),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(value.toString(), style: textStyle2),
            Text(unit, style: textStyle1),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FloatingActionButton(
                onPressed: increment,
                backgroundColor: activeColor,
                child: const Icon(FontAwesomeIcons.plus, color: Colors.white)),
            const SizedBox(width: 20),
            FloatingActionButton(
                onPressed: decrement,
                backgroundColor: activeColor,
                child: const Icon(FontAwesomeIcons.minus, color: Colors.white)),
          ]),
        ],
      ),
    );
  }

  // Handle back button navigation
  void handleBack() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: handleBack),
        // Back button
        actions: [
          IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: downloadReport)
        ], // Download button
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Gender selection
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () => updateBoxColor(1),
                        child: ContainerBox(
                            boxColor: maleBoxColor,
                            childwidget: const DataContainer(
                                icon: FontAwesomeIcons.male, title: 'MALE')))),
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

            // Height slider
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
                        const Text('cm', style: textStyle1)
                      ]),
                  Slider(
                      value: height.toDouble(),
                      min: 120,
                      max: 220,
                      activeColor: activeColor,
                      inactiveColor: inActiveColor,
                      onChanged: (newValue) =>
                          setState(() => height = newValue.round())),
                ],
              ),
            ),
            // Weight and Age containers
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                        onTap: () => showInputDialog(
                            'Enter your weight',
                            'Weight in kg',
                            weightController,
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
                            ageController, (val) => age = val),
                        child: buildContainer(
                            'AGE',
                            age,
                            'years',
                            () => setState(() => age++),
                            () => setState(() => age--)))),
              ],
            ),
            // Footer with developer links
            Column(
              children: <Widget>[
                ContainerBox(
                  boxColor: inActiveColor,
                  childwidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                                onPressed: () => launch(
                                    'https://github.com/hamza091197?tab=repositories'),
                                backgroundColor: inActiveColor,
                                child: const Icon(FontAwesomeIcons.github,
                                    color: Colors.white)),
                            const SizedBox(width: 10.0),
                            FloatingActionButton(
                                onPressed: () => launch(
                                    'https://www.linkedin.com/in/hamza-khalid-357b4327b/'),
                                backgroundColor: inActiveColor,
                                child: const Icon(FontAwesomeIcons.linkedin,
                                    color: Colors.white)),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
            // Calculate BMI button
            GestureDetector(
              onTap: () {
                setState(() {
                  result = calculateBmi(weight, height);
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
                              const Text('Your BMI is', style: textStyle3),
                              Text(result, style: textStyle2),
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
                        style: TextStyle(color: Colors.white, fontSize: 20.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
