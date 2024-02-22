import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuyScreen extends StatefulWidget {
  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final TextEditingController _textFieldController3 = TextEditingController();
  File? _image; // Variable to store the selected image
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Pick image from gallery

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Update selected image file
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadData() async {
    if (_image == null) {
      print('No image selected.');
      return;
    }

    try {
      String fileName = _image!.path.split('/').last;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      await firebaseStorageRef.putFile(_image!);

      String imageUrl = await firebaseStorageRef.getDownloadURL();

      // Firestore data
      Map<String, dynamic> sellData = {
        'companyName': _textFieldController1.text,
        'modelName': _textFieldController2.text,
        'year': _textFieldController3.text,
        'imageUrl': imageUrl,
      };

      // Add the data to Firestore
      await FirebaseFirestore.instance.collection('sell').add(sellData);

      print('Data and image uploaded successfully.');
    } catch (e) {
      print('Error uploading data and image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textFieldController1,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(
                  labelText: 'Model Name',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textFieldController3,
                decoration: InputDecoration(
                  labelText: 'Year',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Upload Photo'),
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.') // Display this text if no image is selected
                  : Image.file(_image!), // Display selected image if available
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
