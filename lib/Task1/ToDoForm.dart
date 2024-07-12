import 'package:aicp_internship/Task1/DBHelper.dart';
import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  final Map<String, dynamic>? todo;

  const TodoForm({this.todo, super.key});
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _description;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _title = widget.todo!['title'] ?? '';
      _description = widget.todo!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.todo);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                ),
                onSaved: (value) {
                  _description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.todo == null ? _addTodo() : _updateTodo();
                      print('Title: $_title');
                      print('Description: $_description');
                    }
                  },
                  child: Text(widget.todo == null ? 'Add Todo' : 'Update Todo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTodo() async {
    print("Here");
    await DatabaseHelper().addTodo(
      _title,
      _description,
      DateTime.now().toIso8601String(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo Addded!'), backgroundColor: Colors.green,),
    );

    Navigator.of(context).pop();
  }

  void _updateTodo() async {
    await DatabaseHelper().updateTodo(
      widget.todo?["id"],
      _title,
      _description,
      DateTime.now().toIso8601String(),
    );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo Updated!'), backgroundColor: Colors.green,),
      );

      Navigator.of(context).pop();
  }
}