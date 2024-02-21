import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                        // Check if 'ImageUrls' is not null and is iterable
                        if (data['ImageURLs'] != null && data['ImageURLs'] is Iterable)
                          for (var imageUrl in data['ImageURLs'])
                            Image.network(
                              imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
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
