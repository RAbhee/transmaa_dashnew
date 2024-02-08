import 'package:flutter/material.dart';

class CancelledOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // You can replace this list with the data you receive from Firebase if needed
    List<Map<String, dynamic>> cancelledOrders = [
      {
        'selectedGoodsType': 'Type A',
        'selectedDate': DateTime.now(),
        'selectedTime': '10:00 AM',
        'selectedTruck': {
          'name': 'Truck X',
          'price': 100,
          'weightCapacity': 2000,
        },
      },
      // Add more cancelled orders as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelled Orders'),
      ),
      body: ListView.builder(
        itemCount: cancelledOrders.length,
        itemBuilder: (context, index) {
          var order = cancelledOrders[index];

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
      ),
    );
  }
}
