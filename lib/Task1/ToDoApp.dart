import 'package:aicp_internship/Task1/DBHelper.dart';
import 'package:aicp_internship/Task1/ToDoForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Map<String, dynamic>> _todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final todos = await DatabaseHelper().fetchTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _navigateToAddToDoPage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TodoForm(),
    ));
    _fetchTodos();
  }
  void _navigateToUpdateToDoPage(BuildContext context, var todo) async {
    print("App $todo");
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TodoForm(todo: todo),
    ));
    _fetchTodos();
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    return formatter.format(parsedDateTime);
  }
  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete To-Do'),
        content: Text('Are you sure you want to delete this to-do item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper().deleteTodo(id);
              Navigator.of(context).pop();

              _fetchTodos();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Todo Deleted!'), backgroundColor: Colors.green,),
              );
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
  void _toggleCompletionStatus(int id, bool currentStatus) async {
    print("Here");
    await DatabaseHelper().updateCompletionStatus(id, !currentStatus);
    _fetchTodos();
  }

  String _calculateTimeDifference(String createdDateTime, String dueDateTime) {
    final DateTime created = DateTime.parse(createdDateTime);
    final DateTime due = DateTime.parse(dueDateTime);
    final Duration difference = due.difference(created);

    if (difference.isNegative || difference == Duration.zero) {
      return "0";
    }

    final int months = _monthsBetween(created, due);
    if (months > 0) {
      return "$months months";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes";
    } else {
      return "${difference.inSeconds} seconds";
    }
  }

  int _monthsBetween(DateTime start, DateTime end) {
    int yearDifference = end.year - start.year;
    int monthDifference = end.month - start.month;
    return yearDifference * 12 + monthDifference;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => _navigateToAddToDoPage(context),
              label: Text(
                "Add New Item",
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                fixedSize: const Size(190, 43),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: _todos.length == 0 ?
              Center(
                child: Text ("NO ITEMS!!!", style: TextStyle(
                    fontSize: 45,
                    color: Colors.grey
                )),
              ) :
              ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  final bool isCompleted = todo['completed'] == 1;
                  String timeDifference = _calculateTimeDifference(todo['createdDateTime'], todo['dueDateTime']);
                  bool isZeroDuration = timeDifference == "0";
                  return Container(
                    height: 240,
                    child: Card(
                      color: isZeroDuration ? Colors.red[100] : Colors.blueGrey[100],
                      elevation: 7,
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ListTile(
                            title: Text(todo['title'], style: TextStyle(
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                              fontSize: 21
                            )),
                            subtitle: Text(todo['description'] ?? 'No description', style: TextStyle(
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            )),
                            leading: IconButton(
                              icon: Icon(
                                isCompleted
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: isCompleted ? Colors.green : Colors.green,
                              ),
                              onPressed: () =>
                                  _toggleCompletionStatus(todo['id'], isCompleted),
                            ),
                            // trailing: ,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Created: ${_formatDateTime(todo['createdDateTime'])}", style: TextStyle(
                                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900
                                )),
                                Text("Due By: ${_formatDateTime(todo['dueDateTime'])}", style: TextStyle(
                                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900
                                )),
                                Text("Time Left: ${_calculateTimeDifference(todo['createdDateTime'],todo['dueDateTime'])}", style: TextStyle(
                                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900
                                ))
                              ],
                            ),
                          ),
                          Spacer(),
                          Row(
                            children:[
                              Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _confirmDelete(context, todo["id"]),
                                  label: Text(
                                    "Delete",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[200],
                                    fixedSize: const Size(160, 43),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.update,
                                    color: Colors.blue,
                                  ),
                                  onPressed: ()=>_navigateToUpdateToDoPage(context, todo),
                                  label: Text(
                                    "Update",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[200],
                                    fixedSize: const Size(170, 43),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
