import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_googlesheet/controller/info_controller.dart';
import 'package:flutter_googlesheet/info_list.dart';
import 'package:flutter_googlesheet/model/info.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sheet Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Google Sheet Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stageController = TextEditingController();
  TextEditingController clientRevenueController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController returnDurationController = TextEditingController();
  TextEditingController closeDateController = TextEditingController();
  TextEditingController profitBrokerFeeController = TextEditingController();

  // Method to Submit Feedback and save it in Google Sheets
  void _submitInfo() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed.
      Information infoForm = Information(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
      );

      InformationController infoController = InformationController();

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheets.
      infoController.submitInfo(infoForm, (String response) {
        log("Response: $response");
        if (response == InformationController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Info Submitted");
        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: firstNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Valid First Name';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                        ),
                        TextFormField(
                          controller: lastNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Valid Last Name';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (!value!.contains("@")) {
                              return 'Enter Valid Email';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                      ],
                    ),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                    color: Colors.white,
                  )),
                ),
                onPressed: _submitInfo,
                child: const Text('Submit Information'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                    color: Colors.white,
                  )),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InfoListPage(),
                      ));
                },
                child: const Text('View Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
