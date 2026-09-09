import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'symptom_checker_screen.dart';
import 'first_aid_guide_screen.dart';
import 'hospital_finder_screen.dart';
import 'emergency_contacts_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    SymptomCheckerScreen(),
    FirstAidGuideScreen(),
    HospitalFinderScreen(),
    EmergencyContactsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF006A60),
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, color: Color(0xFF006A60)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services_outlined),
              activeIcon: Icon(Icons.medical_services, color: Color(0xFF006A60)),
              label: 'AI Check',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.healing_outlined),
              activeIcon: Icon(Icons.healing, color: Color(0xFF006A60)),
              label: 'First Aid',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_outlined),
              activeIcon: Icon(Icons.local_hospital, color: Color(0xFF006A60)),
              label: 'Hospitals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_in_talk_outlined),
              activeIcon: Icon(Icons.phone_in_talk, color: Color(0xFF006A60)),
              label: 'Contacts',
            ),
          ],
        ),
      ),
    );
  }
}
