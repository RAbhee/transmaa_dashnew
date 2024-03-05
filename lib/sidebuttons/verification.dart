import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmaa_dash/sidebuttons/rejected.dart';
import 'package:transmaa_dash/sidebuttons/verified.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.5),
        title: Text('Verification'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Verifiedscreens()),
              );
            },
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 35,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Rejectedscreens()),
              );
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 35,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Driver')
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No data available',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Map<String, dynamic>> driverData =
                  snapshot.data!.docs[index];
              Map<String, dynamic> driver = driverData.data();
              String imageUrl = driver['image'];
              String name = driver['name'];
              String status = driver['status'];
              String phoneNumber = driver[
                  'phone_number']; // Assuming you have phone number in your data

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ImageScreen(imageUrl)),
                              );
                            },
                            child: Image.network(
                              imageUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: $name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Status: $status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: status == 'verified'
                                      ? Colors.green
                                      : status == 'rejected'
                                          ? Colors.red
                                          : Colors.black,
                                ),
                              ),
                              Text(
                                'Phone: $phoneNumber',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(color: Colors.grey),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: driver.entries.map((entry) {
                          if (entry.key != 'image' &&
                              entry.key != 'name' &&
                              entry.key != 'status' &&
                              entry.key != 'phone_number') {
                            return Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(fontSize: 16),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (status.toLowerCase() == 'pending') {
                                // corrected case here
                                FirebaseFirestore.instance
                                    .collection('Driver')
                                    .doc(driverData.id)
                                    .update({'status': 'verified'});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.all(10),
                            ),
                            child: Text(
                              'Verify',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (status.toLowerCase() == 'pending') {
                                // corrected case here
                                FirebaseFirestore.instance
                                    .collection('Driver')
                                    .doc(driverData.id)
                                    .update({'status': 'rejected'});
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: EdgeInsets.all(10),
                            ),
                            child: Text(
                              'Reject',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
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
