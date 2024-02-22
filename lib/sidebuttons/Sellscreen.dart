import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SellingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selling Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Sell_Vechile_infromation').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Name'),
                          controller: TextEditingController(text: data['Name']),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Phone Number'),
                          controller: TextEditingController(text: data['PhoneNumber']),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'RC Number'),
                          controller: TextEditingController(text: data['R.CNo']),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Vehicle Model'),
                          controller: TextEditingController(text: data['VehicleModel']),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Vehicle No'),
                          controller: TextEditingController(text: data['VehicleNo']),
                        ),
                        SizedBox(height: 8.0),
                        // Check if 'ImageURLs' is not null and is iterable
                        if (data['ImageURLs'] != null && data['ImageURLs'] is Iterable)
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data['ImageURLs'].length,
                              itemBuilder: (context, index) {
                                String imageUrl = data['ImageURLs'][index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ZoomedImagePage(imageUrl: imageUrl),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
class ZoomedImagePage extends StatelessWidget {
  final String imageUrl;

  const ZoomedImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                downloadImage(context, imageUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String downloads = tempDir.path;
      String imageName = imageUrl.split('/').last;
      Dio dio = Dio();
      await dio.download(imageUrl, '$downloads/$imageName');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image downloaded successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download image: $e'),
        ),
      );
    }
  }
}
