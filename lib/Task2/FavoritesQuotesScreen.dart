import 'package:flutter/material.dart';

import 'DBService.dart';
import 'Quote.dart';

class FavoriteQuotesScreen extends StatefulWidget {
  FavoriteQuotesScreen({super.key});

  @override
  State<FavoriteQuotesScreen> createState() => _FavoriteQuotesScreenState();
}

class _FavoriteQuotesScreenState extends State<FavoriteQuotesScreen> {
  final DBService _dbService = DBService();
  List<Quote> _quotes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    final quotes = await DBService().getFavoriteQuotes();
    setState(() {
      _quotes = quotes;
    });
  }

  void _confirmDelete(BuildContext context, String quote, String author) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Quote'),
        content: Text('Are you sure you want to delete this quote?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DBService().deleteQuote(quote, author);
              Navigator.of(context).pop();

              _fetchQuotes();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Quote Deleted!'), backgroundColor: Colors.green,),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Quotes'),
        content: Text('Are you sure you want to delete all your Favorite Quotes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DBService().clearDatabase();
              Navigator.of(context).pop();

              _fetchQuotes();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All Quotes Deleted!'), backgroundColor: Colors.green,),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDeleteAll(context);
            },
          ),
        ],
      ),
      body: Expanded(
        child: _quotes.length == 0 ?
          Center(
            child: Text ("NO ITEMS!!!", style: TextStyle(
                fontSize: 45,
                color: Colors.grey
            )),
          ) : ListView.builder(
                itemCount: _quotes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_quotes[index].quote),
                    subtitle: Text('- ${_quotes[index].author}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () =>
                          _confirmDelete(context, _quotes[index].quote,_quotes[index].author),
                    ),
                  );
          },
        )
      )
    );
  }
}

