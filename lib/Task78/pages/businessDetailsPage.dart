import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../models/business.dart';
import '../models/user.dart';
import '../controllers/authController.dart';
import '../controllers/businessController.dart';
import '../utils/profilePhoto.dart';

class BusinessDetailsPage extends StatefulWidget {
  final Business business;

  const BusinessDetailsPage({super.key, required this.business});

  @override
  _BusinessDetailsPageState createState() => _BusinessDetailsPageState();
}

class _BusinessDetailsPageState extends State<BusinessDetailsPage> {
  bool _isLoading = true;
  Business? _businessDetails;
  List<String>? allImages;
  AppUser? _businessOwner;
  AppUser? _appUser;
  double _userRating = 0.0;
  TextEditingController _commentController = TextEditingController();
  List<dynamic> _comments = [];
  Timer? _ratingTimer;

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
    _fetchCurrentUser();
  }

  Future<void> _fetchBusinessDetails() async {
    BusinessController businessController = BusinessController();
    AuthController authController = AuthController();
    _businessDetails = await businessController.getBusiness(widget.business.id);
    allImages = [
      _businessDetails!.indexImage,
      ..._businessDetails!.images!.map((image) => image.path).toList(),
    ];
    _businessOwner = await authController.getUserDetailsById(_businessDetails!.uid);
    _comments = _businessDetails!.comments ?? [];
    print(_comments);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchCurrentUser() async {
    AuthController authController = AuthController();
    _appUser = await authController.getUserDetails();
  }

  void _submitComment() async{
    if (_commentController.text.isNotEmpty) {
      Map<String, String> comment = {
        'userName': _appUser?.userName ?? "User",
        'uid': _appUser?.uid ?? "",
        'comment': _commentController.text,
        'date': DateTime.now().toString(),
      };
      setState(() {
        _comments.add(comment);
        _commentController.clear();
      });

      BusinessController businessController = BusinessController();
      await businessController.addComment(_businessDetails!.id, comment);
    }
  }

  void _addRating(double rating){
    BusinessController businessController = BusinessController();
    if (_ratingTimer != null) {
      _ratingTimer!.cancel();
    }

    _ratingTimer = Timer(const Duration(seconds: 5), () {
      businessController.addRating(_businessDetails!.id, {
        'userId': _appUser!.uid,
        'rating': rating,
        'createdAt': Timestamp.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CarouselSlider.builder(
                    itemCount: allImages?.length,
                    itemBuilder: (context, index, realIndex) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              allImages![index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          if (_businessDetails != null &&
                              _businessDetails!.favoriteImageIndex != null &&
                              index == (_businessDetails!.favoriteImageIndex! + 1))
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 30,
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                              child: Text(
                                _businessDetails!.name ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      aspectRatio: 16 / 9,
                      initialPage: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (_businessDetails!.name != null) ...[
                                Text(
                                  _businessDetails!.name,
                                  style: const TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue, fontFamily: 'Modernist',),
                                ),
                              ],
                              if (_businessDetails!.address != null) ...[
                                Text(
                                  '${_businessDetails!.address}',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.blueGrey, fontFamily: 'Lilac',),
                                ),
                              ],
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.blue,),
                          const SizedBox(width: 5,),
                          Text(_businessDetails!.overallRating.toString(), style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Modernist',
                          ))
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Listing Agent',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Modernist',),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ProfilePhoto(
                            size: 60,
                            profileImageUrl:
                            _businessOwner!.profilePicUrl ?? "",
                            noBorder: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 13.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_businessOwner!.userName != null) ...[
                                  Text(
                                    '${_businessOwner!.userName}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      fontFamily: 'Lilac',
                                    ),
                                  ),
                                ],
                                Text(
                                  'Business Owner',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.blueGrey, fontFamily: 'Lilac',),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(100),
                                    color: Colors.blue[100],
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.message,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )),
                              const SizedBox(width: 10),
                              Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(100),
                                      color: Colors.blue[100]),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.phone,
                                        color: Colors.blue,
                                        size: 18,
                                      )
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_businessDetails!.description != null) ...[
                        Card(
                          color: Colors.cyan[50],
                          elevation: 14,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Modernist',),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  _businessDetails!.description ?? "",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    fontFamily: 'Lilac',
                                  ),
                                  textAlign: TextAlign.justify,
                                ) ,
                              ],
                            ),
                          ),
                        )
                      ],
                      const SizedBox(height: 30),
                      const Text(
                        'Rate this Business',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Modernist',),
                      ),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: _businessDetails!.rating ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {
                          _addRating(rating);
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Comments',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Modernist',),
                      ),
                      const SizedBox(height: 8),
                      for (var comment in _comments) ...[
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(comment['userName']),
                          subtitle: Text(comment['comment']),
                          trailing: Text(
                            DateFormat('dd/MM/yyyy').format(DateTime.parse(comment['date'])),
                          ),
                        ),
                        const Divider(),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: "Add a comment",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _submitComment,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
