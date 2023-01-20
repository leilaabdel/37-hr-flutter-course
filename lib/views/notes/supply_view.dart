import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class SupplyView extends StatefulWidget {
  const SupplyView({super.key});

  @override
  _SupplyViewState createState() {
    return _SupplyViewState();
  }
}

class _SupplyViewState extends State<SupplyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Clinic Supplies')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    print(NotesService().allClinicItems);
    // TODO: get actual snapshot from Cloud Firestore
    return StreamBuilder(
      stream: NotesService().allClinicItems,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!);
      },
    );
  }

  Widget _buildList(BuildContext context, List<ClinicItem> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, ClinicItem data) {
    return Padding(
      key: ValueKey(data.itemName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(data.itemName),
            trailing: Text(data.amount.toString()),
            onTap: () {
              print(data);
              Navigator.of(context)
                  .pushNamed(specificSupplyItemRoute, arguments: data);
            }),
      ),
    );
  }
}

class ItemRecord {
  final String id;
  final int amount;
  final String itemName;
  final int replacementFrequency;
  final String? size;
  final bool transfemoral;
  final bool transtibial;
  final String? useage;
  final DocumentReference reference;

  ItemRecord.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['amount'] != null),
        assert(map['item_name'] != null),
        assert(reference.id != null),
        id = reference.id,
        itemName = map['item_name'],
        amount = map['amount'],
        replacementFrequency = map['replacement_frequency'],
        size = map['size'],
        transfemoral = map['transfemoral'],
        transtibial = map['transtibial'],
        useage = map['useage'];

  ItemRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>,
            reference: snapshot.reference);

  @override
  String toString() => "Record<$itemName:$amount>";
}
