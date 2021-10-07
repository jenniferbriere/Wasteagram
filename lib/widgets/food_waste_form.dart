import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
// import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:wasteagram/models/food_waste_post.dart';

class NewWasteForm extends StatefulWidget {
  final String title;

  NewWasteForm({Key key, this.title}) : super(key: key);

  @override
  _NewWasteFormState createState() => _NewWasteFormState();
}

class _NewWasteFormState extends State<NewWasteForm> {
  LocationData locationData;
  var locationService = Location();

  File image;
  final picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final post = FoodWastePost();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    post.latitude = locationData.latitude;
    post.longitude = locationData.longitude;
    setState(() {});
  }

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() async {
      post.imageURL = await ref.getDownloadURL();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
          child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Semantics(
              child: Image.file(image),
              label: 'Selected image of food waste',
            ),
            SizedBox(height: 40),
            Semantics(
              child: numberOfItemsTextField(),
              textField: true,
              label: 'Enter number of items',
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Semantics(
                  child: uploadButton(context),
                  button: true,
                  enabled: true,
                  onTapHint: 'Upload post',
                ),
              ),
            ),
          ],
        ),
      ));
    }
  }

  Widget numberOfItemsTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        autofocus: false,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.headline4,
            hintText: 'Number of items'),
        keyboardType: TextInputType.number,
        onSaved: (value) {
          post.quantity = int.parse(value);
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the number of items';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget uploadButton(BuildContext context) {
    return Container(
        child: IconButton(
          icon: Icon(Icons.cloud_upload),
          iconSize: 100,
          color: Colors.white,
          onPressed: () async {
            if (locationData == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              addDateToFoodWastePost();
              FirebaseFirestore.instance.collection('posts').add({
                'date': post.date,
                'imageURL': post.imageURL,
                'quantity': post.quantity,
                'latitude': post.latitude,
                'longitude': post.longitude,
              });
              Navigator.of(context).pop();
            }
          },
        ),
        color: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 140.0),
        margin: EdgeInsets.all(0.0)
        // width: 1,
        );
  }

  void addDateToFoodWastePost() {
    post.date = DateTime.now();
  }
}
