import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class InterestedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interested Buyer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/newbgg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Interestedtobuy')
              .snapshots(),
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
                  Map<String, dynamic> data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company: ${data['Company']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 3.0),
                          Text('Customer Name: ${data['CustomerName']}'),
                          Text('Customer Phone Number: ${data['CustomerPhoneNumber']}'),
                          Text('User ID: ${data['UserID']}'),
                          Text('Vehicle Model: ${data['VehicleModel']}'),
                          Text('Year: ${data['Year']}'),
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
                                  return Column(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onHover: (event) {},
                                        child: GestureDetector(
                                          onTap: () {
                                            downloadImage(imageUrl);
                                          },
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Image.network(
                                              imageUrl,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 8.0), // Add space before the text
                          Text(
                            'Click on image to download', // Add your text here
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.blue,
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
      ),
    );
  }

  void downloadImage(String imageUrl) {
    try {
      // Create an anchor element
      html.AnchorElement anchorElement = html.AnchorElement(href: imageUrl);
      // Set download attribute to empty string to trigger download
      anchorElement.download = '';
      // Programmatically click the anchor element to initiate download
      anchorElement.click();
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
}
