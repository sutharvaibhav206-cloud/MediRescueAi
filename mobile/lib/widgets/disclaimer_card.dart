import 'package:flutter/material.dart';

class DisclaimerCard extends StatelessWidget {
  final String text;

  const DisclaimerCard({
    super.key,
    this.text = "IMPORTANT: MediRescue AI is an emergency information and first-aid guidance tool, NOT a doctor or replacement for professional medical care. Never claim or assume a medicine will 'cure' a disease. For serious cases, seek professional medical attention immediately.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFFFB300), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF4E342E),
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
