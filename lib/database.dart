import 'dart:convert';
import 'dart:html';  // Importer dart:html pour accéder à localStorage dans Flutter Web

// Classe Note
class Note {
  final int id;
  final String titre;
  final String category;
  final String? tags;
  final String auteur;
  final String date;
  final String description;

  Note({
    required this.id,
    required this.titre,
    required this.category,
    this.tags,
    required this.auteur,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'category': category,
      'tags': tags,
      'auteur': auteur,
      'date': date,
      'description': description,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      titre: map['titre'],
      category: map['category'],
      tags: map['tags'],
      auteur: map['auteur'],
      date: map['date'],
      description: map['description'],
    );
  }
}

// Classe Category
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'], name: map['name']);
  }
}

// Classe Tag
class Tag {
  final int id;
  final String name;

  Tag({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'], name: map['name']);
  }
}

class LocalStorageDatabase {
  static const _notesKey = 'notes';
  static const _categoriesKey = 'categories';  // Clé pour stocker les catégories
  static const _tagsKey = 'tags';  // Clé pour stocker les tags

  // Méthode pour charger les notes
  List<Note> loadNotes() {
    final notesString = window.localStorage[_notesKey];
    if (notesString != null && notesString.isNotEmpty) {
      List<dynamic> notesData = json.decode(notesString);
      return notesData.map((noteData) => Note.fromMap(noteData)).toList();
    }
    return [];
  }

  // Méthode pour ajouter une note
  void addNote(Note note) {
    List<Note> notes = loadNotes();
    notes.add(note);
    _saveNotes(notes);
  }

  // Méthode pour supprimer une note
  void deleteNote(int id) {
    List<Note> notes = loadNotes();
    notes.removeWhere((note) => note.id == id);
    _saveNotes(notes);
  }

  // Sauvegarder les notes
  void _saveNotes(List<Note> notes) {
    final notesString = json.encode(notes.map((note) => note.toMap()).toList());
    window.localStorage[_notesKey] = notesString;
  }

  // Méthode pour charger les catégories
  List<Category> loadCategories() {
    final categoriesString = window.localStorage[_categoriesKey];
    if (categoriesString != null && categoriesString.isNotEmpty) {
      List<dynamic> categoriesData = json.decode(categoriesString);
      return categoriesData.map((categoryData) => Category.fromMap(categoryData)).toList();
    }
    return [];
  }

  // Méthode pour ajouter une catégorie
  void addCategory(Category category) {
    List<Category> categories = loadCategories();
    categories.add(category);
    _saveCategories(categories);
  }

  // Sauvegarder les catégories
  void _saveCategories(List<Category> categories) {
    final categoriesString = json.encode(categories.map((category) => category.toMap()).toList());
    window.localStorage[_categoriesKey] = categoriesString;
  }

  // Méthode pour charger les tags
  List<Tag> loadTags() {
    final tagsString = window.localStorage[_tagsKey];
    if (tagsString != null && tagsString.isNotEmpty) {
      List<dynamic> tagsData = json.decode(tagsString);
      return tagsData.map((tagData) => Tag.fromMap(tagData)).toList();
    }
    return [];
  }

  // Méthode pour ajouter un tag
  void addTag(Tag tag) {
    List<Tag> tags = loadTags();
    tags.add(tag);
    _saveTags(tags);
  }

  // Sauvegarder les tags
  void _saveTags(List<Tag> tags) {
    final tagsString = json.encode(tags.map((tag) => tag.toMap()).toList());
    window.localStorage[_tagsKey] = tagsString;
  }
}
