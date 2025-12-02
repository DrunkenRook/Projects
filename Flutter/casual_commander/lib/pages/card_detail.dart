import 'package:flutter/material.dart';

class CardDetail extends StatelessWidget
{
  final Map<String, dynamic> card;

  const CardDetail
  ({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context)
  {
    final name = card['name'] ?? 'Unknown';
    final type = card['type'] ?? 'Unknown Type';
    final setName = card['setName'] ?? 'Unknown Set';
    final text = card['text'] ?? 'No description available';
    final power = card['power'] ?? '';
    final toughness = card['toughness'] ?? '';
    final manaCost = card['manaCost'] ?? '';
    final rarity = card['rarity'] ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 45, 12, 62),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'User',
            onPressed: () {}, // placeholder for user details
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Name
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Mana Cost
            if (manaCost.isNotEmpty)
              Text(
                'Mana Cost: $manaCost',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            const SizedBox(height: 12),

            // Type
            Text(
              'Type: $type',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Set
            Text(
              'Set: $setName',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Rarity
            if (rarity.isNotEmpty)
              Text(
                'Rarity: $rarity',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            const SizedBox(height: 12),

            // Power/Toughness
            if (power.isNotEmpty || toughness.isNotEmpty)
              Text(
                'Power/Toughness: $power/$toughness',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            const SizedBox(height: 16),

            // Card Description
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),

            // All Details (raw data)
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text(
                'All Details',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: card.entries.map<Widget>((entry) 
                    {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
