import 'package:aicp_internship/Task3/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class ExpressionsPage extends StatefulWidget {
  @override
  _ExpressionsPageState createState() => _ExpressionsPageState();
}

class _ExpressionsPageState extends State<ExpressionsPage> {
  List<Map<String, dynamic>> _expressions = [];

  @override
  void initState() {
    super.initState();
    _fetchExpressions();
  }

  Future<void> _fetchExpressions() async {
    List<Map<String, dynamic>> expressions = await DatabaseHelper().fetchAllExpressions();
    setState(() {
      _expressions = expressions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: _expressions.isEmpty
          ? Text("Nothing to Show")
          : ListView.builder(
        itemCount: _expressions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_expressions[index]['expression']),
            subtitle: Text('${_expressions[index]['result']}'),
          );
        },
      ),
    );
  }
}
