import 'package:aicp_internship/Task78/pages/businessDetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../controllers/businessController.dart';
import '../models/business.dart';
import 'addBusinessPage.dart';

class CategoryBusinessPage extends StatefulWidget {
  String category;
  Map<String,String?>? queryParams;

  CategoryBusinessPage({this.category = "Food", this.queryParams});

  @override
  State<CategoryBusinessPage> createState() => _CategoryBusinessPageState();
}

class _CategoryBusinessPageState extends State<CategoryBusinessPage> {
  final BusinessController _businessController = BusinessController();
  List<Business> _businesses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if(widget.queryParams != null)
    _fetchBusinesses(widget.category);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBusinesses(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: widget.queryParams != null ? Text('Search Results', style: TextStyle(
            fontFamily: 'Modernist',
            fontWeight: FontWeight.w700,
            color: Colors.blue
        )): Text('${widget.category}', style: TextStyle(
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
                                                color: Colors.black.withOpacity(0.4),
                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  _businesses[index].name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 24,
                                                    fontFamily: 'Lilac'
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Container(
                      height: MediaQuery.of(context).size.height-220,
                      child: Center(
                          child: Text(
                            'No Business Available!',
                            style: TextStyle(fontSize: 24, color: Colors.grey, fontFamily: 'Modernist',
                                fontWeight: FontWeight.w700),
                          ),
                      ),
                    ),
              ],
        ),
      ),
    );
  }


  Future<void> _fetchBusinesses(String category) async {
    try {
      List<Business> businesses = [];
      if(widget.queryParams != null)
        businesses = await _businessController.getBusinessesBySearchParams(
          category: widget.queryParams?['category'],
          subCategory: widget.queryParams?['subCategory'],
          popularity: widget.queryParams?['popularity'],
          location: widget.queryParams?['location'],
        );
      else
        businesses = await _businessController.getBusinessesBySubCategory(category);

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