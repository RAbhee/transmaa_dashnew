import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screens/Side drawer.dart';
import 'Screens/cancelled.dart';
import 'Screens/delivered.dart';
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
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Customize the background color
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showDeliveredOrders = !showDeliveredOrders;
                        showCancelledOrders = false;
                        showWaitingorders = false;
                      });

                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/completed.png',
                          height: 50,
                          width: 60,// Replace with your image path
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Delivered orders",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87
                          ),
                        )
                      ],

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showWaitingorders = !showWaitingorders;
                        showDeliveredOrders = false;
                        showCancelledOrders = false;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/waiti.png',
                          height: 50,
                          width: 60,// Replace with your image path
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Order's Waiting",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87
                          ),
                        )
                      ],

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your notification button functionality here
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/confirmed.png',
                          height: 50,
                          width: 60,// Replace with your image path
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Confirmed orders",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87
                          ),
                        )
                      ],

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showCancelledOrders = !showCancelledOrders;
                        showDeliveredOrders = false; // Hide Delivered Orders screen
                        showWaitingorders = false; // Hide Delivered Orders screen
                      });

                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/cancell.png',
                          height: 50,
                          width: 60,// Replace with your image path
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Cancelled orders",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add your notification button functionality here
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/dwaiting.png',
                          height: 50,
                          width: 60,// Replace with your image path
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Driver Confirmation",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
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

        ],
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

