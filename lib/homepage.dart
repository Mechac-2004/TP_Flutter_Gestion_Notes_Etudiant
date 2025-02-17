import 'package:flutter/material.dart';
import 'package:note_management/database.dart';
import 'package:note_management/views/AddTagsPage.dart';
import 'package:note_management/views/addcategoriespage.dart';
import 'package:note_management/views/addnotepage.dart'; // Assurez-vous que ce fichier existe

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocalStorageDatabase _localStorageDatabase;
  String? _selectedCategory;
  List<Category> _categories = [];
  List<Tag> _tags = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _currentPage = 0;  // Page actuelle pour la pagination
  final int _itemsPerPage = 3;  // Nombre d'éléments par page

  @override
  void initState() {
    super.initState();
    _localStorageDatabase = LocalStorageDatabase();  // Initialiser la base de données
    _categories = _localStorageDatabase.loadCategories();  // Charger les catégories
    _tags = _localStorageDatabase.loadTags();  // Charger les tags
  }

  List<Note> _getNotes() {
    return _localStorageDatabase.loadNotes();
  }

  void deleteNote(int id) {
    setState(() {
      _localStorageDatabase.deleteNote(id);
    });
  }

  // Filtrer les notes en fonction de la recherche par mots-clés
  List<Note> _filterNotes(List<Note> notes) {
    return notes.where((note) {
      final titre = note.titre.toLowerCase();
      final description = note.description?.toLowerCase() ?? "";
      final tags = note.tags?.toLowerCase() ?? "";
      final searchQuery = _searchQuery.toLowerCase();
      return titre.contains(searchQuery) || description.contains(searchQuery) || tags.contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Note> notes = _getNotes();
    List<Note> filteredNotes = _filterNotes(notes);

    // Calculer les notes à afficher pour la page actuelle
    List<Note> paginatedNotes = filteredNotes.skip(_currentPage * _itemsPerPage).take(_itemsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              // Action pour ajouter une catégorie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCategoryPage(), // Corrigez le nom de la classe
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tag),
            onPressed: () {
              // Action pour ajouter un tag
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTagPage(), // Corrigez le nom de la classe
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _currentPage = 0;  // Reset à la première page à chaque nouvelle recherche
                });
              },
              decoration: InputDecoration(
                labelText: 'Recherche par mots-clés',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: paginatedNotes.length,
              itemBuilder: (context, index) {
                final note = paginatedNotes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Auteur : ${note.auteur}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(note.titre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text("Catégorie : ${note.category ?? 'Non spécifiée'}"),
                        const SizedBox(height: 8),
                        Text("Description : ${note.description ?? 'Aucune description'}", style: TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Text("Tags : ${note.tags?.isNotEmpty == true ? note.tags : 'Aucun tag'}", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey)),
                        const SizedBox(height: 8),
                        Text("Date : ${note.date}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoteFormPage(note: note, isEdit: true),
                                  ),
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteNote(note.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _currentPage > 0
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
              ),
              Text('Page ${_currentPage + 1}'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _currentPage < (filteredNotes.length / _itemsPerPage).ceil() - 1
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteFormPage(),
            ),
          ).then((newNote) {
            if (newNote != null) {
              setState(() {
                _localStorageDatabase.addNote(newNote);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
