import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Finance').snapshots(),
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
                          controller: TextEditingController(text: data['name']),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Phone Number'),
                          controller: TextEditingController(text: data['phoneNumber']),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'RC Number'),
                          controller: TextEditingController(text: data['rcNumber']),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(labelText: 'Vehicle Type'),
                          controller: TextEditingController(text: data['vehicleType']),
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
