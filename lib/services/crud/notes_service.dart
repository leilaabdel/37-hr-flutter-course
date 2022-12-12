import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/notes/supply_view.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  Database? _db;

  List<ClinicItem> _clinicItems = [];

  final _clinicItemStreamController =
      StreamController<List<ClinicItem>>.broadcast();

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _catchClinicItems() async {
    final allNotes = await getAllClinicItems();
    _clinicItems = allNotes.toList();
    _clinicItemStreamController.add(_clinicItems);
  }

  Future<ClinicItem> createClinicItem({required ItemRecord record}) async {
    final db = _getDatabaseOrThrow();

    // create the item
    final itemId = await db.insert(clinicItemTable, {
      idColumn: record.id,
      itemNameColumn: record.itemName,
      replacementFrequencuColumn: record.replacementFrequency,
      sizeColumn: record.size,
      transfemoralColumn: record.transfemoral ? 1 : 0,
      transtibialColumn: record.transtibial ? 1 : 0,
      usageColumn: record.useage
    });

    final databaseClinicItem = ClinicItem(
        id: record.id,
        amount: record.amount,
        itemName: record.itemName,
        replacementFrequency: record.replacementFrequency,
        size: record.size,
        transfemoral: record.transfemoral,
        transtibial: record.transtibial,
        useage: record.useage);

    _clinicItems.add(databaseClinicItem);
    _clinicItemStreamController.add(_clinicItems);
    return databaseClinicItem;
  }

  // Future<void> deleteNote({required int id}) async {
  //   final db = _getDatabaseOrThrow();
  //   final deleteCount = db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
  //   if (deleteCount != 1) {
  //     throw CouldNotDeleteNote();
  //   } else {
  //     _clinicItems.removeWhere((clinicItem) => clinicItem.id == id);
  //     _clinicItemStreamController.add(_clinicItems);
  //   }
  // }

  // Future<int> deleteAllNotes() async {
  //   final db = _getDatabaseOrThrow();
  //   final numberOfDeletions = await db.delete(noteTable);
  //   _clinicItems = [];
  //   _clinicItemStreamController.add(_clinicItems);
  //   return numberOfDeletions;
  // }

  Future<ClinicItem> getItem({required String id}) async {
    final db = _getDatabaseOrThrow();
    final clinicItems = await db.query(clinicItemTable,
        where: 'id = ?', whereArgs: [id], limit: 1);
    if (clinicItems.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final clinicItem = ClinicItem.fromRow(clinicItems.first);
      _clinicItems.removeWhere((clinicItem) => clinicItem.id == id);
      _clinicItems.add(clinicItem);
      _clinicItemStreamController.add(_clinicItems);
      return clinicItem;
    }
  }

  Future<ClinicItem> updateNote({
    required ClinicItem item,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getItem(id: item.id);

    final updatesCount = await db.update(
        noteTable,
        {
          textColumn: text,
          isSyncedWithCloudColumn: 0,
        },
        where: 'id = ?',
        whereArgs: [item.id]);

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedItem = await getItem(id: item.id);
      _clinicItems.removeWhere((item) => item.id == updatedItem.id);
      _clinicItems.add(updatedItem);
      _clinicItemStreamController.add(_clinicItems);
      return updatedItem;
    }
  }

  Future<Iterable<ClinicItem>> getAllClinicItems() async {
    final db = _getDatabaseOrThrow();
    final items = await db.query(clinicItemTable);
    final result = items.map((itemRow) => ClinicItem.fromRow(itemRow));
    return result;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> _ensureDBIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //create the user table
      // await db.execute(createUserTable);
      //create the note table
      // await db.execute(createNoteTable);

      await db.execute(createItemTable);
      await _catchClinicItems();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _getDatabaseOrThrow();
    db.close();
    _db = null;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId =  $userId, isSyncedWithCloud = $isSyncedWithCloud,  text = $text';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ClinicItem {
  final String id;
  final int amount;
  final String itemName;
  final int replacementFrequency;
  final String? size;
  final bool transfemoral;
  final bool transtibial;
  final String? useage;

  ClinicItem(
      {required this.id,
      required this.amount,
      required this.itemName,
      required this.replacementFrequency,
      required this.size,
      required this.transfemoral,
      required this.transtibial,
      required this.useage});

  ClinicItem.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as String,
        amount = map[amountColumn] as int,
        itemName = map[itemNameColumn] as String,
        replacementFrequency = map[replacementFrequencuColumn] as int,
        size = map[sizeColumn] as String,
        transfemoral = (map[transfemoralColumn] as int) == 1 ? true : false,
        transtibial = (map[transtibialColumn] as int) == 1 ? true : false,
        useage = map[usageColumn] as String;

  @override
  String toString() =>
      'Note, ID = $id, itemName = $itemName, amount =  $amount';

  @override
  bool operator ==(covariant ClinicItem other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const clinicItemTable = 'items';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const itemNameColumn = 'item_name';
const amountColumn = 'amount';
const replacementFrequencuColumn = 'replacement_frequency';
const sizeColumn = 'size';
const transfemoralColumn = 'transfemoral';
const transtibialColumn = 'transtibial';
const usageColumn = 'usage';

const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
    "id"	INTEGER NOT NULL UNIQUE,
    "email"	INTEGER NOT NULL UNIQUE
  );''';

const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
    "id"	INTEGER NOT NULL,
    "user_id"	INTEGER,
    "text"	TEXT,
    "is_synced_with_cloud"	INTEGER NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "user"("id"),
    PRIMARY KEY("id" AUTOINCREMENT)
  );''';

const createItemTable = '''CREATE TABLE IF NOT EXISTS "items" (
	"id"	TEXT NOT NULL UNIQUE,
	"amount"	INTEGER NOT NULL,
	"item_name"	TEXT,
	"size"	TEXT,
	"transfemoral"	INTEGER,
	"transtibial"	INTEGER,
	"part"	TEXT NOT NULL
);''';
