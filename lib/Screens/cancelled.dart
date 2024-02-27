import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledOrdersScreen extends StatefulWidget {
  @override
  _CancelledOrdersScreenState createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends State<CancelledOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelled Orders'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/newbgg.jpg"), // Provide your image path here
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
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
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE3E2E2),
                        Color(0xFAFFF9EE),
                        Color(0xFFDEDDDD),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: $name', style: TextStyle(color: Colors.black87)),
                      Text('Phone Number: $phoneNumber', style: TextStyle(color: Colors.blue.shade900)),
                      Text('Goods Type: $selectedGoodsType', style: TextStyle(color: Colors.black87)),
                      Text('Date: ${selectedDate.toLocal()}', style: TextStyle(color: Colors.blue.shade900)),
                      Text('Time: $selectedTime', style: TextStyle(color: Colors.black87)),
                      Text('Truck Name: $selectedTruckName', style: TextStyle(color: Colors.blue.shade900)),
                      Text('Truck Price: $selectedTruckPrice', style: TextStyle(color: Colors.black87)),
                      Text('Truck Weight Capacity: $selectedTruckWeightCapacity', style: TextStyle(color: Colors.blue.shade900)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
