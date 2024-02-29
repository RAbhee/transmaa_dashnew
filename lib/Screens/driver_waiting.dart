import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriversAcceptedOrders extends StatelessWidget {
  Future<void> sendTwilioSMS(String toPhoneNumber, String message) async {
    // Replace these with your Twilio credentials
    final accountSid = 'AC1b534c49fd1202a75b209fd2d6236bbd';
    final authToken = 'b0eb0fa767246e84d778b685b1068962';
    final twilioNumber = '+18648698947';

    final response = await http.post(
      Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': toPhoneNumber,
        'From': twilioNumber,
        'Body': message,
      },
    );

    if (response.statusCode == 201) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${response.body}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers Accepted Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('DriversAcceptedOrders')
            .where('status', isEqualTo: "pending")
            .snapshots(),
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
              Map<String, dynamic> order = orderData.data() as Map<
                  String,
                  dynamic>;

              // Extracting fields
              String selectedGoodsType = order['selectedGoodsType'] ?? '';
              String selectedTime = order['selectedTime'] ?? '';
              String fromLocation = order['fromLocation'] ?? '';
              String toLocation = order['toLocation'] ?? '';

              // Handling selectedDate
              Timestamp selectedDateTimestamp = order['selectedDate'] ??
                  Timestamp.now();
              DateTime selectedDate = selectedDateTimestamp.toDate();

              // Handling selectedTruck
              Map<String, dynamic> selectedTruckData = order['selectedTruck'] ??
                  {};
              String selectedTruckName = selectedTruckData['name'] ?? '';
              int selectedTruckPrice = selectedTruckData['price'] ?? 0;
              int selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ??
                  0;


              // Fetching name and phone number
              String customerName = order['customerName'] ??
                  ''; // Adjust field name if different in Firestore
              String customerphoneNumber = order['customerphoneNumber'] ??
                  ''; // Adjust field name if different in Firestore
              String status = order['status'] ?? 'Pending';
              String driverName = order['driverName'] ??
                  ''; // Adjust field name if different in Firestore
              String driverPhoneNumber = order['driverPhoneNumber'] ??
                  ''; // Adjust field name if different in Firestore

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                            Text('Driver Phone Number: $driverPhoneNumber', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('status: $status', style: TextStyle(fontWeight: FontWeight.bold),),
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
                            Text('Truck Price: ${selectedTruckPrice
                                .toString()}'),
                            Text(
                                'Truck Weight Capacity: ${selectedTruckWeightCapacity
                                    .toString()}'),
                            SizedBox(height: 8),

                          ],
                        ),
                      ),
                      // Add Send Message button
                      ElevatedButton(
                        onPressed: () async {
                          if (status != "Order's to be delivered") {
                            String driverMessage = 'Hi ${order['driverName']}, Your order is confirmed. From: $fromLocation To: $toLocation Date: ${selectedDate.toLocal()}. For more information, please contact Transmaa.';
                            String customerMessage = 'Hi ${order['customerName']}, Your order is confirmed. From: $fromLocation To: $toLocation Date: ${selectedDate.toLocal()}. Your driver is ${order['driverName']}. For more information, please contact Transmaa.';
                            await sendTwilioSMS(order['customerphoneNumber'], customerMessage);
                            await sendTwilioSMS(order['driverPhoneNumber'], driverMessage);

                            FirebaseFirestore.instance.collection('DriversAcceptedOrders').doc(orderData.id).update({
                              'status': "Order's to be delivered"
                            }).then((_) {
                              print('Order status updated successfully.');
                            }).catchError((error) {
                              print('Failed to update order status: $error');
                            });
                          } else {
                            print('Status already updated.');
                          }
                        },
                        child: Text('Send Message'),
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