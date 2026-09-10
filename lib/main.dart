import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/products_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/udhaar_screen.dart';
import 'screens/settings_screen.dart';

/// Global theme-mode switch. A top-level ValueNotifier keeps this simple -
/// no extra state-management package needed just to flip light/dark.
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    minimumSize: Size(700, 500),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.maximize();
    await windowManager.focus();
  });

  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Lateef Book Depo',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
            brightness: Brightness.dark,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

const Color _sidebarColor = Color(0xFF0F1B2D);
const Color _accentColor = Color(0xFF17A398);

class _NavItem {
  final IconData icon;
  final String label;
  final String pageTitle;
  const _NavItem(this.icon, this.label, this.pageTitle);
}

const List<_NavItem> _navItems = [
  _NavItem(Icons.point_of_sale, 'Billing', 'Billing & Checkout'),
  _NavItem(Icons.inventory_2_outlined, 'Products', 'Inventory & Products'),
  _NavItem(Icons.menu_book_outlined, 'Udhaar Book', 'Udhaar Book'),
  _NavItem(Icons.bar_chart, 'Reports', 'Reports & Profit Analytics'),
  _NavItem(Icons.insights, 'Analytics', 'Sales Progress & Analytics'),
  _NavItem(Icons.settings_outlined, 'Settings', 'Settings'),
];

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
    UdhaarScreen(),
    ReportsScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxWidth < 800;
          return Row(
            children: [
              Container(
                width: isCollapsed ? 72 : 220,
                color: _sidebarColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _accentColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.storefront, color: Colors.white, size: 20),
                          ),
                          if (!isCollapsed) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Lateef Book Depo',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    for (int i = 0; i < _navItems.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:12, vertical: 4),
                        child: Material(
                          color: i == _index ? _accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _index = i),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(_navItems[i].icon,
                                      color: Colors.white, size: 20),
                                  if (!isCollapsed) ...[
                                    const SizedBox(width: 14),
                                    Text(
                                      _navItems[i].label,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight:
                                            i == _index ? FontWeight.bold: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (!isCollapsed)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('v1.0.0 - Desktop Edition',
                            style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _navItems[_index].pageTitle,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeModeNotifier,
                            builder: (context, mode, _) {
                              final isDark = mode == ThemeMode.dark;
                              return IconButton(
                                tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                                icon: Icon(
                                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                  color: isDark ? Colors.amber : Colors.indigo,
                                ),
                                onPressed: () {
                                  themeModeNotifier.value =
                                      isDark ? ThemeMode.light : ThemeMode.dark;
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.person_outline, color: Colors.black54),
                          const SizedBox(width: 6),
                          const Text('Admin / Cashier',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Expanded(child: _screens[_index]),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}