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
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
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

              // Create a Container to display driver information
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: driver.entries.map((entry) {
                        return Text('${entry.key}: ${entry.value}');
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            // Implement functionality for correct button
                            // You can add logic to mark the driver as verified
                            // For example: FirebaseFirestore.instance.collection('drivers').doc(driverData.id).update({'verified': true});
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
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
              );
            },
          );
        },
      ),
    );
  }
}
