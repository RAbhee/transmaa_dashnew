import 'package:flutter/material.dart';

class SideContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 0.0,
      child: Container(
        width: 220.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(42, 31, 37, 0.9803921568627451), // Orange with 70% opacity
              Color.fromRGBO(2, 49, 96, 1.0), // Red with 50% opacity
              Color.fromRGBO(108, 57, 4, 1.0), // Red with 30% opacity
              Color.fromRGBO(6, 52, 98, 0.8), // Red with 20% opacity
              Color.fromRGBO(19, 17, 17, 1.0),
              // Orange with 70% opacity
              Color.fromRGBO(2, 49, 96, 1.0),
              Color.fromRGBO(42, 31, 37, 0.9803921568627451), // Red with 10% opacity
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              SizedBox(height: 20),
              buildMenuItem(context, 'Loads', Icons.local_shipping, '/loads'),
              buildMenuItem(context, 'Buy & Sell', Icons.shopping_bag, '/buy_sell'),
              buildMenuItem(context, 'Finance', Icons.attach_money, '/finance'),
              buildMenuItem(context, 'Insurance', Icons.security, '/insurance'),
              buildMenuItem(context, 'Verification', Icons.verified_user, '/verification'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}