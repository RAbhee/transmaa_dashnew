import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverwaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driverwaiting'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('drivers accepted orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No waiting orders available'));
          }
          List<Map<String, dynamic>> Driverwaiting = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return {
              'fromLocation': data['fromLocation'] ?? '',
              'toLocation': data['toLocation'] ?? '',
              'selectedGoodsType': data['selectedGoodsType'] ?? '',
              'selectedDate': (data['selectedDate'] as Timestamp).toDate() ?? DateTime.now(),
              'selectedTime': data['selectedTime'] ?? '',
              'selectedTruck': data['selectedTruck'] ?? {},
            };
          }).toList();

          return ListView.builder(
            itemCount: Driverwaiting.length,
            itemBuilder: (context, index) {
              var order = Driverwaiting[index];

              String fromLocation = order['fromLocation'] ?? '';
              String toLocation = order['toLocation'] ?? '';
              DateTime selectedDate = order['selectedDate'] ?? DateTime.now();
              String selectedTime = order['selectedTime'] ?? '';
              String selectedGoodsType = order['selectedGoodsType'] ?? '';
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
                    Text('From Location : $fromLocation'),
                    Text('To Location : $toLocation'),
                    Text('Date : ${selectedDate.toLocal()}'),
                    Text('Time : $selectedTime'),
                    Text('Selected Goods Type : $selectedGoodsType'),
                    Text('Truck Name : $selectedTruckName'),
                    Text('Truck Price : $selectedTruckPrice'),
                    Text('Truck Weight Capacity : $selectedTruckWeightCapacity'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Container(
                          ),

                        ), // This expands to fill the space
                        TextButton(
                          onPressed: () {
                            // Add your button action here
                          },
                          child: Text('Button'),
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
