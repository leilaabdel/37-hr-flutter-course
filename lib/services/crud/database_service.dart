import 'dart:developer';

import 'package:mynotes/services/crud/patient_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'crud_exceptions.dart';

class DatabaseService {
  static final DatabaseService _shared = DatabaseService._sharedInstance();

  DatabaseService._sharedInstance();

  factory DatabaseService() => _shared;
  Database? db;
}

const dbName = 'ghops.db';
