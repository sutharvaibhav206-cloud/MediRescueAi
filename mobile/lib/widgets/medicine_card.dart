import 'package:flutter/material.dart';
import '../models/medicine.dart';
import 'disclaimer_card.dart';

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication, color: Color(0xFF00796B), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medicine.purpose,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              "Common Uses:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            ...medicine.commonUses.map((use) => Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: Colors.teal),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          use,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            const Text(
              "Important Warnings:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange),
            ),
            const SizedBox(height: 4),
            ...medicine.importantWarnings.map((warn) => Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber, size: 16, color: Colors.deepOrange),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          warn,
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )),
            if (medicine.contraindications.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                "Contraindications:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 4),
              ...medicine.contraindications.map((contra) => Text(
                    "• $contra",
                    style: const TextStyle(fontSize: 13, color: Colors.redAccent),
                  )),
            ],
            const SizedBox(height: 10),
            DisclaimerCard(text: medicine.disclaimer),
          ],
        ),
      ),
    );
  }
}
