import 'package:aicp_internship/Task78/pages/businessDetailsPage.dart';
import 'package:flutter/material.dart';

import '../controllers/businessController.dart';
import '../models/business.dart';
import 'addBusinessPage.dart';

class BusinessPage extends StatefulWidget {

  BusinessPage();
  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final BusinessController _businessController = BusinessController();
  List<Business> _businesses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBusinesses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBusinesses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('My Businesses', style: TextStyle(
            fontFamily: 'Modernist',
            fontWeight: FontWeight.w700,
            color: Colors.blue
        )),
        backgroundColor: Colors.cyan[50],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBusinessPage()),
                      );
                    },
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
                    icon: Icon(Icons.add),
                    label: const Text('ADD BUSINESS', style: TextStyle(
                      fontFamily: 'Modernist',
                      fontWeight: FontWeight.w700
                    )),
                  ),
                  SizedBox(height: 30,),
                  _businesses.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _businesses.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BusinessDetailsPage(business: _businesses[index])),
                              );
                            },
                            child: Card(
                              color: Colors.cyan[100],
                              elevation: 14,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BusinessDetailsPage(business: _businesses[index])),
                                    );
                                  },
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              _businesses[index].indexImage,
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.2),
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    _businesses[index].name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:150,
                                            child: ElevatedButton.icon(
                                              onPressed: () => deleteBusiness(_businesses[index].id),
                                              icon: Icon(Icons.delete, color: Colors.red),
                                              label: Text(
                                                "DELETE",
                                                style: TextStyle(color: Colors.red, fontFamily: 'Modernist',
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                side: MaterialStateProperty.all<BorderSide>(
                                                  BorderSide(
                                                    color: Colors.red,
                                                    width: 2,
                                                  ),
                                                ),
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:150,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddBusinessPage(business: _businesses[index],))).then((_) {
                                                  _fetchBusinesses();
                                                });
                                              },
                                              icon: Icon(Icons.update, color: Colors.blue),
                                              label: Text(
                                                "UPDATE",
                                                style: TextStyle(color: Colors.blue, fontFamily: 'Modernist',
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                                side: MaterialStateProperty.all<BorderSide>(
                                                  BorderSide(
                                                    color: Colors.blue,
                                                    width: 2,
                                                  ),
                                                ),
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      );
                  },
                ),
              ): Center(
                  child: Text(
                    'No Business Available',
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Modernist',
                        fontWeight: FontWeight.w700),
                  ),
              ),
              SizedBox(height: 16),
            ],
        ),
      ),
    );
  }

  void deleteBusiness(String id) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this business?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      BusinessController businessController = BusinessController();
      await businessController.deleteBusiness(id).then((_) => _fetchBusinesses());
    }
  }

  Future<void> _fetchBusinesses() async {
    _isLoading = true;
    try {
      List<Business> businesses = await _businessController.getBusinessesOfCurrentUser();
      setState(() {
        _businesses = businesses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load businesses';
      });
    }
  }
}