// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:location/location.dart';
// import 'package:path/path.dart';
// import 'package:flutter/services.dart';
// import 'package:wasteagram/models/food_waste_post.dart';
import 'package:wasteagram/widgets/food_waste_form.dart';

class NewWasteScreen extends StatelessWidget {
  final String title;

  NewWasteScreen({Key key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: NewWasteForm(),
    );
  }
}
