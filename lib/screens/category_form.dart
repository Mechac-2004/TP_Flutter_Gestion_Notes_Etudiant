import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  final Function(String) onCategoryAdded;

  const CategoryForm({Key? key, required this.onCategoryAdded}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final TextEditingController _nameController = TextEditingController();

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      widget.onCategoryAdded(name);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nom de la catégorie',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Ajouter Catégorie'),
          ),
        ],
      ),
    );
  }
}