import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_tag_screen.dart';
import 'screens/add_note_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Notes & Tags',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/addTag': (context) => AddTagScreen(),
        '/addNote': (context) => AddNoteScreen(),
      },
    );
  }
}
