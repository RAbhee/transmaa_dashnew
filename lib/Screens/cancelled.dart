import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelled Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rejected_orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No cancelled orders available'));
          }
          List<Map<String, dynamic>> cancelledOrders = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return {
              'name': data['name'] ?? '',
              'phoneNumber': data['phoneNumber'] ?? '',
              'selectedGoodsType': data['selectedGoodsType'] ?? '',
              'selectedDate': (data['selectedDate'] as Timestamp).toDate() ?? DateTime.now(),
              'selectedTime': data['selectedTime'] ?? '',
              'selectedTruck': data['selectedTruck'] ?? {},
            };
          }).toList();

          return ListView.builder(
            itemCount: cancelledOrders.length,
            itemBuilder: (context, index) {
              var order = cancelledOrders[index];

              String name = order['name'] ?? '';
              String phoneNumber = order['phoneNumber'] ?? '';
              String selectedGoodsType = order['selectedGoodsType'] ?? '';
              DateTime selectedDate = order['selectedDate'] ?? DateTime.now();
              String selectedTime = order['selectedTime'] ?? '';
              Map<String, dynamic> selectedTruckData = order['selectedTruck'] ?? {};
              String selectedTruckName = selectedTruckData['name'] ?? '';
              int selectedTruckPrice = selectedTruckData['price'] ?? 0;
              int selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ?? 0;

              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $name'),
                    Text('Phone Number: $phoneNumber'),
                    Text('Goods Type: $selectedGoodsType'),
                    Text('Date: ${selectedDate.toLocal()}'),
                    Text('Time: $selectedTime'),
                    Text('Truck Name: $selectedTruckName'),
                    Text('Truck Price: $selectedTruckPrice'),
                    Text('Truck Weight Capacity: $selectedTruckWeightCapacity'),
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
