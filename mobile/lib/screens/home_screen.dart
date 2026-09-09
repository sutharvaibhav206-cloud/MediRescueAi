import 'package:flutter/material.dart';
import '../widgets/emergency_banner.dart';
import '../widgets/disclaimer_card.dart';
import 'emergency_screen.dart';
import 'symptom_checker_screen.dart';
import 'first_aid_guide_screen.dart';
import 'medicine_info_screen.dart';
import 'hospital_finder_screen.dart';
import 'emergency_contacts_screen.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006A60),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: const [
            Icon(Icons.health_and_safety_rounded, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              "MediRescue AI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency_rounded, color: Colors.redAccent, size: 28),
            tooltip: 'Instant Emergency Mode',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EmergencyScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            const EmergencyBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  const Text(
                    "Quick Services",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Select a service for immediate assistance and medical guidance",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 6 Main Action Cards Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.15,
                    children: [
                      _buildActionCard(
                        context,
                        title: "Emergency\nAssistance",
                        subtitle: "Immediate Step-by-Step",
                        icon: Icons.emergency,
                        color: const Color(0xFFD32F2F),
                        badgeText: "URGENT",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        title: "Check\nSymptoms",
                        subtitle: "AI Medical Assessment",
                        icon: Icons.medical_services,
                        color: const Color(0xFF006A60),
                        badgeText: "AI POWERED",
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 1)),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        title: "First-Aid\nGuide",
                        subtitle: "Searchable Instructions",
                        icon: Icons.healing,
                        color: const Color(0xFF00796B),
                        badgeText: "KNOWLEDGE",
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 2)),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        title: "Medicine\nInformation",
                        subtitle: "Uses & Safety Warnings",
                        icon: Icons.medication,
                        color: const Color(0xFF0277BD),
                        badgeText: "DATABASE",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MedicineInfoScreen()),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        title: "Find Nearby\nHospital",
                        subtitle: "Hospitals & ER Clinics",
                        icon: Icons.local_hospital,
                        color: const Color(0xFF2E7D32),
                        badgeText: "GPS MAP",
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 3)),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
                        title: "Emergency\nContacts",
                        subtitle: "One-Touch Calling",
                        icon: Icons.phone_in_talk,
                        color: const Color(0xFFC2185B),
                        badgeText: "DIALER",
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialIndex: 4)),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  const DisclaimerCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
