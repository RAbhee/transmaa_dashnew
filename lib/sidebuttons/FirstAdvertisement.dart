import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstAdvertisement extends StatefulWidget {
  @override
  _FirstAdvertisementState createState() => _FirstAdvertisementState();
}

class _FirstAdvertisementState extends State<FirstAdvertisement> {
  List<Uint8List?> _images = List.filled(3, null);
  List<String?> _imageUrls = List.filled(3, null);
  Color saveButtonColor = Colors.transparent;

  Future<void> _pickImage(int index) async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _images[index] = imageBytes;
      });
    }
  }

  Future<void> _uploadImagesToFirestore() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('Advertisement');
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}_$i.png');
        await storageRef.putData(_images[i]!);
        String downloadURL = await storageRef.getDownloadURL();
        _imageUrls[i] = downloadURL;
        await users.add({
          'ImageURL': downloadURL,
        });
      }
    }
  }

  Future<void> _fetchImagesFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('Advertisement').get();

    final List<String?> fetchedImageUrls = querySnapshot.docs
        .map<String?>((doc) => doc.data()['ImageURL'] as String?)
        .toList();

    setState(() {
      _imageUrls = fetchedImageUrls;
    });
  }

  bool areFieldsValid() {
    return _images.any((image) => image != null);
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
                'Upload Advertisement Images',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < _images.length; i++)
                    InkWell(
                      onTap: () => _pickImage(i),
                      child: Container(
                        height: 200,
                        width: 250,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: _images[i] != null
                            ? Image.memory(
                          _images[i]!,
                          fit: BoxFit.cover,
                        )
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40),
                            SizedBox(height: 8),
                            Text('Upload Image ${i + 1}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (areFieldsValid()) {
                    await _uploadImagesToFirestore();
                    setState(() {
                      saveButtonColor = Colors.green;
                      _images = List.filled(3, null);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Photos saved successfully'),
                      duration: Duration(seconds: 2),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Please Select at least one image to upload.'),
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
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child:
                  Text('Save Data', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: _imageUrls.isNotEmpty
                      ? GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: _imageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.network(
                            _imageUrls[index]!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                // Delete image from Firestore
                                if (_imageUrls[index] != null) {
                                  await FirebaseFirestore.instance
                                      .collection('Advertisement')
                                      .where('ImageURL',
                                      isEqualTo: _imageUrls[index])
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference.delete();
                                    });
                                  });
                                }

                                // Delete image from UI
                                setState(() {
                                  _imageUrls[index] = null;
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
