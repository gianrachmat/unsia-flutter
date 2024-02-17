import 'package:flutter/material.dart';
import 'package:uts_unsia/presentation/view/mahasiswa_list_page.dart';
import 'package:uts_unsia/presentation/view/nilai_list_page.dart';

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
            icon: Icon(Icons.group),
            selectedIcon: Icon(Icons.group, color: Colors.white),
            label: 'Mahasiswa',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Nilai',
          ),
        ],
      ),
      body: _buildPage()[_currentPageIndex],
    );
  }

  List<Widget> _buildPage() {
    return [
      const MahasiswaListPage(title: 'Daftar Mahasiswa'),
      const NilaiListPage(title: 'Daftar Nilai Mahasiswa'),
    ];
  }
}
