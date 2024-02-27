import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmaa_dash/sidebuttons/verification.dart'; // Assuming ImageScreen is defined here

class Verifiedscreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verified'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Driver')
            .where('status', isEqualTo: 'Verified')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
              QueryDocumentSnapshot<Map<String, dynamic>> driverData = snapshot.data!.docs[index];
              Map<String, dynamic> driver = driverData.data();
              String imageUrl = driver['image'];
              String name = driver['name'];
              String status = driver['status'];
              String phoneNumber = driver['phone_number']; // Assuming you have phone number in your data

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
                                MaterialPageRoute(builder: (context) => ImageScreen(imageUrl)),
                              );
                            },
                            child: Image.network(
                              imageUrl,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20,),
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
                                  color: status == 'verified' ? Colors.green : status == 'rejected' ? Colors.red : Colors.black,
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
                          if (entry.key != 'image' && entry.key != 'name' && entry.key != 'status' && entry.key != 'phone_number') {
                            return Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(fontSize: 16),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
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
