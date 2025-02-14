import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/tag.dart';

class AddTagScreen extends StatefulWidget {
  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
  final TextEditingController _tagController = TextEditingController();

  Future<void> _addTag() async {
    if (_tagController.text.isNotEmpty) {
      await DatabaseHelper.instance.insertTag(Tag(name: _tagController.text));
      _tagController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un Tag')),
      body: Column(
        children: [
          TextField(
              controller: _tagController,
              decoration: InputDecoration(labelText: 'Nom du tag')),
          ElevatedButton(onPressed: _addTag, child: Text('Ajouter')),
          Expanded(
            child: FutureBuilder<List<Tag>>(
              future: DatabaseHelper.instance.getTags(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!
                      .map((tag) => ListTile(title: Text(tag.name)))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
