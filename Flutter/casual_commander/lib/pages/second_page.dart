import 'package:flutter/material.dart';
import 'package:mtg/mtg.dart';

class SecondPage extends StatelessWidget 
{
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Card Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
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