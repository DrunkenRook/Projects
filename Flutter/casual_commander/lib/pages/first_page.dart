import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController controller = TextEditingController();

  // Will be populated from an asset text file (one entry per line).
  List<String> fullList = <String>[];

  List<String> filteredList = <String>[];

  // Loading indicator while reading the asset.
  bool loading = true;

  @override
  void initState() {
    super.initState();
    filteredList = <String>[];
    controller.addListener(onSearchChanged);

    _loadItemsFromAsset();
  }

  Future<void> _loadItemsFromAsset() async {
    try {
      final contents = await rootBundle.loadString('assets/comprehensive_rules.txt');
      final lines = contents
          .split(RegExp(r'\r?\n'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      setState(() {
        fullList = lines;
        filteredList = List<String>.from(fullList);
        loading = false;
      });
    } catch (e) {
      // If the asset isn't found or can't be read, fall back to a debug list.
      final debug = <String>[
        'something went wrong loading comprehensive_rules.txt',
      ];
      setState(() {
        fullList = debug;
        filteredList = List<String>.from(fullList);
        loading = false;
      });
    }
  }

  void onSearchChanged() {
    final query = controller.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredList = List<String>.from(fullList);
      } else {
        filteredList = fullList
            .where((s) => s.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    controller.removeListener(onSearchChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Rulebook', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Search field
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Search rules...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            const SizedBox(height: 12.0),

            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredList.isEmpty
                      ? const Center(
                          child: Text(
                            'No results',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) => Divider(color: Colors.grey[800]),
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return ListTile(
                              title: Text(item, style: const TextStyle(color: Colors.white)),
                              tileColor: Colors.transparent,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selected: $item')),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}