import 'package:flutter/material.dart';

class DeliveredOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    List<String> deliveredOrders = [
      'Order 1: Delivered on January 1, 2024',
      'Order 2: Delivered on January 2, 2024',
      'Order 3: Delivered on January 3, 2024',
      // Add more order details as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Delivered Orders'),
      ),
      body: ListView.builder(
        itemCount: deliveredOrders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(deliveredOrders[index]),
            // You can customize the ListTile further based on your needs
          );
        },
      ),
    );
  }
}
