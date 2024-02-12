import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Driver').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var driverData = snapshot.data!.docs[index];
              Map<String, dynamic> driver = driverData.data() as Map<String, dynamic>;

              // Get the URL of the image from the Firestore document
              String imageUrl = driver['image'];

              // Create a Card to display driver information
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver ${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Display the image as an icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImageScreen(imageUrl)),
                          );
                        },
                        child: Icon(Icons.image, size: 100),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      // Display driver information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: driver.entries.map((entry) {
                          return Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, size: 30),
                            onPressed: () {
                              // Implement functionality for correct button
                              // You can add logic to mark the driver as verified
                              // For example: FirebaseFirestore.instance.collection('drivers').doc(driverData.id).update({'verified': true});
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close, size: 30),
                            onPressed: () {
                              // Implement functionality for incorrect button
                              // You can add logic to mark the driver as unverified
                              // For example: FirebaseFirestore.instance.collection('drivers').doc(driverData.id).update({'verified': false});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class ImageScreen extends StatelessWidget {
  final String imageUrl;

  ImageScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text('');
          },
        ),
      ),
    );
  }
}

