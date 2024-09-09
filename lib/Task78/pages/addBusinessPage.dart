import 'package:aicp_internship/Task78/commonWidgets/custom_textfield.dart';
import 'package:aicp_internship/Task78/controllers/businessController.dart';
import 'package:aicp_internship/Task78/models/business.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl_phone_field/intl_phone_field.dart';

class AddBusinessPage extends StatefulWidget {
  Business? business;

  AddBusinessPage({super.key, this.business});

  @override
  _AddBusinessPageState createState() => _AddBusinessPageState();
}

class _AddBusinessPageState extends State<AddBusinessPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  int _currentIndex = 0;
  int? _favoriteImageIndex;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _phoneNumber = "";
  String _phoneCountryCode = "";
  String _phoneCountryISOCode = "";

  bool _isButtonEnabled = true;
  bool _isLoading = true;
  String? _selectedCategory;
  String? _selectedSubcategory;

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";

  final Map<String, List<String>> _subcategories = {
    'Food': ['Desi', 'Chinese', 'Sweets', 'Ice Cream', 'Fast Food', 'Coffee Shops'],
    'Healthcare': ['Clinics', 'Hospitals', 'Laboratories', 'Specialists', 'Blood Banks'],
    'Hotels': [],
    'Education': ['Schools', 'Colleges', 'Universities'],
  };

  @override
  void initState() {
    super.initState();
    _favoriteImageIndex = _selectedImages.isNotEmpty ? 0 : null;

    if (widget.business != null) {
      _getBusiness();
      print(_selectedCategory);
    } else {
      _isLoading = false;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
        if (_favoriteImageIndex == null && _selectedImages.isNotEmpty) {
          _favoriteImageIndex = 0;
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (_currentIndex >= _selectedImages.length) {
        _currentIndex = _selectedImages.length - 1;
      }
      if (_favoriteImageIndex == index) {
        _favoriteImageIndex = _selectedImages.isNotEmpty ? 0 : null;
      }
    });
  }

  void _setFavoriteImage(int index) {
    setState(() {
      _favoriteImageIndex = index;
    });
  }

  void _getBusiness() async {
    BusinessController businessController = BusinessController();

    try {
      Business business = await businessController.getBusiness(widget.business!.id);

      _nameController.text = business.name;
      _addressController.text = business.address ?? '';
      _descriptionController.text = business.description ?? '';

      if (business.phoneNumber != null) {
        _phoneNumber = business.phoneNumber!['phoneNumber'] ?? '';
        _phoneCountryCode = business.phoneNumber!['countryCode'] ?? '';
        _phoneCountryISOCode = business.phoneNumber!['countryISOCode'] ?? '';
        _phoneController.text = _phoneNumber;
      }

      if (business.images != null) {
        _selectedImages.addAll(business.images!);
      }

      _favoriteImageIndex = business.favoriteImageIndex ?? (_selectedImages.isNotEmpty ? 0 : null);

      _selectedCategory = business.category;
      _selectedSubcategory = business.subCategory;

      countryValue = business.country!;
      stateValue = business.state!;
      cityValue = business.city!;

    } catch (e) {
      print('Error fetching business data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: widget.business != null ? Text('Update Business', style: TextStyle(
            fontFamily: 'Modernist',
            fontWeight: FontWeight.w700,
            color: Colors.blue
        )) : Text('Add Business', style: TextStyle(
            fontFamily: 'Modernist',
            fontWeight: FontWeight.w700,
            color: Colors.blue
        )),
      ),
      body: (_isLoading && widget.business != null)
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _selectedImages.isNotEmpty
                          ? Column(
                            children: [
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: widget.business != null
                                    ? Image.network(
                                      _selectedImages[_currentIndex].path,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                      :Image.file(
                                      File(_selectedImages[_currentIndex].path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: IconButton(
                                        icon: Icon(
                                          _favoriteImageIndex == _currentIndex
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: _favoriteImageIndex == _currentIndex
                                              ? Colors.blue
                                              : Colors.black,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          _setFavoriteImage(_currentIndex);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(1),
                                      child: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red, size: 30),
                                        onPressed: () {
                                          _removeImage(_currentIndex);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: _currentIndex > 0
                                    ? () {
                                  setState(() {
                                    _currentIndex--;
                                  });
                                }
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: _currentIndex < _selectedImages.length - 1
                                    ? () {
                                  setState(() {
                                    _currentIndex++;
                                  });
                                }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                          )
                          : const Center(
                              child: Text('No images selected'),
                            ),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: _pickImages,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue[400],
                              padding: EdgeInsets.all(10),
                              shape: CircleBorder(),
                            ),
                            child: Icon(Icons.add, size: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add Images',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lilac'
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      CustomTextfield(
                        const Icon(Icons.drive_file_rename_outline, color: Colors.blue,),
                        "My Business",
                        false,
                        _nameController,
                        validationCallback: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Business Name';
                          }
                          if (value.length < 10) {
                            return 'Please Enter at least 10 characters';
                          }
                          return null;
                        },
                        key: const Key("businessNameTextField")
                      ),
                      const SizedBox(height: 16),

                      CSCPicker(
                        showStates: true,
                        showCities: true,
                        flagState: CountryFlag.ENABLE,
                        layout: Layout.vertical,

                        dropdownDecoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          color: Colors.blue[50],
                          border: Border.all(color: Colors.transparent, width: 8.0),
                        ),

                        disabledDropdownDecoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          color: Colors.grey.shade300,
                          border: Border.all(color: Colors.transparent, width: 8.0)
                        ),

                        countrySearchPlaceholder: "Country",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        countryDropdownLabel: "Country",
                        stateDropdownLabel: "State",
                        cityDropdownLabel: "City",

                        currentCountry: countryValue,
                        currentState: stateValue,
                        currentCity: cityValue,

                        selectedItemStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        dropdownHeadingStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                        dropdownItemStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        dropdownDialogRadius: 10.0,
                        searchBarRadius: 10.0,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value ?? "";
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value ?? "";
                          });
                        },

                        key: const Key("countryCityStateDropDown")
                      ),
                      const SizedBox(height: 16),

                      CustomTextfield(
                        const Icon(Icons.location_city, color: Colors.blue,),
                        "City, Street No.",
                        false,
                        _addressController,
                        validationCallback: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Business Address';
                          }
                          if (!RegExp(r"^[A-Za-z0-9'\.\-\s\,]+$").hasMatch(value)) {
                            return 'Invalid input. Special Characters are not allowed!';
                          }

                          return null;
                        },
                        key: const Key("businessAddressTextField")
                      ),
                      const SizedBox(height: 16),

                      IntlPhoneField(
                        style: TextStyle(
                          fontFamily: 'Modernist'
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        initialCountryCode: widget.business != null ? _phoneCountryISOCode : 'PK',
                        initialValue: widget.business != null ? _phoneNumber : '',
                        onChanged: (phone) {
                          if (kDebugMode) {
                            print(phone.completeNumber);
                          }
                          _phoneController.text = phone.completeNumber;
                          _phoneNumber = phone.number;
                          _phoneCountryCode = phone.countryCode;
                          _phoneCountryISOCode = phone.countryISOCode;
                        },
                        onCountryChanged: (country) {
                        },
                        validator: (value) {
                          if (value == null || value.number == "") {
                            return 'Please Enter a Phone number';
                          } else if (value.number.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        key: const Key("phoneNumberTextField"),
                      ),
                      const SizedBox(height: 16),

                      CustomTextfield(
                        const Icon(Icons.description, color: Colors.blue,),
                        "Please Describe your business a little bit",
                        false,
                        _descriptionController,
                        maxLines: 4,
                        validationCallback: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Business Description';
                          }
                          if (value.length < 10) {
                            return 'Please Enter at least 10 characters';
                          }
                          return null;
                        },
                        key: const Key("businessDescriptionTextField")
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.blue.shade100,
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue[50],
                              hintText: "Category",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 3.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none, // Remove border if not needed
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            value: _selectedCategory,
                            items: _subcategories.keys
                                .map<DropdownMenuItem<String>>((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                                _selectedSubcategory = null; // Reset subcategory
                              });
                            },
                            validator: (value) =>
                            value == null ? 'Please select a category' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.blue.shade100,
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue[50],
                              hintText: "Sub-Category",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 3.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 3.0,
                                ),
                              ),
                            ),
                            value: _selectedSubcategory,
                            items: (_subcategories[_selectedCategory] ?? [])
                                .map<DropdownMenuItem<String>>((String subcategory) {
                              return DropdownMenuItem<String>(
                                value: subcategory,
                                child: Text(subcategory),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubcategory = value;
                              });
                            },
                            validator: (value) {
                              if (_selectedCategory == null) {
                                return 'Please select a category first';
                              } else if (value == null && _subcategories[_selectedCategory]!.isNotEmpty) {
                                return 'Please select a subcategory';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _isButtonEnabled ? widget.business != null ? _updateBusiness : _addBusiness : null,
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
                        icon: Icon(Icons.navigate_next),
                        label: widget.business != null ? const Text('UPDATE BUSINESS') : const Text('ADD BUSINESS'),
                      ),
                    ],
                  ),
                ),
              ),
          ),
    );
  }

  Future<void> _addBusiness() async {
    if (_formKey.currentState!.validate()) {
      if (_phoneNumber.isEmpty) {
        Get.snackbar('Warning', 'Phone Number Cannot be Empty',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellowAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.error,),
        );
        return;
      }

      final loadingDialog = Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: true,
      );

      setState(() {
        _isButtonEnabled = false;
      });
      try {
        BusinessController businessController = BusinessController();

        Map<String, String> phoneDetails = {
          "phoneNumber": _phoneNumber.removeAllWhitespace,
          "countryCode": _phoneCountryCode.removeAllWhitespace,
          "countryISOCode": _phoneCountryISOCode.removeAllWhitespace,
          "completePhoneNumber": _phoneController.text.removeAllWhitespace,
        };

        await businessController.addBusinessDetails(
          name: _nameController.text,
          phone: phoneDetails,
          address: _addressController.text,
          description: _descriptionController.text,
          images: _selectedImages,
          favoriteImageIndex: _favoriteImageIndex ?? 0,
          country: countryValue,
          state: stateValue,
          city: cityValue,
          category: _selectedCategory ?? "Food",
          subCategory: _selectedSubcategory ?? "Desi"
        );

        Get.snackbar('Success', 'Business Added Successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.lightGreenAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.check,),
        );

      } catch (e) {
        Get.snackbar('Failure', 'Error Occurred!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.error,),
        );
        setState(() {
          _isButtonEnabled = true;
        });
      } finally {
        if (loadingDialog != null) {
          Get.back();
        }

        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _updateBusiness() async {
    if (_formKey.currentState!.validate()) {
      if (_phoneNumber.isEmpty) {
        Get.snackbar(
          'Warning',
          'Phone Number Cannot be Empty',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellowAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.warning),
        );
        return;
      }

      final loadingDialog = Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: true,
      );

      setState(() {
        _isButtonEnabled = false;
      });

      try {
        BusinessController businessController = BusinessController();

        Map<String, String> phoneDetails = {
          "phoneNumber": _phoneNumber.removeAllWhitespace,
          "countryCode": _phoneCountryCode.removeAllWhitespace,
          "countryISOCode": _phoneCountryISOCode.removeAllWhitespace,
          "completePhoneNumber": _phoneController.text.removeAllWhitespace,
        };

        print(countryValue);

        await businessController.updateBusinessDetails(
          bid: widget.business!.id,
          name: _nameController.text,
          phone: phoneDetails,
          address: _addressController.text,
          description: _descriptionController.text,
          images: _selectedImages.isNotEmpty ? _selectedImages : null,
          favoriteImageIndex: _favoriteImageIndex,
          country: countryValue,
          state: stateValue,
          city: cityValue,
          category: _selectedCategory ?? "Food",
          subCategory: _selectedSubcategory ?? "Desi"
        );

        Get.snackbar(
          'Success',
          'Business Updated Successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.lightGreenAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.check),
        );

      } catch (e) {
        Get.snackbar(
          'Failure',
          'Error Occurred!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent[100],
          colorText: Colors.black,
          icon: const Icon(Icons.error),
        );
        setState(() {
          _isButtonEnabled = true;
        });
      } finally {
        if (loadingDialog != null) {
          Get.back();
        }

        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

}
