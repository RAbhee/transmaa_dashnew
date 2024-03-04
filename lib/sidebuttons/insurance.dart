import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insurance'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Insurance').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Create a list of rows, each containing two list tiles
            List<Widget> rows = [];
            for (int index = 0; index < snapshot.data!.docs.length; index += 2) {
              // Ensure that the second tile exists before adding a row
              if (index + 1 < snapshot.data!.docs.length) {
                rows.add(
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(context, snapshot.data!.docs[index].data()),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: _buildCard(context, snapshot.data!.docs[index + 1].data()),
                      ),
                    ],
                  ),
                );
              } else {
                // Add the last tile if there is only one left
                rows.add(
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(context, snapshot.data!.docs[index].data()),
                      ),
                    ],
                  ),
                );
              }
            }

            // Return a ListView to display the rows
            return ListView(
              children: rows,
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${data['name']}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone Number: ${data['phoneNumber']}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'RC Number: ${data['rcNumber']}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'Vehicle Type: ${data['vehicleType']}',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

