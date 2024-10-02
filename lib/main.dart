import 'package:dogs/data_base/query_list.dart';
import 'package:dogs/design/texts.dart';
import 'package:dogs/dogs_page/dogs_searching.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: breedsTitle,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const DogsSearchingPage(),
    );
  }
}

