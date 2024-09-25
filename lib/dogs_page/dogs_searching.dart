import 'package:dogs/data_base/query_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import '../data_base/dataBase.dart';


class DogsSearchingPage extends StatelessWidget {
  const DogsSearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Breed Search'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.brown[300],
        child: const EnterBreed(),
      ),
    );
  }
}

class EnterBreed extends StatefulWidget {
  const EnterBreed({super.key});

  @override
  State<EnterBreed> createState() => _EnterBreedState();
}

class _EnterBreedState extends State<EnterBreed> {
  final TextEditingController _controller = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;

  void _saveQuery() async {
    String queryText = _controller.text;

    if (queryText.isNotEmpty) {
      await DatabaseHelper.insertQuery(queryText);
  }
}

  Future<void> fetchImage(String breed) async {
    setState(() {
      _isLoading = true;
      _imageUrl = null;
    });

    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breed/$breed/images/random'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _imageUrl = data['message'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _imageUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Breed is not found! Plesase try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter a dog breed ',
              suffixIcon: IconButton(
                onPressed: () {
                  _controller.clear();
                  Navigator.push(
                      context,
                      MaterialPageRoute (builder: (context) => QueryList()),
                  );
                },
                icon: const Icon(Icons.clear),
              ),
              prefixIcon: IconButton(
                onPressed: () {
                  fetchImage(_controller.text.toLowerCase());
                  _saveQuery();
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _imageUrl != null
              ? CachedNetworkImage(
            imageUrl: _imageUrl!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : const Text('No image found'),
        ],
      ),
    );
  }
}


