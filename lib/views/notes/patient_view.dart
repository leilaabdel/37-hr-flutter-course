import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/crud/patient_service.dart';

import '../../enums/menu_action.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  _PatientViewState createState() {
    return _PatientViewState();
  }
}

class _PatientViewState extends State<PatientView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Patient List'),
        actions: [
          PopupMenuButton<PatientMenuAction>(
            onSelected: (value) async {
              switch (value) {
                case PatientMenuAction.addNewPatient:
                  Navigator.of(context).pushNamed(newPatientFormRoute);
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<PatientMenuAction>(
                    value: PatientMenuAction.addNewPatient,
                    child: Text('Add New'))
              ];
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    print(PatientService().allPatientRecords);
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder(
      stream: PatientService().allPatientRecords,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!);
      },
    );
  }

  Widget _buildList(BuildContext context, List<PatientRecord> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, PatientRecord data) {
    return Padding(
      key: ValueKey(data.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(data.first_name),
            trailing: Text(data.id.toString()),
            onTap: () {
              print(data);
              Navigator.of(context)
                  .pushNamed(specificPatientItemRoute, arguments: data);
            }),
      ),
    );
  }
}

class PatientCloudRecord {
  final String id;
  final String? address_1;
  final String? address_2;
  final String? address_of_next_of_kin;
  final int? age;
  final String? contact;
  final DateTime? date_of_first_attendance;
  final DateTime? dob;
  final String first_name;
  final String surname;
  final String? occupation;
  final String? marital_status;
  final String? next_of_kin;
  final String? place_of_birth;
  final String? religion;
  final String? sex;
  final DocumentReference reference;

  PatientCloudRecord.fromMap(Map<String, dynamic> map,
      {required this.reference})
      : assert(map['id'] != null),
        assert(map['first_name'] != null),
        id = reference.id,
        address_1 = map['address_1'],
        address_2 = map['address_2'],
        address_of_next_of_kin = map['address_of_next_of_kin'],
        age = map['age'],
        contact = map['contact'],
        date_of_first_attendance = map['date_of_first_attendance'].toDate(),
        dob = map['dob'].toDate(),
        first_name = map['first_name'],
        surname = map['surname'],
        occupation = map['occupation'],
        marital_status = map['marital_status'],
        next_of_kin = map['next_of_kin'],
        place_of_birth = map['place_of_birth'],
        sex = map['gender'],
        religion = map['religion'];

  PatientCloudRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$first_name:$surname>";
}
