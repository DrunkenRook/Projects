import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FirstPage extends StatefulWidget 
{
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> 
{ 
  final TextEditingController controller = TextEditingController();//creates an editable text field

  List<String> fullList = <String>[];//list of all the rules for MTG

  List<String> filteredList = <String>[];//list of filtered rules that included the text in the search bar

  bool loading = true;//boolean to indicate if the search is still loading

  @override 
  void initState() 
  {
    super.initState();
    filteredList = <String>[];//resets filtered list to empty
    controller.addListener(onSearchChange);//adds listener to the search bar

    loadItemsFromAsset();
  }

  Future<void> loadItemsFromAsset() async //parses the rules from a text file into a list asynchronously
  {
    try {
      final contents = await rootBundle.loadString('assets/comprehensive_rules.txt');//tries to load the text file as a string
      final lines = contents
          .split(RegExp(r'\r?\n'))//splits the lines
          .map((s) => s.trim())//removes blankspace on ends
          .where((s) => s.isNotEmpty)//filters out empty lines
          .toList();//converts the lines left into a list(lines)

      setState(() //updates the state of the widget
      {
        fullList = lines;//sets fullList tp the parsed lines
        filteredList = List<String>.from(fullList);//sets filteredList to fullList
        loading = false;//sets loading indicator to false
      });
    } catch (e) //catches errors
    {
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

  void onSearchChange() //filters the list based on the text in the search bar
  {
    final query = controller.text.trim().toLowerCase();//formats text in search bar
    debugPrint('Search query: $query');//prints text in search bar to console for debugging
    setState(() {
      if (query.isEmpty)
      {
        filteredList = List<String>.from(fullList);//if the search bar is empty filteredList is fullList
      } else {
        filteredList = fullList
            .where((s) => s.toLowerCase().contains(query))//sets filteredList to only the rules that have the text in the search bar
            .toList();
      }
    });
  }

  @override
  void dispose() //getsrid of the controller when the widget is closed
  {
    controller.removeListener(onSearchChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)//regular page building with the above variables and functions added where needed 
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Rulebook', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 38, 38),
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