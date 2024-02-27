import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriversAcceptedOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers Accepted Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('DriversAcceptedOrders').snapshots(),
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
              var orderData = snapshot.data!.docs[index];
              Map<String, dynamic> order = orderData.data() as Map<String, dynamic>;

              // Extracting fields
              String selectedGoodsType = order['selectedGoodsType'] ?? '';
              String selectedTime = order['selectedTime'] ?? '';
              String fromLocation = order['fromLocation'] ?? '';
              String toLocation = order['toLocation'] ?? '';

              // Handling selectedDate
              Timestamp selectedDateTimestamp = order['selectedDate'] ?? Timestamp.now();
              DateTime selectedDate = selectedDateTimestamp.toDate();

              // Handling selectedTruck
              Map<String, dynamic> selectedTruckData = order['selectedTruck'] ?? {};
              String selectedTruckName = selectedTruckData['name'] ?? '';
              int selectedTruckPrice = selectedTruckData['price'] ?? 0;
              int selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ?? 0;

              // Fetching name and phone number
              String customerName = order['customerName'] ?? ''; // Adjust field name if different in Firestore
              String customerphoneNumber = order['customerphoneNumber'] ?? '';// Adjust field name if different in Firestore
              String driverName = order['driverName'] ?? '';// Adjust field name if different in Firestore
              String driverPhoneNumber = order['driverPhoneNumber'] ?? '';// Adjust field name if different in Firestore

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Name: $customerName',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('customerphoneNumber: $customerphoneNumber',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 2),
                      Text(
                        'Driver Name: $driverName',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Driver Phone Number: $driverPhoneNumber',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 4),
                      Text('Goods Type: $selectedGoodsType'),
                      Text('Date: ${selectedDate.toLocal()}'),
                      Text('Time: $selectedTime'),
                      Text('From: $fromLocation'),
                      Text('To: $toLocation'),
                      SizedBox(height: 8),
                      Text(
                        'Truck Details:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Truck Name: $selectedTruckName'),
                      Text('Truck Price: $selectedTruckPrice'),
                      Text('Truck Weight Capacity: $selectedTruckWeightCapacity'),

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