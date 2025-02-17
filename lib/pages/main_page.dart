import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Principale"),
      ),
      body: const Center(
        child: Text("Bienvenue sur la page principale !"),
      ),
    );
  }
}