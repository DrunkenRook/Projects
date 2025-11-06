import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget 
{
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Deck Library', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 38, 38),
      ),
      body: const Center(
        child: Text(
          '--Buttons Leading to Decks--',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}