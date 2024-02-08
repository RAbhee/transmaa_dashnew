import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cancelled.dart';

class WaitingordersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('pickup_requests').snapshots(),
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

              // Handling selectedDate
              Timestamp selectedDateTimestamp = order['selectedDate'] ?? Timestamp.now();
              DateTime selectedDate = selectedDateTimestamp.toDate();

              // Handling selectedTruck
              Map<String, dynamic> selectedTruckData = order['selectedTruck'] ?? {};
              String selectedTruckName = selectedTruckData['name'] ?? '';
              int selectedTruckPrice = selectedTruckData['price'] ?? 0;
              int selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ?? 0;

              return Container(
                key: Key(orderData.id), // Use document id as key
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Displaying fields
                    Text('Goods Type: $selectedGoodsType'),
                    Text('Date: ${selectedDate.toLocal()}'), // Displaying formatted date
                    Text('Time: $selectedTime'),
                    // Displaying selectedTruck details
                    Text('Truck Name: $selectedTruckName'),
                    Text('Truck Price: $selectedTruckPrice'),
                    Text('Truck Weight Capacity: $selectedTruckWeightCapacity'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept button press
                            // Store data in a different collection
                            FirebaseFirestore.instance.collection('accepted_orders').add({
                              'selectedGoodsType': selectedGoodsType,
                              'selectedDate': selectedDateTimestamp,
                              'selectedTime': selectedTime,
                              'selectedTruck': selectedTruckData,
                              // You can add more fields if necessary
                            });

                            // Delete the document from pickup_requests collection
                            orderData.reference.delete();
                          },
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CancelledOrdersScreen(),
                              ),
                            );
                          },
                          child: Text('Reject'),
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