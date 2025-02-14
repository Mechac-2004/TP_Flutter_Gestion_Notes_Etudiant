// lib/managers/category_manager.dart
import '../models/category.dart';

class CategoryManager {
  List<Category> categories = [
    Category('Mathématiques'),
    Category('Physique'),
    Category('Informatique'),
  ];

  // Méthode pour obtenir toutes les catégories
  List<Category> getCategories() {
    return categories;
  }

  // Méthode pour ajouter une nouvelle catégorie
  void addCategory(Category category) {
    categories.add(category);
  }
}
