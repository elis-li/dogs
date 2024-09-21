import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

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

  // Function to fetch the dog breed image from the API
  Future<void> fetchImage(String breed) async {
    setState(() {
      _isLoading = true;  // Start showing the loading spinner
    });

    final response = await http.get(
      Uri.parse('https://dog.ceo/api/breed/$breed/images/random'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _imageUrl = data['message'];  // The image URL is in the 'message' field
      });
    } else {
      setState(() {
        _imageUrl = null;  // No image found for this breed
      });
    }

    setState(() {
      _isLoading = false;  // Hide the loading spinner
    });
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
                  _controller.clear();  // Clear the text field
                },
                icon: const Icon(Icons.clear),
              ),
              prefixIcon: IconButton(
                onPressed: () {
                  fetchImage(_controller.text.toLowerCase());  // Fetch image based on breed
                },
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())  // Show loading spinner while fetching image
              : _imageUrl != null
              ? CachedNetworkImage(
            imageUrl: _imageUrl!,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
              : const Text('No image found'),  // Show this if no image is found
        ],
      ),
    );
  }
}


