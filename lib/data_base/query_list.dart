

import 'package:dogs/data_base/dataBase.dart';
import 'package:flutter/material.dart';

class QueryList extends StatefulWidget {

  @override
  _QueryListState createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
  List<QueryBase> _queries = [];
  void _loadQueries() async {
    List<Map<String, dynamic>> queryMaps = await DatabaseHelper.getQueries();
    setState(() {
      _queries = queryMaps.map((queryMap) => QueryBase.fromMap(queryMap)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQueries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Queries')),
      body: ListView.builder(
          itemCount: _queries.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_queries[index].query),
            );
          },
      ),
    );
  }
}
