import 'package:flutter/material.dart';
import '../managers/category_manager.dart';
import '../widgets/category_form.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryManager _categoryManager = CategoryManager();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestion des Catégories')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Ouvrir le formulaire pour ajouter une catégorie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryForm(categoryManager: _categoryManager),
                ),
              );
            },
            child: Text('Ajouter une Catégorie'),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedCategory,
            hint: Text("Sélectionner une catégorie"),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            items: _categoryManager.getCategories().map((category) {
              return DropdownMenuItem<String>(
                value: category.name,
                child: Text(category.name),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryManager.getCategories().length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_categoryManager.getCategories()[index].name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
