
import 'package:flutter/material.dart';


class DogsSearchingPage extends StatelessWidget {
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
      body: Container(color: Colors.brown[300], child: const EnterBreed()),
    );
  }
}

class EnterBreed extends StatefulWidget{
  const EnterBreed({super.key});

  @override
  State<EnterBreed> createState() => _EnterBreedState();
}

class _EnterBreedState extends State<EnterBreed> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,
            vertical: 20),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter a dog breed to search',
              suffixIcon: IconButton(
                  onPressed: (){
                    _controller.clear();
                  },
                  icon: const Icon(Icons.clear))
            ),
          ),
        ),
      ],
    );
  }
}


