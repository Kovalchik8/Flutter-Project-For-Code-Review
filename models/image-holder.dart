import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageHolder {
  Widget appearence;
  bool isReadyToUpload;
  bool hasImage;
  bool asyncCall;
  String asyncText;
  PickedFile? pickedFile;
  String imageUrl;

  ImageHolder(
    this.appearence,
    this.isReadyToUpload,
    this.hasImage, [
    this.asyncCall = false,
    this.asyncText = 'Loading',
    this.pickedFile,
    this.imageUrl = '',
  ]);
}
