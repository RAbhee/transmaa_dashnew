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
  List<String?> _imageUrls = [];
  Color saveButtonColor = Colors.transparent;

  Future<void> _fetchImagesFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('Discount').get();

    final List<String?> fetchedImageUrls = querySnapshot.docs
        .map<String?>((doc) => doc.data()['ImageURL'] as String?)
        .toList();

    setState(() {
      _imageUrls = fetchedImageUrls;
    });
  }

  Future<void> _deleteImageFromFirestore(String imageUrl) async {
    await FirebaseFirestore.instance
        .collection('Discount')
        .where('ImageURL', isEqualTo: imageUrl)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchImagesFromFirestore();
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
              ElevatedButton(
                onPressed: () async {
                  // Your logic to pick and upload image (same as before)
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return saveButtonColor.withOpacity(0.5);
                    }
                    return saveButtonColor;
                  }),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Save Data', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: _imageUrls.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.network(
                            _imageUrls[index]!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                // Delete image from Firestore and UI
                                await _deleteImageFromFirestore(_imageUrls[index]!);
                                setState(() {
                                  _imageUrls.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  )
                      : Text('No images fetched'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
