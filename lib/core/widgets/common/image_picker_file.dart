import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


Future imagePicker(BuildContext context, {ImageSource? source, bool isMultiImage = false}) async {
  final ImagePicker picker = ImagePicker();
  if (isMultiImage) {
    return picker.pickMultiImage();
  } else {
    return picker.pickImage(
      source: source ?? ImageSource.gallery,
    );
  }
}
