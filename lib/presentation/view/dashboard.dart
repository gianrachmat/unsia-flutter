import 'package:flutter/material.dart';
import 'package:uts_unsia/presentation/view/habit_list_page.dart';
import 'package:uts_unsia/presentation/view/habit_detail_list_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.blueAccent,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_calendar_rounded),
            selectedIcon: Icon(Icons.edit_calendar_rounded, color: Colors.white),
            label: 'Habit',
          ),
          NavigationDestination(
            icon: Icon(Icons.done_all_rounded),
            selectedIcon: Icon(Icons.done_all_rounded, color: Colors.white),
            label: 'Detail',
          ),
        ],
      ),
      body: _buildPage()[_currentPageIndex],
    );
  }

  List<Widget> _buildPage() {
    return [
      const HabitListPage(title: 'Your Habit'),
      const HabitDetailListPage(title: 'Habit Detail'),
    ];
  }
}
