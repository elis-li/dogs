import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DogsSearchingPage extends StatelessWidget{
  const DogsSearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dogs breed'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.brown,
      ),
      body: Container(color: Colors.brown[300]),
    );
  }
}