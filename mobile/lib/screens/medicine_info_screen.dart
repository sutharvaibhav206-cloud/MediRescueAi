import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/medicine.dart';
import '../widgets/medicine_card.dart';
import '../widgets/disclaimer_card.dart';

class MedicineInfoScreen extends StatefulWidget {
  const MedicineInfoScreen({super.key});

  @override
  State<MedicineInfoScreen> createState() => _MedicineInfoScreenState();
}

class _MedicineInfoScreenState extends State<MedicineInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MedicineModel> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedicines('');
  }

  void _fetchMedicines(String query) async {
    setState(() => _isLoading = true);
    final results = await ApiService.searchMedicines(query);
    if (mounted) {
      setState(() {
        _medicines = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0277BD),
        title: const Text("💊 Medicine Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar & Safety Guardrail Banner
          Container(
            color: const Color(0xFF0277BD),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => _fetchMedicines(val),
                  decoration: InputDecoration(
                    hintText: "Search medicine name or use (e.g. Paracetamol, ORS)...",
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0277BD)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _fetchMedicines('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),

          // Strict Medical Guardrail Notice
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DisclaimerCard(
              text: "SAFETY NOTICE: Do NOT attempt self-prescription. Antibiotics and controlled prescription drugs require an official prescription from a registered medical practitioner.",
            ),
          ),

          // Medicines List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF0277BD)))
                : _medicines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.medication_liquid_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("No medicine found matching search query.", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _medicines.length,
                        itemBuilder: (context, index) {
                          return MedicineCard(medicine: _medicines[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
