import 'package:aicp_internship/Task78/pages/catgeoryBusinessPage.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedCategory;
  String? selectedPopularity;
  String? selectedLocation;
  String? selectedSubCategory;

  final Map<String, List<String>> categories = {
    'Food': ['Desi', 'Chinese', 'Sweets', 'Ice Cream', 'Fast Food', 'Coffee Shops'],
    'Healthcare': ['Clinics', 'Hospitals', 'Laboratories', 'Specialists', 'Blood Banks'],
    'Hotels': [],
    'Education': ['Schools', 'Colleges', 'Universities'],
  };

  final List<String> popularities = ['Popular', 'Regular'];
  final List<String> locations = ['Islamabad', 'Rawalpindi'];

  final TextEditingController _textEditingController = TextEditingController();

  List<String> _values = [];
  final Map<String, String> _selected = {};

  List<Widget> chips = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCategory != null) _selected.addAll({'category': selectedCategory!});
    if (selectedSubCategory != null) _selected.addAll({'subCategory': selectedSubCategory!});
    if (selectedPopularity != null) _selected.addAll({'popularity': selectedPopularity!});
    if (selectedLocation != null) _selected.addAll({'location': selectedLocation!});
    // _selected.addAll({'subcategory': selectedSubcategories});

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Chips
              Text(
                'Select Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: categories.keys.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? category : null;
                        selectedSubCategory = "";
                        _updateChips();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Subcategory Chips
              if (selectedCategory != null && categories[selectedCategory]!.isNotEmpty)
                Text(
                  'Select Subcategory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (selectedCategory != null && categories[selectedCategory]!.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: categories[selectedCategory]!.map((subcategory) {
                    return ChoiceChip(
                      label: Text(subcategory),
                      selected: selectedSubCategory == subcategory,
                      onSelected: (selected) {
                        setState(() {
                          selectedSubCategory = selected ? subcategory : null;
                          _updateChips();
                        });
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 16),

              // Popularity Chips
              Text(
                'Select Popularity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: popularities.map((popularity) {
                  return ChoiceChip(
                    label: Text(popularity),
                    selected: selectedPopularity == popularity,
                    onSelected: (selected) {
                      setState(() {
                        selectedPopularity = selected ? popularity : null;
                        _updateChips();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Location Chips
              Text(
                'Select Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: locations.map((location) {
                  return ChoiceChip(
                    label: Text(location),
                    selected: selectedLocation == location,
                    onSelected: (selected) {
                      setState(() {
                        selectedLocation = selected ? location : null;
                        _updateChips();
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _textEditingController,
                onFieldSubmitted: (value) {
                  _values.add(_textEditingController.text);
                  // _selected.add(true);
                  _textEditingController.clear();

                  setState(() {
                    _values = _values;
                    // _selected = _selected;
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  // ignore: prefer_is_empty
                  prefixIcon: _selected.length < 1
                      ? null
                      : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: _selected.values.map(
                            (value) {
                          return Chip(
                            avatar: const FlutterLogo(),
                            elevation: 0,
                            shadowColor: Colors.teal,
                            label: Text(value, style: TextStyle(color: Colors.blue[900])),
                            onDeleted: () {
                              setState(() {
                                _selected.remove(_selected.entries.firstWhere((entry) => entry.value == value).key);
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),

                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 30,
                margin: const EdgeInsets.all(10),
                child: buildChips(),
              ),
              ElevatedButton(
                onPressed: _search,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[400]!),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
                child: Text('SEARCH'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search(){
    Map<String, String?> queryParams = {
      "category": selectedCategory,
      "subCategory": selectedSubCategory,
      "popularity" : selectedPopularity,
      "location" : selectedLocation,
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryBusinessPage(queryParams: queryParams,)),
    );
  }

  void _updateChips() {
    // Currently not used for SimpleChipsInput, but can be used to handle changes
  }

  Widget buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        // selected: _selected[i],
        label: Text(_values[i]),
        avatar: const FlutterLogo(),
        elevation: 0,
        pressElevation: 0,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            // if (!_selected.contains(_values[i])) _selected.add(_values[i]);
            // _textEditingController.text = _values[i];
            // _selected[i] = !_selected[i];
          });
          // print(_textEditingController.text);
        },
        onDeleted: () {
          _values.removeAt(i);
          // _selected.removeAt(i);

          setState(() {
            _values = _values;
            // _selected = _selected;
          });
        },
      );

      chips.add(actionChip);
    }

    return ListView(
      // This line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }
}
