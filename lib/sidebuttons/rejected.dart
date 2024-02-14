import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> driverData;

  RejectedScreen(this.driverData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejected Driver'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            // Display other driver details
            ...driverData.data().entries.map((entry) {
              if (entry.key != 'image' && entry.key != 'status') {
                return ListTile(
                  title: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    entry.value.toString(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                );
              } else {
                return SizedBox.shrink();
              }
            }).toList(),
          ],
        ),
      ),
    );
  }
}
