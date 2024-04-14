import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Color generateRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

String generateRandomString() {
  final random = Random();
  final alphanumeric = String.fromCharCodes(
    List.generate(
      10,
      (index) => random.nextInt(33) + 89,
    ),
  );
  return alphanumeric;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(
    base64Decode(base64String),
    fit: BoxFit.fill,
    // // width: 100,
    // height: 100,
  );
}

Future<String> selectImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final imageBytes = await pickedFile.readAsBytes();
    final base64String = base64Encode(imageBytes);
    return base64String;
  }

  return "";
}
