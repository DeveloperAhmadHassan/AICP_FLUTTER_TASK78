import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePhoto extends StatefulWidget {
  ProfilePhoto({
    super.key,
    required this.size,
    this.onTap,
    this.profileImage,
    this.profileImageUrl = "",
    this.noBorder = false,
    this.borderColor = Colors.blue
  });

  final double size;
  final VoidCallback? onTap;
  final bool noBorder;
  XFile? profileImage;
  String? profileImageUrl;
  Color? borderColor;

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  XFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: !widget.noBorder ? Border.all(
              width: 6,
              color: widget.profileImage != null ? widget.borderColor ?? Colors.blue :  widget.borderColor ?? Colors.blue) : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: widget.profileImage != null
              ? Image.file(
            File(widget.profileImage!.path),
            fit: BoxFit.cover,
          )
              : widget.profileImageUrl!.isNotEmpty
              ? Image.network(
            widget.profileImageUrl ?? "",
            fit: BoxFit.cover,
          )
              : Icon(Icons.camera_alt, size: 30),
        )

      ),
    );
  }
}
