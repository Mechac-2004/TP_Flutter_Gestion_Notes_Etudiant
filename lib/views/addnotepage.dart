import 'package:flutter/material.dart';
import 'package:note_management/database.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;
  final bool isEdit;

  const NoteFormPage({Key? key, this.note, this.isEdit = false}) : super(key: key);

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _auteurController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // Controller pour la description
  String? _selectedCategory;
  List<String> _selectedTags = [];
  final List<String> categories = ["Travail", "Personnel", "Urgent", "Loisir"];
  final List<String> tags = ["Important", "Urgent", "À faire", "Révision"];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.note != null) {
      _titreController.text = widget.note!.titre;
      _auteurController.text = widget.note!.auteur;
      _descriptionController.text = widget.note!.description; // Remplir description si modification
      _selectedCategory = widget.note!.category;
      _selectedTags = widget.note!.tags?.split(", ") ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Modifier une note" : "Ajouter une note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titreController,
                  decoration: const InputDecoration(
                    labelText: "Titre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le titre est requis";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((category) =>
                          DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Catégorie",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  children: tags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _auteurController,
                  decoration: const InputDecoration(
                    labelText: "Auteur",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Nouveau champ pour la description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4, // Permettre plus de lignes pour la description
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newNote = Note(
                        id: widget.isEdit ? widget.note!.id : DateTime.now().millisecondsSinceEpoch, // Nouvelle id si ajout
                        titre: _titreController.text,
                        category: _selectedCategory ?? "Non spécifiée",
                        tags: _selectedTags.join(", "),
                        auteur: _auteurController.text,
                        date: DateTime.now().toIso8601String(),
                        description: _descriptionController.text, // Ajouter description
                      );
                      Navigator.pop(context, newNote);  // Retourne l'objet Note plutôt qu'un Map
                    }
                  },
                  child: Text(widget.isEdit ? "Modifier" : "Ajouter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
