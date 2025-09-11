// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../dashboard/profile_tab.dart';
import '../dashboard/settings_tab.dart';
import '../dashboard/system_tap.dart';
import '../dashboard/statistics_tab.dart';
import '../dashboard/risks.dart';
import '../../widgets/side_menu.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens =  [
    ProfileTab(),
    RisksListScreen(),
    StatisticsTab(),
    SystemTap(),
    SettingsTab(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          SideMenu(onItemSelected: _onItemSelected),
          Expanded(
            child: Container(
              color: colors.surface,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
