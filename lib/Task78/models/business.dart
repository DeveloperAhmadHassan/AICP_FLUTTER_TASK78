import 'package:image_picker/image_picker.dart';

class Business {
  final String id;
  final String uid;
  final String name;
  final String indexImage;
  String? address;
  String? description;
  Map<String, dynamic>? phoneNumber;
  String? countryCode;
  String? countryISOCode;
  List<XFile>? images;
  int? favoriteImageIndex;
  List<dynamic>? comments;
  double? rating;
  double? overallRating;
  String? category;
  String? subCategory;
  String? country;
  String? state;
  String? city;

  Business({
    required this.id,
    required this.uid,
    required this.name,
    required this.indexImage,
    this.address,
    this.description,
    this.phoneNumber,
    this.countryCode,
    this.countryISOCode,
    this.images,
    this.favoriteImageIndex,
    this.comments,
    this.overallRating,
    this.category,
    this.subCategory,
    this.country,
    this.state,
    this.city
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['bid'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      indexImage: json['indexImage'] as String,
      address: json['address'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone'] as Map<String, dynamic>,
      images: (json['images'] as List<dynamic>?)?.map((e) => XFile(e as String)).toList(),
      favoriteImageIndex: json['favoriteImageIndex'] as int?,
      overallRating: json['overallRating'] as double?,
      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      comments: json['comments'] as List<dynamic>?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'address': address,
      'description': description,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'countryISOCode': countryISOCode,
      'images': images?.map((e) => e.path).toList(),
      'favoriteImageIndex': favoriteImageIndex,
      'overallRating': overallRating,
      'category': category,
      'subCategory': subCategory,
      'comments': comments,
      'country': country,
      'state': state,
      'city': city
    };
  }
}
