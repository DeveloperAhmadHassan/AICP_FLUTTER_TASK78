import 'package:aicp_internship/Task2/DBService.dart';
import 'package:aicp_internship/Task2/Quote.dart';
import 'package:aicp_internship/Task2/QuoteService.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'FavoritesQuotesScreen.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteService _quoteService = QuoteService();
  Quote? _quote;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  void _fetchQuote() async {
    try {
      Quote quote = await _quoteService.fetchQuote();
      setState(() {
        _quote = quote;
      });
    } catch (e) {
      print('Error fetching quote: $e');
    }
  }

  void _addToFavorites(BuildContext context, String quote, String author) async{
    DBService dbService = DBService();
    int result = await dbService.insertQuote(
      _quote!.quote,
      _quote!.author,
      "happiness",
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: switch (result){
        1 => Text('Quote added to favorites!'),
        0 => Text('Quote already in favorites!'),
        -1 => Text('Error adding Quote to favorites!'),
        int() => throw UnimplementedError(),
      },
      duration: Duration(seconds: 1),
      backgroundColor: switch (result){
        1 => Colors.green,
        0 => Colors.blue,
        -1 => Colors.red,
        int() => throw UnimplementedError(),
      },
    ));
  }

  void _shareQuote(String quote, String author){
    Share.share('${_quote!.quote} - ${_quote!.author}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Quote'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchQuote();
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteQuotesScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _quote == null
            ? CircularProgressIndicator()
            : Container(
          padding: EdgeInsets.all(16),
          child: Card(
            color: Colors.blueGrey,
            elevation: 17,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _quote!.quote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '- ${_quote!.author}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _shareQuote(_quote!.quote, _quote!.author),
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: ()  => _addToFavorites(context, _quote!.quote, _quote!.author),
                    icon: Icon(Icons.favorite),
                    label: Text('Add to Favorites'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
