import 'package:flutter/material.dart';

import 'Buyscreen.dart';
import 'Sellscreen.dart'; // Import your next screen file here

class BuynSellScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BuynSell'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/newbgg'
                '.jpg',
            fit: BoxFit.cover,
          ),
          // Centered Logo and Image Row with Animations
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo Animated to the center top
              AnimatedLogo(),
              SizedBox(height: 20),
              // Row of Images with Increased Size and Zoom-In Animation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildImageWithNavigation(context, 'assets/images/Buy.jpg', 200, BuyingScreen()),
                  _buildImageWithNavigation(context, 'assets/images/Sell.jpg', 200, SellingScreen()),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithNavigation(BuildContext context, String imagePath, double size, Widget screen) {
    return GestureDetector(
      onTap: () {
        // Navigate to the corresponding screen when image is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Match the border radius of the container
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}

class AnimatedLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 500),
      curve: Curves.easeInOut,
      top: 20, // Adjust the top position as needed
      left: MediaQuery.of(context).size.width / 2 - 50, // Center horizontally
      child: Image.asset(
        'assets/images/logo.png',
        width: 300, // Adjust the width as needed
      ),
    );
  }
}