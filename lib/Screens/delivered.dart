import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ordersdelivered extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Delivered Orders'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/newbgg.jpg"), // Provide your image path here
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('DriversAcceptedOrders')
              .where('status', isEqualTo: "Delivered")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              itemCount: (snapshot.data!.docs.length / 2).ceil(), // Limiting to display two cards in one row
              itemBuilder: (context, index) {
                var startIndex = index * 2;
                var endIndex = (index + 1) * 2;
                if (endIndex > snapshot.data!.docs.length) {
                  endIndex = snapshot.data!.docs.length;
                }

                return Row(
                  children: [
                    for (var i = startIndex; i < endIndex; i++)
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Name: ${snapshot.data!.docs[i]['customerName'] ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Builder(
                                  builder: (context) {
                                    try {
                                      return Text(
                                        'Customer Phone Number: ${snapshot.data!.docs[i]['customerphoneNumber']}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      );
                                    } catch (e) {
                                      print('Error accessing customerphoneNumber: $e');
                                      return Text('Customer Phone Number: N/A', style: TextStyle(fontWeight: FontWeight.bold));
                                    }
                                  },
                                ),
                                Text(
                                  'Driver Name: ${snapshot.data!.docs[i]['driverName'] ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Driver Phone Number: ${snapshot.data!.docs[i]['driverPhoneNumber'] ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Status: ${snapshot.data!.docs[i]['status'] ?? 'N/A'}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Goods Type: ${snapshot.data!.docs[i]['selectedGoodsType'] ?? 'N/A'}'),
                                Text('Date: ${snapshot.data!.docs[i]['selectedDate']?.toDate()?.toLocal() ?? 'N/A'}'),
                                Text('Time: ${snapshot.data!.docs[i]['selectedTime'] ?? 'N/A'}'),
                                Text('From: ${snapshot.data!.docs[i]['fromLocation'] ?? 'N/A'}'),
                                Text('To: ${snapshot.data!.docs[i]['toLocation'] ?? 'N/A'}'),
                                SizedBox(height: 2),
                                Text(
                                  'Truck Details:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Truck Name: ${snapshot.data!.docs[i]['selectedTruck']['name'] ?? 'N/A'}'),
                                Text('Truck Price: ${snapshot.data!.docs[i]['selectedTruck']['price'] ?? 'N/A'}'), // Assuming selectedTruckPrice is nullable
                                Text('Truck Weight Capacity: ${snapshot.data!.docs[i]['selectedTruck']['weightCapacity'] ?? 'N/A'}'),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
