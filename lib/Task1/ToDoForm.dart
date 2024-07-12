import 'package:aicp_internship/Task1/DBHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  int? _priority;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _title = widget.todo!['title'] ?? '';
      _description = widget.todo!['description'];
      _priority = widget.todo!['priority'];
      _dueDate = widget.todo!['dueDate'] != null ? DateTime.parse(widget.todo!['dueDate']) : null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                initialValue: _priority?.toString(),
                decoration: InputDecoration(
                  labelText: 'Priority (1-10) *',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a priority';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number < 1 || number > 10) {
                    return 'Please enter a number between 1 and 10';
                  }
                  return null;
                },
                onSaved: (value) {
                  _priority = int.parse(value!);
                },
              ),
              ListTile(
                title: Text('Due Date *'),
                subtitle: Text(_dueDate == null ? 'Select a date' : DateFormat.yMMMd().format(_dueDate!)),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _dueDate) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.todo == null ? _addTodo() : _updateTodo();
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
    await DatabaseHelper().addTodo(
      _title,
      _description,
      _priority!,
      _dueDate!.toIso8601String(),
      DateTime.now().toIso8601String(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo Added!'), backgroundColor: Colors.green,),
    );

    Navigator.of(context).pop();
  }

  void _updateTodo() async {
    await DatabaseHelper().updateTodo(
      widget.todo?["id"],
      _title,
      _description,
      _priority!,
      _dueDate!.toIso8601String(),
      DateTime.now().toIso8601String(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo Updated!'), backgroundColor: Colors.green,),
    );

    Navigator.of(context).pop();
  }
}
