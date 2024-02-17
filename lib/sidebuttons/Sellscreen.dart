
import 'package:flutter/material.dart';

void main() {
  runApp(SellingScreen());
}

class SellingScreen extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Product 1', price: 10.99, image: 'assets/product1.jpg'),
    Product(name: 'Product 2', price: 20.49, image: 'assets/product2.jpg'),
    Product(name: 'Product 3', price: 15.99, image: 'assets/product3.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selling Screen',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.asset(
                products[index].image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(products[index].name),
              subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(product: products[index]),
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

class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});
}

class ProductDetails extends StatelessWidget {
  final Product product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              product.image,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
