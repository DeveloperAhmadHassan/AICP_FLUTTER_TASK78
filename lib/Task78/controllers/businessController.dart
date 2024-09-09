import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/business.dart';

class BusinessController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addBusinessDetails({
    required String name,
    required Map<String, String> phone,
    required String address,
    required String description,
    required List<XFile> images,
    required int favoriteImageIndex,
    required String country,
    required String state,
    required String city,
    required String category,
    required String subCategory
  }) async {
    try {
      DocumentReference businessDocRef = await _firestore.collection(
          'businesses').add({
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'owner_email': FirebaseAuth.instance.currentUser?.email,
        'bid': '',
        'name': name,
        'phone': {
          'phoneNumber': phone['phoneNumber'],
          'countryCode': phone['countryCode'],
          'countryISOCode': phone['countryISOCode'],
          'completePhoneNumber': phone['completePhoneNumber']
        },
        'address': address,
        'description': description,
        'images': [],
        'indexImage': '',
        'createdAt': FieldValue.serverTimestamp(),
        'category': category,
        'subCategory': subCategory,
        'country': country,
        'state': state,
        'city': city
      });

      String bid = businessDocRef.id;

      List<String> imageUrls = [];
      for (XFile image in images) {
        String imageUrl = await _uploadImageToStorage(image, bid);
        imageUrls.add(imageUrl);
      }

      String favoriteImageUrl = await _uploadImageToStorage(
          images[favoriteImageIndex], bid);

      await businessDocRef.update({
        'bid': bid,
        'images': imageUrls,
        'indexImage': favoriteImageUrl,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<Business>> getBusinessesOfCurrentUser() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception('User is not authenticated');
      }

      QuerySnapshot snapshot = await _firestore.collection('businesses')
          .where('uid', isEqualTo: uid)
          .get();

      List<Business> businesses = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Business(
          id: doc.id,
          uid: data['uid'] as String,
          name: data['name'] as String,
          indexImage: data['indexImage'] as String,
        );
      }).toList();

      return businesses;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching businesses: $e');
      }
      throw Exception('Failed to load businesses');
    }
  }

  Future<List<Business>> getBusinessesBySubCategory(String subCategory) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception('User is not authenticated');
      }

      QuerySnapshot snapshot = await _firestore.collection('businesses')
          .where('subCategory', isEqualTo: subCategory)
          .get();

      List<Business> businesses = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Business(
          id: doc.id,
          uid: data['uid'] as String,
          name: data['name'] as String,
          indexImage: data['indexImage'] as String,
        );
      }).toList();

      return businesses;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching businesses: $e');
      }
      throw Exception('Failed to load businesses');
    }
  }

  Future<List<Business>> getBusinessesBySearchParams({
    String? category,
    String? subCategory,
    String? popularity,
    String? location,
  }) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        throw Exception('User is not authenticated');
      }

      Query query = _firestore.collection('businesses');

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      if (subCategory != null && subCategory.isNotEmpty) {
        query = query.where('subCategory', isEqualTo: subCategory);
      }
      if (popularity != null && popularity.isNotEmpty) {
        query = query.where('overallRating', isGreaterThanOrEqualTo: 3.0);
      }
      if (location != null && location.isNotEmpty) {
        query = query.where('city', isEqualTo: location);
      }

      QuerySnapshot snapshot = await query.get();

      List<Business> businesses = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Business(
          id: doc.id,
          uid: data['uid'] as String,
          name: data['name'] as String,
          indexImage: data['indexImage'] as String,
        );
      }).toList();

      return businesses;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching businesses: $e');
      }
      throw Exception('Failed to load businesses');
    }
  }


  Future<Business> getBusiness(String bid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('businesses')
          .doc(bid)
          .get();

      if (doc.exists) {
        // print(doc.data());
        return Business.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception("Business not found");
      }
    } catch (e) {
      throw Exception("Error fetching business: $e");
    }
  }

  Future<String> _uploadImageToStorage(XFile image, String bid) async {
    try {
      if (image.path.startsWith('http://') ||
          image.path.startsWith('https://')) {
        return image.path;
      } else {
        File file = File(image.path);
        if (!file.existsSync()) {
          throw Exception(
              'File does not exist at the specified path: ${file.path}');
        }

        Reference ref = FirebaseStorage.instance.ref().child(
            'business_images/$bid/${path.basename(file.path)}');
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      print('Failed to upload image: ${image.path}');
      print(e);
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> updateBusinessDetails({
    required String bid,
    String? name,
    Map<String, String>? phone,
    String? address,
    String? description,
    List<XFile>? images,
    int? favoriteImageIndex,
    required String country,
    required String state,
    required String city,
    required String category,
    required String subCategory
  }) async {
    try {
      DocumentReference businessDocRef = _firestore.collection('businesses')
          .doc(bid);

      DocumentSnapshot documentSnapshot = await businessDocRef.get();
      if (!documentSnapshot.exists) {
        throw Exception('Business document does not exist');
      }

      List<String> existingImages = List<String>.from(
          documentSnapshot['images'] ?? []);

      Map<String, dynamic> updatedData = {};

      updatedData['category'] = category;
      updatedData['subCategory'] = subCategory;
      updatedData['country'] = country;
      updatedData['state'] = state;
      updatedData['city'] = city;

      if (name != null) updatedData['name'] = name;
      if (phone != null) {
        updatedData['phone'] = {
          'phoneNumber': phone['phoneNumber'],
          'countryCode': phone['countryCode'],
          'countryISOCode': phone['countryISOCode'],
          'completePhoneNumber': phone['completePhoneNumber']
        };
      }
      if (address != null) updatedData['address'] = address;
      if (description != null) updatedData['description'] = description;

      if (images != null && images.isNotEmpty) {
        List<String> newImageUrls = [];

        for (XFile image in images) {
          if (!image.path.startsWith('http://') &&
              !image.path.startsWith('https://')) {
            String imageUrl = await _uploadImageToStorage(image, bid);
            newImageUrls.add(imageUrl);
          } else {
            // newImageUrls.add(image.path);
          }
        }

        List<String> combinedImageUrls = [...existingImages, ...newImageUrls];
        updatedData['images'] = combinedImageUrls;
        updatedData['lastUpdatedAt'] = FieldValue.serverTimestamp();

        if (favoriteImageIndex != null &&
            favoriteImageIndex >= 0 &&
            favoriteImageIndex < combinedImageUrls.length) {
          updatedData['indexImage'] = combinedImageUrls[favoriteImageIndex];
        }
      }

      await businessDocRef.update(updatedData);

      Get.snackbar(
        'Success',
        'Business Updated Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check),
      );
    } catch (e) {
      print("Failed to update business details: $e");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<Business>> getNewBusinesses(DateTime date) async {
    try {
      DateTime startDate = date.subtract(Duration(days: 5));
      DateTime endDate = date;

      QuerySnapshot snapshot = await _firestore.collection('businesses')
          .where(
          'createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      List<Business> businesses = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Business(
            id: doc.id,
            uid: data['uid'] as String,
            name: data['name'] as String,
            indexImage: data['indexImage'] as String,
            overallRating: data['overallRating'],
            address: data['address']
        );
      }).toList();

      return businesses;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching new businesses: $e');
      }
      throw Exception('Failed to load new businesses');
    }
  }

  Future<void> addComment(String businessId,
      Map<String, dynamic> comment) async {
    try {
      await _firestore.collection('businesses').doc(businessId).update({
        'comments': FieldValue.arrayUnion([comment])
      });

      Get.snackbar('Success', 'Comment Added Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check,),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error adding comment: $e');
      }
      Get.snackbar('Error', 'Some Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
      throw Exception('Failed to add comment');
    }
  }

  Future<void> addRating(String businessId, Map<String, dynamic> rating) async {
    try {
      DocumentSnapshot businessDoc = await _firestore.collection('businesses')
          .doc(businessId)
          .get();

      Map<String, dynamic> businessData = businessDoc.data() as Map<
          String,
          dynamic>;

      List<dynamic> ratings = businessData['ratings'] ?? [];

      ratings.add(rating);

      double totalRating = 0;
      for (var r in ratings) {
        totalRating += (r['rating'] ?? 0.0) as double;
      }
      double averageRating = totalRating / ratings.length;

      await _firestore.collection('businesses').doc(businessId).update({
        'ratings': ratings,
        'overallRating': averageRating,
      });

      Get.snackbar('Success', 'Rating Added Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check,),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error adding rating: $e');
      }
      Get.snackbar('Error', 'Some Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
      throw Exception('Failed to add rating');
    }
  }

  Future<void> deleteBusiness(String businessId) async {
    try {
      DocumentReference businessDocRef = _firestore.collection('businesses')
          .doc(businessId);

      DocumentSnapshot docSnapshot = await businessDocRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Business not found');
      }

      Map<String, dynamic> businessData = docSnapshot.data() as Map<
          String,
          dynamic>;

      List<dynamic> imageUrls = businessData['images'] as List<dynamic>;

      for (String imageUrl in imageUrls) {
        await _deleteImageFromStorage(imageUrl);
      }

      await businessDocRef.delete();

      Get.snackbar('Success', 'Successfully Deleted Business!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreenAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.check,),
      );
    } catch (e) {
      Get.snackbar('Error', 'Some Error Occurred!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent[100],
        colorText: Colors.black,
        icon: const Icon(Icons.error,),
      );
      if (kDebugMode) {
        print('Error deleting business: $e');
      }
      throw Exception('Failed to delete business');
    }
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      if (kDebugMode) {

      }
    }
  }
}


