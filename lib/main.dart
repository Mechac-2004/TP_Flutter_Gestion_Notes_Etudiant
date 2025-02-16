import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NoteListPage(),
    );
  }
}

// Modèle de données pour une note
class Note {
  final String title;
  final String category;
  final String content;
  final String? tags;
  final DateTime? createdAt;

  Note({
    required this.title,
    required this.category,
    required this.content,
    this.tags,
    this.createdAt,
  });
}

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [
    Note(
      title: 'Mathematiqueet',
      category: 'Cours',
      content: 'les nombres complexes',
      tags: 'les nombres complexes',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Note(
      title: 'Examen de Dart',
      category: 'Examen',
      content: 'les questions et les réponses pour l\'examen.',
      tags: 'Dart, Examen, Préparation',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Note(
      title: 'TP Base de Données SQLite',
      category: 'TP',
      content: 'Mettre en place une base de données SQLite pour stocker les notes.',
      tags: 'SQLite, Base de données, Flutter',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  String searchTerm = '';

  List<Note> get filteredNotes {
    return notes.where((note) {
      return note.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
          note.content.toLowerCase().contains(searchTerm.toLowerCase()) ||
          (note.tags?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false) ||
          note.category.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                notes.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher une note',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Catégorie: ${note.category}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        if (note.tags != null)
                          Text(
                            'Tags: ${note.tags}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        if (note.createdAt != null)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Créé le: ${note.createdAt!.day}/${note.createdAt!.month}/${note.createdAt!.year}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une note',
      ),
    );
  }
}
