import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondAdvertisement extends StatefulWidget {
  @override
  _SecondAdvertisementState createState() => _SecondAdvertisementState();
}

class _SecondAdvertisementState extends State<SecondAdvertisement> {
  Uint8List? _image;
  Color saveButtonColor = Colors.transparent;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> _uploadImageToFirestore() async {
    if (_image != null) {
      final Reference storageRef = FirebaseStorage.instance.ref().child('images').child('image_${DateTime.now().millisecondsSinceEpoch}.png');
      await storageRef.putData(_image!);
      String downloadURL = await storageRef.getDownloadURL();
      final CollectionReference discounts = FirebaseFirestore.instance.collection('Discount');
      await discounts.add({
        'ImageURL': downloadURL,
      });
    }
  }

  bool isFieldValid() {
    return _image != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backimage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Upload Discount Image',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: _image != null
                      ? Image.memory(
                    _image!,
                    fit: BoxFit.cover,
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40),
                      SizedBox(height: 8),
                      Text('Upload Image', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (isFieldValid()) {
                    await _uploadImageToFirestore();
                    setState(() {
                      saveButtonColor = Colors.green;
                      _image = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Photo saved successfully'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please select an image to upload.'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return saveButtonColor.withOpacity(0.5);
                      }
                      return saveButtonColor;
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Save Data', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
