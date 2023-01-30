import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/services/crud/patient_service.dart';
import 'package:mynotes/views/notes/patient_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a Form widget.
class NewPatientFrom extends StatefulWidget {
  const NewPatientFrom({super.key});

  @override
  NewPatientFromState createState() {
    return NewPatientFromState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewPatientFromState extends State<NewPatientFrom> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewPatientFromState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController surName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController occupation = TextEditingController();
  TextEditingController maritalStatus = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController placeOfBirth = TextEditingController();
  TextEditingController tribe = TextEditingController();
  TextEditingController patientContact = TextEditingController();
  TextEditingController religion = TextEditingController();
  TextEditingController nextOfKin = TextEditingController();
  TextEditingController addressOfNextofKin = TextEditingController();

  TextEditingController dobInput = TextEditingController();
  TextEditingController dateOfFirstVisitInput = TextEditingController();

  var dobDate = DateTime.now();
  var dateOfFirstVisit = DateTime.now();

  @override
  void initState() {
    PatientService().open();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    surName.dispose();
    firstName.dispose();
    address1.dispose();
    address2.dispose();
    occupation.dispose();
    maritalStatus.dispose();
    dob.dispose();
    age.dispose();
    placeOfBirth.dispose();
    tribe.dispose();
    patientContact.dispose();
    religion.dispose();
    nextOfKin.dispose();
    addressOfNextofKin.dispose();
    dobInput.dispose();
    dateOfFirstVisitInput.dispose();

    sex.dispose();
    PatientService().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('New Patient')),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: surName,
                    decoration: InputDecoration(
                      labelText: 'Surname',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: firstName,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: sex,
                    decoration: InputDecoration(
                      labelText: 'Sex',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: address1,
                    decoration: InputDecoration(
                      labelText: 'Address (1) Residential',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: address2,
                    decoration: InputDecoration(
                      labelText: 'Address (2) Business, Employer, or School',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: occupation,
                    decoration: InputDecoration(
                      labelText: 'Occupation',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: maritalStatus,
                    decoration: InputDecoration(
                      labelText: 'Marital Status',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dobInput,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        dobDate = pickedDate;
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dobInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: age,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: placeOfBirth,
                    decoration: InputDecoration(
                      labelText: 'Place of Birth',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: tribe,
                    decoration: InputDecoration(
                      labelText: 'Tribe',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: patientContact,
                    decoration: InputDecoration(
                      labelText: 'Patient/Client Contact',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: religion,
                    decoration: InputDecoration(
                      labelText: 'Religion',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dateOfFirstVisitInput,
                    decoration: InputDecoration(
                      labelText: 'Date of First Visit',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        dateOfFirstVisit = pickedDate;
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateOfFirstVisitInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nextOfKin,
                    decoration: InputDecoration(
                      labelText: 'Next of Kin',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressOfNextofKin,
                    decoration: InputDecoration(
                      labelText: 'Address of Next of Kin',
                      labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                      enabledBorder: new UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          var rng = new Random();
                          var code = rng.nextInt(9000000) + 1000000;
                          var patient = PatientCloudRecord(
                            id: code.toString(),
                            address_1: address1.text,
                            address_2: address2.text,
                            address_of_next_of_kin: addressOfNextofKin.text,
                            age: int.parse(age.text),
                            contact: patientContact.text,
                            date_of_first_attendance: dateOfFirstVisit,
                            dob: dobDate,
                            first_name: firstName.text,
                            surname: surName.text,
                            occupation: occupation.text,
                            marital_status: maritalStatus.text,
                            next_of_kin: nextOfKin.text,
                            place_of_birth: placeOfBirth.text,
                            religion: religion.text,
                            sex: sex.text,
                          );
                          PatientService().createPatientRecord(record: patient);
                          PatientService()
                              .writeToFireStore(patientDoc: patient);

                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
