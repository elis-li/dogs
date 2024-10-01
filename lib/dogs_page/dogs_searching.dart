import 'package:dogs/design/texts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sqflite/sqflite.dart';
import '../data_base/dataBase.dart';

class DogsSearchingPage extends StatelessWidget {
  const DogsSearchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(search),
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
  final FocusNode _focusNode = FocusNode();
  List<QueryBase> _queries = [];
  bool _showSuggestions = false;
  String? _imageUrl;
  bool _isLoading = false;
  late Database _db;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _loadQueries();
        setState(() {
          _showSuggestions = true;
        });
      } else {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }


  void _loadQueries() async {
    _db = await DatabaseHelper.initializeDB();
    List<Map<String, dynamic>> queryMaps = await DatabaseHelper.getQueries();
    setState(() {
      _queries = queryMaps.map((map) => QueryBase.fromMap(map)).toList();
    });
  }


  Future<void> clearQueriesFromDB() async {
      await DatabaseHelper.clearQueries();
      setState(() {
        _queries.clear();
      });
  }

  void _saveQuery() async {
    String queryText = _controller.text;
    if (queryText.isNotEmpty) {
      await DatabaseHelper.insertQuery(queryText);
      _loadQueries();
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
        const SnackBar(content: Text(error1)),
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
            focusNode: _focusNode,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: enter,
              suffixIcon: IconButton(
                onPressed: () {
                  _controller.clear();
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
          Expanded(
            child: Stack(
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: _imageUrl!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const Center(child: Text(error2)),
                if (_showSuggestions && _queries.isNotEmpty)
                  Positioned(
                    top: 0,
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),

                      child: ListView.builder(
                        itemCount: _queries.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 250),

                              child: ElevatedButton(
                                onPressed: () async {
                                  await clearQueriesFromDB();
                                },
                                child: const Text(listButton),
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text(_queries[index].query),
                              onTap: () {
                                _controller.text = _queries[index].query;
                                setState(() {
                                  _showSuggestions = false;
                                });
                              },
                            );
                          }
                        }
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
