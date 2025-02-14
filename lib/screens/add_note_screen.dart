import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models/note.dart';
import '../models/tag.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  List<Tag> _tags = [];
  List<int> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    _tags = await DatabaseHelper.instance.getTags();
    setState(() {});
  }

  Future<void> _addNote() async {
    if (_noteController.text.isNotEmpty) {
      int noteId = await DatabaseHelper.instance
          .insertNote(Note(content: _noteController.text));
      for (int tagId in _selectedTags) {
        await DatabaseHelper.instance.linkNoteToTag(noteId, tagId);
      }
      _noteController.clear();
      setState(() {
        _selectedTags.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une Note')),
      body: Column(
        children: [
          TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Contenu de la note')),
          ElevatedButton(onPressed: _addNote, child: Text('Ajouter')),
        ],
      ),
    );
  }
}
