import 'package:flutter/material.dart';
import 'package:note_management/database.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une Catégorie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Nom de la catégorie'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newCategory = Category(name: _categoryController.text, id: DateTime.now().millisecondsSinceEpoch);

                // Ajouter la catégorie à la base de données
                LocalStorageDatabase().addCategory(newCategory);
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
