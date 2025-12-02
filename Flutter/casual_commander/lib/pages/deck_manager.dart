import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Deck 
{
  final String id;
  String name;
  final List<Map<String, dynamic>> cards;

  Deck({required this.id, required this.name, List<Map<String, dynamic>>? cards}) : cards = cards ?? [];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'cards': cards};

  static Deck fromJson(Map<String, dynamic> json) 
  {
    final rawCards = json['cards'] as List<dynamic>? ?? <dynamic>[];
    final cards = rawCards.map<Map<String, dynamic>>((c) => Map<String, dynamic>.from(c as Map)).toList();
    return Deck(id: json['id'] as String, name: json['name'] as String, cards: cards);
  }
}

class DeckManager 
{
  DeckManager._private();
  static final DeckManager instance = DeckManager._private();

  final List<Deck> _decks = [];

  List<Deck> get decks => List.unmodifiable(_decks);

  Future<File> _getFile() async 
  {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}save_data.txt');
  }

  Future<void> loadFromDisk() async 
  {
    try {
      final file = await _getFile();
      if (!await file.exists()) return;
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) return;
      final data = jsonDecode(contents) as List<dynamic>;
      _decks.clear();
      for (final d in data) {
        _decks.add(Deck.fromJson(Map<String, dynamic>.from(d as Map)));
      }
    } 
    catch (e) 
    {
      // ignore errors, leave decks empty
    }
  }

  Future<void> _saveToDisk() async 
  {
    try 
    {
      final file = await _getFile();
      final data = _decks.map((d) => d.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      // ignore
    }
  }

  Deck createDeck(String name) {
    final deck = Deck(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name);
    _decks.add(deck);
    _saveToDisk();
    return deck;
  }

  Deck? getDeckById(String id) 
  {
    try {
      return _decks.firstWhere((d) => d.id == id);
    } 
    catch (e) 
    {
      return null;
    }
  }

  void addCardToDeck(String deckId, Map<String, dynamic> card) 
  {
    final deck = getDeckById(deckId);
    if (deck == null) return;
    deck.cards.add(Map<String, dynamic>.from(card));
    _saveToDisk();
  }

  void removeCardFromDeck(String deckId, int index) 
  {
    final deck = getDeckById(deckId);
    if (deck == null) return;
    if (index >= 0 && index < deck.cards.length) 
    {
      deck.cards.removeAt(index);
      _saveToDisk();
    }
  }
}
