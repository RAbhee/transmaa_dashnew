import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThirdAdvertisement extends StatefulWidget {
  @override
  _ThirdAdvertisementState createState() => _ThirdAdvertisementState();
}

class _ThirdAdvertisementState extends State<ThirdAdvertisement> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Uint8List? _image;
  Color saveButtonColor = Colors.red;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<String> saveUserDataToFirestore() async {
    final CollectionReference users = FirebaseFirestore.instance.collection('Advertisement');
    final Reference storageRef = FirebaseStorage.instance.ref().child('images').child('image_${DateTime.now().millisecondsSinceEpoch}.png');
    await storageRef.putData(_image!);

    String downloadURL = await storageRef.getDownloadURL();
    await users.add({
      'Name': nameController.text,
      'Description': descriptionController.text,
      'ImageURL': downloadURL,
    });

    return downloadURL;
  }

  bool areFieldsValid() {
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _image != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advertisement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Company'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.memory(
              _image!,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (areFieldsValid()) {
                  await saveUserDataToFirestore();
                  setState(() {
                    saveButtonColor = Colors.green;
                  });
                  nameController.clear();
                  descriptionController.clear();
                  setState(() {
                    _image = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Data saved successfully'),
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields and upload the image.'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return saveButtonColor.withOpacity(0.5);
                  }
                  return saveButtonColor;
                }),
              ),
              child: Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}
