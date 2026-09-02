import 'package:flutter/material.dart';

import 'database/database.dart';
import 'screens/products_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/analytics_screen.dart';

// One database instance, shared across the whole app.
final AppDatabase db = AppDatabase();

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _screens = [
    BillingScreen(),
    ProductsScreen(),
    ReportsScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.point_of_sale),
                label: Text('Billing'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.insights),
                label: Text('Analytics'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _screens[_index]),
        ],
      ),
    );
  }
}
