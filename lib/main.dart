import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transmaa_dash/sidebuttons/buyNsell.dart';
import 'package:transmaa_dash/sidebuttons/finance.dart';
import 'package:transmaa_dash/sidebuttons/insurance.dart';
import 'package:transmaa_dash/sidebuttons/loads.dart';
import 'package:transmaa_dash/sidebuttons/verification.dart';
import 'Screens/Side drawer.dart';
import 'Screens/cancelled.dart';
import 'Screens/delivered.dart';
import 'Screens/driver_waiting.dart';
import 'Screens/waiting.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/loads': (context) => LoadsScreen(),
        '/buy_sell': (context) => BuynSellScreen(),
        '/finance': (context) => FinanceScreen(),
        '/insurance': (context) => InsuranceScreen(),
        '/verification': (context) => VerificationScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Logistics Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool showDeliveredOrders = false;
  bool showCancelledOrders = false;
  bool showWaitingorders = false;
  bool showDriverwaiting = false;

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SideContainer(),
          Positioned(
            top: 0.0,
            left: 80.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showPopup,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120.0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20.0,
            right: 60.0,
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 30.0,
                ),
                SizedBox(width: 10,),
                Text('Admin'),
              ],
            ),
          ),
          Positioned(
            top: 130.0, // Adjust the top position based on your layout
            left: 250.0,
            right: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  Icons.check_circle_outline,
                  Colors.green.shade900,
                  "Delivered orders",
                      () {
                    setState(() {
                      showDeliveredOrders = !showDeliveredOrders;
                      showCancelledOrders = false;
                      showWaitingorders = false;
                      showDriverwaiting = false;
                    });
                  },
                ),
                _buildButton(
                  Icons.access_time,
                  Colors.blue.shade900,
                  "Order's Waiting",
                      () {
                    setState(() {
                      showWaitingorders = !showWaitingorders;
                      showDeliveredOrders = false;
                      showCancelledOrders = false;
                      showDriverwaiting = false;
                    });
                  },
                ),
                _buildButton(
                  Icons.assignment_turned_in_outlined,
                  Colors.purple.shade900,
                  "Confirmed orders",
                      () {
                    // Add your notification button functionality here
                  },
                ),
                _buildButton(
                  Icons.cancel_outlined,
                  Colors.red.shade900,
                  "Cancelled orders",
                      () {
                    setState(() {
                      showCancelledOrders = !showCancelledOrders;
                      showDeliveredOrders = false;
                      showWaitingorders = false;
                      showDriverwaiting = false;
                    });
                  },
                ),
                _buildButton(
                  Icons.directions_car_outlined,
                  Colors.orange.shade900,
                  "Driver Confirmation",
                      () {
                    setState(() {
                      showDriverwaiting = !showDriverwaiting;
                      showDeliveredOrders = false;
                      showWaitingorders = false;
                      showCancelledOrders = false;
                    });
                    // Add your notification button functionality here
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 230.0,
            left: 250.0,
            right: 200.0,
            bottom: 0.0,
            child: Visibility(
              visible: showDeliveredOrders,
              child: DeliveredOrdersScreen(),
            ),
          ),

          Positioned(
            top: 230.0,
            left: 250.0,
            right: 200.0,
            bottom: 0.0,
            child: Visibility(
              visible: showCancelledOrders,
              child: CancelledOrdersScreen(),
            ),
          ),
          Positioned(
            top: 230.0,
            left: 250.0,
            right: 200.0,
            bottom: 0.0,
            child: Visibility(
              visible: showWaitingorders,
              child: WaitingordersScreen(),
            ),
          ),
          Positioned(
            top: 230.0,
            left: 250.0,
            right: 200.0,
            bottom: 0.0,
            child: Visibility(
              visible: showDriverwaiting,
              child: DriverwaitingScreen(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, Color color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange.shade100,
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: color,
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 120.0,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text('Admin'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
