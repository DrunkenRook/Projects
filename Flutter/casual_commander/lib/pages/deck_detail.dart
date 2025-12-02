import 'package:flutter/material.dart';
import 'deck_manager.dart';
import 'card_detail.dart';

class DeckDetail extends StatefulWidget 
{
  final String deckId;
  const DeckDetail({super.key, required this.deckId});

  @override
  State<DeckDetail> createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> 
{
  Deck? deck;

  void load() 
  {
    deck = DeckManager.instance.getDeckById(widget.deckId);
  }

  @override
  void initState() 
  {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) 
  {
    load();

    if (deck == null) 
    {
      return Scaffold(
        appBar: AppBar(title: const Text('Deck')), 
        body: const Center(child: Text('Deck not found', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(deck!.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 45, 12, 62),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: deck!.cards.isEmpty
            ? const Center(child: Text('Deck is empty', style: TextStyle(color: Colors.white70)))
            : ListView.separated(
                itemCount: deck!.cards.length,
                separatorBuilder: (_, _) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  final card = deck!.cards[index];
                  final name = (card['name'] ?? 'Unknown').toString();
                  final type = (card['type'] ?? '').toString();
                  final setName = (card['setName'] ?? '').toString();
                  final subtitleParts = <String>[];
                  if (type.isNotEmpty) subtitleParts.add(type);
                  if (setName.isNotEmpty) subtitleParts.add(setName);
                  final subtitle = subtitleParts.join(' • ');

                  return ListTile(
                    title: Text(name, style: const TextStyle(color: Colors.white)),
                    subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.white70)) : null,
                    dense: true,
                    onTap: () 
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardDetail(card: card)),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white70),
                      onPressed: () async 
                      {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove card?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
                            ],
                          ),
                        );

                        if (confirm == true) 
                        {
                          DeckManager.instance.removeCardFromDeck(deck!.id, index);
                          setState(() {});
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
