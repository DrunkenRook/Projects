import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardSearch extends StatefulWidget {
  const CardSearch({super.key});

  @override
  State<CardSearch> createState() => CardSearchState();
}

class CardSearchState extends State<CardSearch> {
  final TextEditingController _controller = TextEditingController();
  String storedText = '';
  bool isLoading = false;
  String? error;
  List<dynamic> results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //asynchronusly searches for card input
  Future<void> searchInput() async {
    setState(() {
      storedText = _controller.text;
      isLoading = true;
      error = null;
      results = [];
    });

    try {
      // Replace spaces with underscores for the http request
      final noSpaces = storedText.replaceAll(' ', '_');
      final formatted = Uri.encodeQueryComponent(noSpaces);

      final uri = Uri.parse('https://api.magicthegathering.io/v1/cards?name=$formatted');

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // API returns an object with a 'cards' array
        setState(() {
          results = data['cards'] ?? [];//empty list if no results
        });
      } else {
        setState(() {
          error = 'Request failed: ${response.statusCode}';//error message for failed resuest
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';//variable message for exceptions
      });
    } finally {
      setState(() {
        isLoading = false;//stops loading indicator
      });
    }

  }

  Widget buildResults() {
    if (isLoading) {//indicator for loading state
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {//error message for failed return
      return Center(child: Text(error!, style: const TextStyle(color: Colors.red)));
    }

    if (results.isEmpty) {//message for no matching cards
      return const Center(child: Text('No results', style: TextStyle(color: Colors.white70)));
    }

    // Group results by card name 
    final Map<String, List<Map<String, dynamic>>> grouped = {};//map to group results by name
    for (final item in results) {//iterates through results
      if (item is Map<String, dynamic>) {//checks if item is a map
        final name = (item['name'] ?? 'Unknown').toString();//gets the cards name or sets unknown
        grouped.putIfAbsent(name, () => []).add(item);//adds card to a group based on name
      }
    }

    final groups = grouped.entries.toList();//makes list out of grouped entries

    // builds lists with grouped card results
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final entry = groups[index];
        final name = entry.key;
        final variants = entry.value;

        //adds subtitles to the cards
        if (variants.length == 1) {
          final card = variants.first;
          final subtitleParts = <String>[];
          if ((card['type'] ?? '') != '') subtitleParts.add(card['type']);
          if ((card['setName'] ?? '') != '') subtitleParts.add(card['setName']);
          final subtitle = subtitleParts.join(' • ');//adds subtitles as long as they exist and joins them
          return ListTile(
            title: Text(name, style: const TextStyle(color: Colors.white)),
            subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.white70)) : null,
            dense: true,
          );
        }

        //
        return ExpansionTile(
          title: Text(name, style: const TextStyle(color: Colors.white)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: variants.map<Widget>((card) {
            final type = (card['type'] ?? '').toString();
            final setName = (card['setName'] ?? '').toString();
            final subtitleParts = <String>[];
            if (type.isNotEmpty) subtitleParts.add(type);
            if (setName.isNotEmpty) subtitleParts.add(setName);
            final subtitle = subtitleParts.join(' • ');

            return ListTile(
              title: Text(card['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white)),
              subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.white70)) : null,
              dense: true,
            );
          }).toList(),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Card Search', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 38, 38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter card name',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color.fromARGB(50, 255, 255, 255),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: searchInput,
                    child: const Text('Search'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        storedText = '';
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Searched: $storedText',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              // Results list takes remaining space and is scrollable
              Expanded(child: buildResults()),
            ],
          ),
        ),
    );
  }
}