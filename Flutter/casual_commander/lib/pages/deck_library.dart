import 'package:flutter/material.dart';
import 'deck_manager.dart';
import 'deck_detail.dart';
import 'auth.dart';

class DeckLibrary extends StatefulWidget {
  const DeckLibrary({super.key});

  @override
  State<DeckLibrary> createState() => _DeckLibraryState();
}

class _DeckLibraryState extends State<DeckLibrary> {
  List<Deck> get _decks => DeckManager.instance.decks;

  Future<void> _createDeck() async {
    final controller = TextEditingController();
    final name = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Deck'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Deck name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Create')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      DeckManager.instance.createDeck(name);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Deck Library', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 45, 12, 62),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'User',
            onPressed: () async {
              final changed = await showAuthDialog(context);
              if (changed == true) setState(() {});
            }, // opens auth dialog
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _decks.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('--No Decks--', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 12),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: _decks.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white30),
                itemBuilder: (context, index) 
                {
                  final deck = _decks[index];
                  return ListTile(
                    leading: const Icon(Icons.folder, color: Colors.white),
                    title: Text(deck.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('${deck.cards.length} cards', style: const TextStyle(color: Colors.white70)),
                    onTap: () async 
                    {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeckDetail(deckId: deck.id)),
                      );
                      setState(() {});
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createDeck,
        child: const Icon(Icons.add),
      ),
    );
  }
}