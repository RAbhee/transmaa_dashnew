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
              String fromLocation = order['fromLocation'] ?? '';
              String toLocation = order['toLocation'] ?? '';

              // Handling selectedDate
              Timestamp selectedDateTimestamp = order['selectedDate'] ?? Timestamp.now();
              DateTime selectedDate = selectedDateTimestamp.toDate();

              // Handling selectedTruck
              Map<String, dynamic> selectedTruckData = order['selectedTruck'] ?? {};
              String selectedTruckName = selectedTruckData['name'] ?? '';
              int selectedTruckPrice = selectedTruckData['price'] ?? 0;
              String selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ?? '';

              // Fetching name and phone number
              String customerName = order['customerName'] ?? ''; // Adjust field name if different in Firestore
              String customerphoneNumber = order['customerphoneNumber'] ?? ''; // Adjust field name if different in Firestore

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'customerName: $customerName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('customerphoneNumber: $customerphoneNumber'),
                      SizedBox(height: 8),
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
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Handle accept button press
                              // Store data in a different collection
                              FirebaseFirestore.instance.collection('Transmaa_accepted_orders').add({
                                'customerName': customerName, // Assuming 'name' is retrieved from Firestore
                                'customerphoneNumber': customerphoneNumber,
                                'selectedGoodsType': selectedGoodsType,
                                'selectedDate': selectedDateTimestamp,
                                'selectedTime': selectedTime,
                                'selectedTruck': selectedTruckData,
                                'fromLocation': fromLocation,
                                'toLocation': toLocation,
                                // You can add more fields if necessary
                              });

                              // Delete the document from pickup_requests collection
                              orderData.reference.delete();
                            }, style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Change the color here
                          ),
                            child: Text('Accept',style:
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Store rejected data in Firestore
                              FirebaseFirestore.instance.collection('rejected_orders').add({
                                'customerName': customerName, // Assuming 'name' is retrieved from Firestore
                                'customerphoneNumber': customerphoneNumber, // Assuming 'phoneNumber' is retrieved from Firestore
                                'selectedGoodsType': selectedGoodsType,
                                'selectedDate': selectedDateTimestamp,
                                'selectedTime': selectedTime,
                                'selectedTruck': selectedTruckData,
                                'fromLocation': fromLocation,
                                'toLocation': toLocation,
                                // You can add more fields if necessary
                              });


                              // Delete the document from pickup_requests collection
                              orderData.reference.delete();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // Change the color here
                            ),
                            child: Text('Reject',style:
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),),),
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