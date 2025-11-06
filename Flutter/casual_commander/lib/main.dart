import 'package:flutter/material.dart';
import 'pages/first_page.dart';
import 'pages/second_page.dart';
import 'pages/third_page.dart';

void main() => runApp(const MyApp()); //Tells main to use runApp on MyApp

class MyApp extends StatelessWidget //Initializes MyApp as a StatellessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    const String appTitle = 'Casual Commander';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 40, 38, 38),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget 
{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casual Commander'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Rulebook', style: TextStyle(color: Colors.white)),
              onTap: () 
              {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Card Search', style: TextStyle(color: Colors.white)),
              onTap: () 
              {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Deck Library', style: TextStyle(color: Colors.white)),
              onTap: () 
              {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(//Logo image for home page
              'assets/casual_commander_image.png',  
              width: 300,  
              height: 300,  
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),  
            const Text(
              'Welcome to Casual Commander!',//welcome message for home page
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}