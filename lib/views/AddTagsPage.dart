import 'package:flutter/material.dart';
import 'package:note_management/database.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({Key? key}) : super(key: key);

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Tag')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Nom du tag'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTag = Tag(name: _tagController.text, id: DateTime.now().millisecondsSinceEpoch);

                // Ajouter le tag à la base de données
                LocalStorageDatabase().addTag(newTag);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
