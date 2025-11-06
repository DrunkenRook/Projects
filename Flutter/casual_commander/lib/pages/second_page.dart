import 'package:flutter/material.dart';
import 'package:mtg/mtg.dart';

class SecondPage extends StatelessWidget 
{
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Card Search', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 38, 38),
      ),
      body: const Center(
        child: Text(
          '--Search bar for cards--',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}