import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Deck 
{
  final String id; //identifier for specific decks
  String name; //user inpur name for deck
  final List<Map<String, dynamic>> cards; //card list for deck

  Deck({required this.id, required this.name, List<Map<String, dynamic>>? cards}) : cards = cards ?? [];//deck requires id and name but can start with or without cards

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

  // users: email -> { 'password': string, 'decks': List<Map> }
  final Map<String, Map<String, dynamic>> _users = {};

  String? _currentUserEmail;

  List<Deck> get decks => List.unmodifiable(_decks);

  String? get currentUserEmail => _currentUserEmail;

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
      final dynamic decoded = jsonDecode(contents);

      // Support two formats:
      // 1) legacy: file contains a List of decks -> load into _decks (no auth)
      // 2) new: file contains a Map with 'users' and optional 'lastSignedIn'

      _decks.clear();
      _users.clear();

      if (decoded is List) {
        for (final d in decoded) {
          _decks.add(Deck.fromJson(Map<String, dynamic>.from(d as Map)));
        }
        _currentUserEmail = null;
      } else if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        final usersRaw = map['users'] as Map<String, dynamic>? ?? {};
        usersRaw.forEach((email, u) {
          final uMap = Map<String, dynamic>.from(u as Map);
          final pw = uMap['password'] as String? ?? '';
          final decksRaw = uMap['decks'] as List<dynamic>? ?? <dynamic>[];
          _users[email] = {'password': pw, 'decks': decksRaw};
        });

        final last = map['lastSignedIn'] as String?;
        if (last != null && _users.containsKey(last)) {
          _currentUserEmail = last;
          final userDecks = _users[last]!['decks'] as List<dynamic>;
          for (final d in userDecks) {
            _decks.add(Deck.fromJson(Map<String, dynamic>.from(d as Map)));
          }
        }
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
      // persist users structure if available; otherwise persist legacy decks list
      if (_users.isEmpty) {
        final data = _decks.map((d) => d.toJson()).toList();
        await file.writeAsString(jsonEncode(data));
        return;
      }

      final Map<String, dynamic> out = {};
      final Map<String, dynamic> usersOut = {};
      _users.forEach((email, u) {
        usersOut[email] = {
          'password': u['password'],
          'decks': u['decks'],
        };
      });
      out['users'] = usersOut;
      out['lastSignedIn'] = _currentUserEmail;

      await file.writeAsString(jsonEncode(out));
    } catch (e) {
      // ignore
    }
  }

  // Auth API
  Future<bool> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    if (_users.containsKey(email)) return false;
    _users[email] = {'password': password, 'decks': <dynamic>[]};
    _currentUserEmail = email;
    _decks.clear();
    await _saveToDisk();
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    if (!_users.containsKey(email)) return false;
    final u = _users[email]!;
    if (u['password'] != password) return false;
    _currentUserEmail = email;
    _decks.clear();
    final userDecks = u['decks'] as List<dynamic>? ?? <dynamic>[];
    for (final d in userDecks) {
      _decks.add(Deck.fromJson(Map<String, dynamic>.from(d as Map)));
    }
    await _saveToDisk();
    return true;
  }

  Future<void> signOut() async {
    _currentUserEmail = null;
    _decks.clear();
    await _saveToDisk();
  }

  // update stored decks for current user before saving
  void _updateUserDecksBeforeSave() {
    if (_currentUserEmail != null && _users.containsKey(_currentUserEmail)) {
      _users[_currentUserEmail]!['decks'] = _decks.map((d) => d.toJson()).toList();
    }
  }

  Deck createDeck(String name) {
    final deck = Deck(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name);
    _decks.add(deck);
    _updateUserDecksBeforeSave();
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
    _updateUserDecksBeforeSave();
    _saveToDisk();
  }

  void removeCardFromDeck(String deckId, int index) 
  {
    final deck = getDeckById(deckId);
    if (deck == null) return;
    if (index >= 0 && index < deck.cards.length) 
    {
      deck.cards.removeAt(index);
      _updateUserDecksBeforeSave();
      _saveToDisk();
    }
  }
}
