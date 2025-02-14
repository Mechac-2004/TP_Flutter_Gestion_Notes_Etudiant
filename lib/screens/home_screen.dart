import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Accueil - Notes & Tags')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addTag');
              },
              child: Text('Gérer les Tags'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addNote');
              },
              child: Text('Ajouter une Note'),
            ),
          ],
        ),
      ),
    );
  }
}
