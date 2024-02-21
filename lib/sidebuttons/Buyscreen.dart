import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuyingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Selling Screen',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Selling Information'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Sell_Vechile_infromation').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No products available'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var data = doc.data() as Map<String, dynamic>;

                // Extract images array
                List<String>? imageUrls = data['images']?.cast<String>();

                // Handle null case or empty array
                if (imageUrls == null || imageUrls.isEmpty) {
                  return ListTile(
                    title: Text('No images available'),
                  );
                }

                return ListTile(
                  leading: Image.network(
                    imageUrls[0], // Display the first image as the leading image
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data['Name'] ?? 'No Name'),
                  subtitle: Text(data['VehicleModel'] ?? 'No Vehicle Model'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(product: data),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    // Extract images array
    List<String>? imageUrls = product['images']?.cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display all images in a row
            if (imageUrls != null && imageUrls.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrls
                    .map((imageUrl) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ))
                    .toList(),
              ),
            SizedBox(height: 20),
            Text(
              product['Name'] ?? 'No Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              product['VehicleModel'] ?? 'No Vehicle Model',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
