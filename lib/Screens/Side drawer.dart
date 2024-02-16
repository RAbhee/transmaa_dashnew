import 'package:flutter/material.dart';

class SideContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0,
      left: 20.0,
      child: Container(
        width: 200.0,
        height: 620,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.red.shade900,
                thickness: 3,
              ),
              SizedBox(height: 20),
              buildMenuItem(context, 'Loads', Icons.local_shipping, '/loads'),
              SizedBox(height: 10),
              buildMenuItem(context, 'Buy & Sell', Icons.shopping_bag, '/buy_sell'),
              SizedBox(height: 10),
              buildMenuItem(context, 'Finance', Icons.attach_money, '/finance'),
              SizedBox(height: 10),
              buildMenuItem(context, 'Insurance', Icons.security, '/insurance'),
              SizedBox(height: 10),
              buildMenuItem(context, 'Verification', Icons.verified_user, '/verification'),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return Container(
      width: double.infinity, // Ensure the container takes full width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.orange.shade100,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 30,
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500, // Adjusted font weight
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
