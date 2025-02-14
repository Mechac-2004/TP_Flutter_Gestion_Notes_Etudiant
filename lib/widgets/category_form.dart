import 'package:flutter/material.dart';
import '../managers/category_manager.dart';
import '../models/category.dart';

class CategoryForm extends StatefulWidget {
  final CategoryManager categoryManager;

  CategoryForm({Key? key, required this.categoryManager}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final TextEditingController _categoryController = TextEditingController();
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialiser la première catégorie sélectionnée si nécessaire
    if (widget.categoryManager.categories.isNotEmpty) {
      _selectedCategory = widget.categoryManager.categories[0];
    }
  }

  void _submitForm() {
    final categoryName = _categoryController.text;
    if (categoryName.isNotEmpty) {
      // Ajouter la nouvelle catégorie à la liste
      widget.categoryManager.addCategory(Category(categoryName));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Catégorie ajoutée : $categoryName'),
      ));

      // Retourner à l'écran principal
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une Catégorie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown pour sélectionner une catégorie existante
            DropdownButton<Category>(
              hint: Text('Sélectionner une catégorie'),
              value: _selectedCategory,
              onChanged: (Category? newCategory) {
                setState(() {
                  _selectedCategory = newCategory;
                });
              },
              items: widget.categoryManager.categories.map<DropdownMenuItem<Category>>((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Champ de texte pour ajouter une nouvelle catégorie
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Nom de la catégorie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
