import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/notes/patient_view.dart';
import 'package:mynotes/views/notes/supply_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_service.dart';

class PatientService {
  static final PatientService _shared = PatientService._sharedInstance();
  PatientService._sharedInstance() {
    _patientRecordsStreamController =
        StreamController<List<PatientRecord>>.broadcast(
      onListen: () {
        _patientRecordsStreamController.sink.add(_patientRecords);
      },
    );
  }

  factory PatientService() => _shared;

  List<PatientRecord> _patientRecords = [];

  late final StreamController<List<PatientRecord>>
      _patientRecordsStreamController;

  Stream<List<PatientRecord>> get allPatientRecords =>
      _patientRecordsStreamController.stream;

  Future<void> _catchPatientRecords() async {
    log("(**** CACHING ****");
    final allPatientRecords = await getAllPatientRecords();
    log("ALL ITEMS: $allPatientRecords");
    _patientRecords = allPatientRecords.toList();
    _patientRecordsStreamController.add(_patientRecords);
  }

  Future<PatientRecord> createPatientRecord(
      {required PatientCloudRecord record}) async {
    _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    print("Creating item");

    // create the item
    final patientId = await db.insert(patientRecordsTable, {
      idColumn: record.id,
      address1Column: record.address_1,
      address2Column: record.address_2,
      addressOfNextOfKinColumn: record.address_of_next_of_kin,
      ageColumn: record.age,
      contactColumn: record.contact,
      dateOfFirstAttendanceColumn:
          record.date_of_first_attendance?.microsecondsSinceEpoch,
      dobColumn: record.dob?.microsecondsSinceEpoch,
      firstNameColumn: record.first_name,
      maritalStatusColumn: record.marital_status,
      nextOfKinColumn: record.next_of_kin,
      occupationColumn: record.occupation,
      placeOfBirthColumn: record.place_of_birth,
      religionColumn: record.religion,
      surnameColumn: record.surname,
      sexColumn: record.sex
    });

    log(patientId.toString());

    final databasePatientRecord = PatientRecord(
      address_1: record.address_1,
      address_2: record.address_2,
      address_of_next_of_kin: record.address_of_next_of_kin,
      age: record.age,
      date_of_first_attendance: record.date_of_first_attendance,
      contact: record.contact,
      dob: record.dob,
      first_name: record.first_name,
      id: record.id,
      marital_status: record.marital_status,
      next_of_kin: record.next_of_kin,
      occupation: record.occupation,
      place_of_birth: record.place_of_birth,
      religion: record.religion,
      surname: record.surname,
      sex: record.sex,
    );

    _patientRecords.add(databasePatientRecord);
    _patientRecordsStreamController.add(_patientRecords);
    return databasePatientRecord;
  }

  Future<PatientRecord> getItem({required String id}) async {
    _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final clinicItems = await db.query(patientRecordsTable,
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (clinicItems.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final clinicItem = PatientRecord.fromRow(clinicItems.first);
      _patientRecords.removeWhere((clinicItem) => clinicItem.id == id);
      _patientRecords.add(clinicItem);
      _patientRecordsStreamController.add(_patientRecords);
      return clinicItem;
    }
  }

  Future<Iterable<PatientRecord>> getAllPatientRecords() async {
    await _ensureDBIsOpen();
    final db = _getDatabaseOrThrow();
    final items = await db.query(patientRecordsTable);
    final result = items.map((itemRow) => PatientRecord.fromRow(itemRow));
    log("MAPPED RESULTS $result");
    return result;
  }

  Database _getDatabaseOrThrow() {
    final db = DatabaseService().db;
    log("INTERNAL DB IS $db");
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> writeToFireStore(
      {required PatientCloudRecord patientDoc}) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('patients').doc(patientDoc.id);
    await ref.set(patientDoc.toJson());
  }

  Future<void> _ensureDBIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (DatabaseService().db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      DatabaseService().db = db;
      log("DB IS $DatabaseService().db");

      await db.execute(createPatientsTable);
      await _catchPatientRecords();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _getDatabaseOrThrow();
    db.close();
    DatabaseService().db = null;
  }
}

class PatientRecord {
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

  PatientRecord(
      {required this.id,
      required this.address_1,
      required this.address_2,
      required this.address_of_next_of_kin,
      required this.age,
      required this.contact,
      required this.date_of_first_attendance,
      required this.dob,
      required this.first_name,
      required this.surname,
      required this.occupation,
      required this.marital_status,
      required this.next_of_kin,
      required this.place_of_birth,
      required this.religion,
      required this.sex});

  PatientRecord.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as String,
        address_1 = map[address1Column] as String?,
        address_2 = map[address2Column] as String?,
        address_of_next_of_kin = map[addressOfNextOfKinColumn] as String?,
        age = map[ageColumn] as int?,
        contact = map[contactColumn] as String?,
        date_of_first_attendance = DateTime.fromMillisecondsSinceEpoch(
            (map[dateOfFirstAttendanceColumn] as int?) ??
                DateTime.now().microsecondsSinceEpoch),
        dob = DateTime.fromMillisecondsSinceEpoch(
            (map[dobColumn] as int?) ?? DateTime.now().microsecondsSinceEpoch),
        first_name = map[firstNameColumn] as String,
        surname = map[surnameColumn] as String,
        occupation = map[occupationColumn] as String?,
        marital_status = map[maritalStatusColumn] as String?,
        next_of_kin = map[nextOfKinColumn] as String?,
        place_of_birth = map[placeOfBirthColumn] as String?,
        religion = map[religionColumn] as String?,
        sex = map[sexColumn] as String?;

  @override
  String toString() => 'Note, ID = $id, firstName = $first_name, id =  $id';

  @override
  bool operator ==(covariant PatientRecord other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'patients.db';
const patientRecordsTable = 'patients';
const idColumn = 'id';
const address1Column = 'address_1';
const address2Column = 'address_2';
const addressOfNextOfKinColumn = 'address_of_next_of_kin';
const ageColumn = 'age';
const contactColumn = 'contact';
const dateOfFirstAttendanceColumn = 'date_of_first_attendance';
const dobColumn = 'dob';
const firstNameColumn = 'first_name';
const maritalStatusColumn = 'marital_status';
const nextOfKinColumn = 'next_of_kin';
const occupationColumn = 'occupation';
const placeOfBirthColumn = 'place_of_birth';
const religionColumn = 'religion';
const surnameColumn = 'surname';
const sexColumn = 'sex';

const createPatientsTable = '''CREATE TABLE IF NOT EXISTS "patients" (
	"address_1"	TEXT,
	"address_2"	TEXT,
	"address_of_next_of_kin"	TEXT,
	"age"	INTEGER,
	"contact"	TEXT,
	"id"	TEXT NOT NULL UNIQUE,
	"date_of_first_attendance"	INTEGER,
	"dob"	INTEGER,
	"first_name"	TEXT,
	"marital_status"	TEXT,
	"next_of_kin"	TEXT,
	"occupation"	TEXT,
	"place_of_birth"  TEXT,
	"religion"	TEXT,
	"surname" TEXT,
  "sex" TEXT
);''';
