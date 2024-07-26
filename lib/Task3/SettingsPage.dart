import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DatabaseHelper.dart';
import 'color_ext.dart';
import 'settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _clearExpressions() async {
    await DatabaseHelper().clearDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History cleared successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: settingsProvider.secondarySwatch,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: settingsProvider.fontSize),
        ),
        backgroundColor: settingsProvider.primarySwatch,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("Clear History", style: TextStyle(
                fontSize: settingsProvider.fontSize
            ),),
            leading: Icon(Icons.clear),
            onTap: _clearExpressions,
            tileColor: Colors.red[100],
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("Themes", style: TextStyle(
                fontSize: settingsProvider.fontSize
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _themeButton(Colors.blue),
                _themeButton(Colors.red),
                _themeButton(Colors.yellow),
                _themeButton(Colors.black),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              "Font Size",
              style: TextStyle(fontSize: settingsProvider.fontSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Slider(
              value: settingsProvider.fontSize,
              min: 10.0,
              max: 30.0,
              divisions: 20,
              label: '${settingsProvider.fontSize.toStringAsFixed(1)}',
              activeColor: settingsProvider.primarySwatch,
              onChanged: (value) {
                settingsProvider.setFontSize(value);
              },

            ),
          ),
        ],
      ),
    );
  }

  void updatePrimaryColor(BuildContext context, int code) {
    final colorProvider = Provider.of<SettingsProvider>(context, listen: false);

    switch(code) {
      case 10:
        colorProvider.setPrimarySwatch(HexColor.fromHexStr("#000000"));
        colorProvider.setSecondarySwatch(HexColor.fromHexStr("#595959"));
        colorProvider.setTextSwatch(HexColor.fromHexStr("#000000"));
        break;
      case 20:
        colorProvider.setPrimarySwatch(HexColor.fromHexStr("#420d09"));
        colorProvider.setSecondarySwatch(HexColor.fromHexStr("#fa8072"));
        colorProvider.setTextSwatch(HexColor.fromHexStr("#7c0a02"));
        break;
      case 30:
        colorProvider.setPrimarySwatch(HexColor.fromHexStr("#2196F3"));
        colorProvider.setSecondarySwatch(HexColor.fromHexStr("#BBDEFB"));
        colorProvider.setTextSwatch(HexColor.fromHexStr("#2196F3"));
        break;
      case 40:
        colorProvider.setPrimarySwatch(HexColor.fromHexStr("#e47200"));
        colorProvider.setSecondarySwatch(HexColor.fromHexStr("#f1ee8e"));
        colorProvider.setTextSwatch(HexColor.fromHexStr("#000000"));
        break;
    }
  }

  Widget _themeButton(Color color) {
    return InkWell(
      onTap: () => updatePrimaryColor(context, switch(color) {
        Colors.yellow => 40,
        Colors.blue => 30,
        Colors.red => 20,
        Colors.black => 10,
        Color() => throw UnimplementedError(),
      }),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
      ),
    );
  }
}
