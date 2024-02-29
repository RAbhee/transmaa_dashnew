import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transmaa_dash/sidebuttons/buyNsell.dart';
import 'package:transmaa_dash/sidebuttons/finance.dart';
import 'package:transmaa_dash/sidebuttons/insurance.dart';
import 'package:transmaa_dash/sidebuttons/loads.dart';
import 'package:transmaa_dash/sidebuttons/verification.dart';
import 'Screens/cancelled.dart';
import 'Screens/delivered.dart';
import 'Screens/driver_waiting.dart';
import 'Screens/ordersondway.dart';
import 'Screens/waiting.dart';
import 'firebase_options.dart';

void main() async {
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
        '/delivered_orders': (context) => Ordersdelivered(),
        '/cancelled_orders': (context) => CancelledOrdersScreen(),
        '/waiting_orders': (context) => WaitingordersScreen(),
        '/driver_waiting': (context) => DriversAcceptedOrders(),
        '/Orders_OntheWay': (context) => Ordersontheway(),
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
  List<Widget> _pageContentWidgets = [
    LoadsScreen(),
    BuynSellScreen(),
    FinanceScreen(),
    InsuranceScreen(),
    VerificationScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar
          Flexible(
            flex: 1,
            child: SideContainer(
              onPageSelected: (index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.jumpToPage(_currentIndex);
                });
              },
              selectedItemIndex: _currentIndex,
              icons: [
                Icons.directions_car, // Loads
                Icons.shopping_cart, // Buy & Sell
                Icons.account_balance_wallet, // Finance
                Icons.local_offer, // Insurance
                Icons.verified_user, // Verification
              ],
              // Pass the method to update the page content
              onPageContentRequested: (Widget pageContent) {
                setState(() {
                  // Update the content of the current page
                  _pageContentWidgets[_currentIndex] = pageContent;
                });
              },
            ),
          ),
          // Main content
          SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10)),
                // Top container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 80.0,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 30.0,
                          ),
                          SizedBox(width: 20.0),
                          Icon(
                            Icons.account_circle,
                            size: 30.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Page content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      children: _pageContentWidgets,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class SideContainer extends StatelessWidget {
  final Function(int) onPageSelected;
  final int selectedItemIndex;
  final List<IconData> icons;
  final Function(Widget) onPageContentRequested;

  const SideContainer({
    required this.onPageSelected,
    required this.selectedItemIndex,
    required this.icons,
    required this.onPageContentRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Divider(
                color: Colors.black,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(height: 15),
              for (int i = 0; i < icons.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: buildMenuItem(context, icons[i], i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, int index) {
    final Duration delay = Duration(milliseconds: 200 * index);

    return GestureDetector(
      onTap: () {
        onPageSelected(index);
        onPageContentRequested(_getPageContent(icon));
      },
      child: Container(
        width: double.infinity,
        color: selectedItemIndex == index ? Colors.blue.withOpacity(0.3) : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: selectedItemIndex == index ? Colors.blue : Colors.black,
              ),
              SizedBox(width: 16),
              Text(
                _getIconLabel(icon),
                style: TextStyle(
                  fontSize: 16,
                  color: selectedItemIndex == index ? Colors.blue : Colors.black,
                  fontWeight: selectedItemIndex == index ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPageContent(IconData icon) {
    switch (icon) {
      case Icons.directions_car:
        return LoadsScreen();
      case Icons.shopping_cart:
        return BuynSellScreen();
      case Icons.account_balance_wallet:
        return FinanceScreen();
      case Icons.local_offer:
        return InsuranceScreen();
      case Icons.verified_user:
        return VerificationScreen();
      default:
        return Container();
    }
  }

  String _getIconLabel(IconData icon) {
    if (icon == Icons.directions_car) {
      return 'Loads';
    } else if (icon == Icons.shopping_cart) {
      return 'Buy & Sell';
    } else if (icon == Icons.account_balance_wallet) {
      return 'Finance';
    } else if (icon == Icons.local_offer) {
      return 'Insurance';
    } else if (icon == Icons.verified_user) {
      return 'Verification';
    }
    return '';
  }
}
