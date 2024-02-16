import 'dart:async';

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
  WidgetsFlutterBinding.ensureInitialized();
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
        '/delivered_orders': (context) => DeliveredOrdersScreen(),
        '/cancelled_orders': (context) => CancelledOrdersScreen(),
        '/waiting_orders': (context) => WaitingordersScreen(),
        '/driver_waiting': (context) => DriverwaitingScreen(),
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
  late PageController _pageController;
  int _currentIndex = 0;

  // Define a timer variable
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize the timer to auto-slide the images
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < 2) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      // Animate to the next page
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SideContainer(),
          Positioned(
            top: 20.0,
            left: 250.0,
            right: 20.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 150.0,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 30.0,
                      ),
                      SizedBox(width: 50.0),
                      Icon(
                        Icons.account_circle,
                        size: 30.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130.0,
            left: 950.0,
            right: 20.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              height: 510,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Orders",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 3,
                          color: Colors.red.shade900,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                          context,
                          Icons.check_circle_outline,
                          Colors.green.shade900,
                          "Delivered orders",
                          '/delivered_orders'),
                      _buildButton(
                          context,
                          Icons.access_time,
                          Colors.blue.shade900,
                          "Order's Waiting",
                          '/waiting_orders'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                          context,
                          Icons.assignment_turned_in_outlined,
                          Colors.purple.shade900,
                          "Confirmed orders",
                          '/confirmed_orders'),
                      _buildButton(
                          context,
                          Icons.cancel_outlined,
                          Colors.red.shade900,
                          "Cancelled orders",
                          '/cancelled_orders'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                          context,
                          Icons.directions_car_outlined,
                          Colors.orange.shade900,
                          "Driver Confirmation",
                          '/driver_waiting'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 130.0,
            left: 250.0,
            right: 450.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              height: 510,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.fire_truck_sharp,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Move Anything,Anytime,Anywhere....",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          // Wrap the Image.asset with ClipRRect to apply border radius.
                          borderRadius: BorderRadius.circular(20.0),
                          // Define the border radius.
                          child: Image.asset(
                            'assets/images/image$index.jpg',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        width: _currentIndex == index ? 25.0 : 15.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                          color: _currentIndex == index
                              ? Colors.orange.shade500
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildButton(BuildContext context, IconData icon, Color color,
    String label, String route) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, route);
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Colors.white54),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
