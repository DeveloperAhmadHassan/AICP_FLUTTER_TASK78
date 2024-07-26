import 'dart:collection';

import 'package:aicp_internship/Task3/DatabaseHelper.dart';
import 'package:aicp_internship/Task3/SettingsPage.dart';
import 'package:aicp_internship/Task3/color_ext.dart';
import 'package:aicp_internship/Task3/settings.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';

import 'ExpressionsPage.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';
  String _dummyExp = '';

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == '=') {
        int result = _evaluateExpression(flag: true);
        if (result > 0) {
          String resultType = _result.runtimeType.toString();
          insertToDb(_dummyExp, _expression, resultType);
        }
      } else if (buttonText == 'C') {
        _expression = '';
        _result = '';
      }
      else if (buttonText == '(') {
        if (buttonText == '(') {
          var queue = Queue<String>();
          for (int i = _expression.length - 1; i >= 0; i--) {
            if (RegExp(r'\(').hasMatch(_expression[i])) {
              queue.add(_expression[i]);
            }

            if (RegExp(r'\)').hasMatch(_expression[i])) {
              if(queue.isNotEmpty){
                queue.removeLast();
              }
            }

            if (RegExp(r'\d').hasMatch(_expression[i])) {
              _expression += ')';
              return;
            }
          }

          if (queue.isNotEmpty && queue.last == '(') {
            _expression += ')';
            return;
          }

          if (queue.isEmpty) {
            _expression += '(';
            return;
          }
        }

        _result = '';
      }
      else {
        _expression += buttonText;
        _result = '';
        _evaluateExpression();
      }
    });
  }

  void insertToDb(String expression, String result, String resultType) async {
    try {
      int id = await DatabaseHelper().insertExpression(expression, result, resultType);
      print("inserted id: $id");
    } catch (e) {
      print('Error inserting expression: $e');
    }
  }

  void _onBackPressed() {
    setState(() {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
        _evaluateExpression();
      }
    });
  }

  int _evaluateExpression({bool flag = false}) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _result = eval.toString();

      if (eval == eval.toInt()) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toString();
      }

      if (flag) {
        _dummyExp = _expression;
        _expression = _result;
        _result = '';
      }

      return 1;
    } catch (e) {
      _result = flag ? 'error' : '';
      return 0;
    }
  }

  void _navigateToExpressionsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExpressionsPage(),
    ));
  }

  void _navigateToSettingsPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SettingsPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: colorProvider.primarySwatch,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 100,
              color: colorProvider.secondarySwatch,
              alignment: Alignment.bottomRight,
              child: Text(
                _expression,
                style: TextStyle(fontSize: colorProvider.fontSize + 20, color: colorProvider.textSwatch,),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: colorProvider.secondarySwatch,
            alignment: Alignment.bottomRight,
            child: Text(
              _result,
              style: TextStyle(fontSize: colorProvider.fontSize + 5, color: colorProvider.lightTextSwatch),
            ),
          ),
          Container(
            color: colorProvider.secondarySwatch,
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _navigateToExpressionsPage(context),
                        icon: Icon(
                          Icons.history,
                          color: colorProvider.primarySwatch,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _navigateToSettingsPage(context),
                        icon: Icon(
                          Icons.settings,
                          color: colorProvider.primarySwatch,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () => _onBackPressed(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.backspace_outlined,
                            color: colorProvider.textSwatch,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(height: 5),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: colorProvider.secondarySwatch,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  CalculatorButton(buttonText: 'C', onPressed: _onPressed),
                  CalculatorButton(buttonText: '(', onPressed: _onPressed), // Single button for bracket
                  CalculatorButton(buttonText: '/', onPressed: _onPressed),
                  CalculatorButton(buttonText: '*', onPressed: _onPressed),
                  CalculatorButton(buttonText: '7', onPressed: _onPressed),
                  CalculatorButton(buttonText: '8', onPressed: _onPressed),
                  CalculatorButton(buttonText: '9', onPressed: _onPressed),
                  CalculatorButton(buttonText: '-', onPressed: _onPressed),
                  CalculatorButton(buttonText: '4', onPressed: _onPressed),
                  CalculatorButton(buttonText: '5', onPressed: _onPressed),
                  CalculatorButton(buttonText: '6', onPressed: _onPressed),
                  CalculatorButton(buttonText: '+', onPressed: _onPressed),
                  CalculatorButton(buttonText: '1', onPressed: _onPressed),
                  CalculatorButton(buttonText: '2', onPressed: _onPressed),
                  CalculatorButton(buttonText: '3', onPressed: _onPressed),
                  CalculatorButton(buttonText: '=', onPressed: _onPressed),
                  CalculatorButton(buttonText: '0', onPressed: _onPressed),
                  CalculatorButton(buttonText: '.', onPressed: _onPressed),
                  CalculatorButton(buttonText: '(', onPressed: _onPressed), // Same button for bracket
                  CalculatorButton(buttonText: '+', onPressed: _onPressed),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String buttonText;
  final void Function(String) onPressed;

  const CalculatorButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => onPressed(buttonText),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: colorProvider.textSwatch,
              fontSize: colorProvider.fontSize
            ),
          ),
        ),
      ),
    );
  }
}
