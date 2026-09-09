import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class HospitalFinderScreen extends StatefulWidget {
  const HospitalFinderScreen({super.key});

  @override
  State<HospitalFinderScreen> createState() => _HospitalFinderScreenState();
}

class _HospitalFinderScreenState extends State<HospitalFinderScreen> {
  Position? _currentPosition;
  List<HealthFacility> _facilities = [];
  bool _isLoading = true;
  String? _statusMessage;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Hospital & ER', 'Clinic', 'Pharmacy'];

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  void _initLocationAndFetch() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Acquiring GPS location...";
    });

    final pos = await LocationService.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = pos;
        if (pos == null) {
          _statusMessage = "Location permission not granted or GPS unavailable. Showing reference emergency facility directory.";
        } else {
          _statusMessage = "Showing health facilities relative to your current location.";
        }
        _facilities = LocationService.getNearbyFacilities(pos);
        _isLoading = false;
      });
    }
  }

  List<HealthFacility> get _filteredFacilities {
    if (_selectedFilter == 'All') return _facilities;
    return _facilities.where((f) {
      if (_selectedFilter == 'Hospital & ER') {
        return f.type.contains('Hospital') || f.type.contains('Emergency');
      } else if (_selectedFilter == 'Clinic') {
        return f.type.contains('Clinic');
      } else if (_selectedFilter == 'Pharmacy') {
        return f.type.contains('Pharmacy');
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("📍 Find Nearby Hospitals", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            tooltip: 'Refresh GPS Location',
            onPressed: _initLocationAndFetch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Header Bar
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                if (_statusMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _statusMessage!,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),

                // Category Filter Chips
                SizedBox(
                  height: 32,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Facilities List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFacilities.length,
                    itemBuilder: (context, index) {
                      final facility = _filteredFacilities[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      facility.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${facility.distanceKm} km away",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                facility.type,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      facility.address,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),

                              // Action Buttons: Call & Navigate
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF2E7D32),
                                        side: const BorderSide(color: Color(0xFF2E7D32)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () => LocationService.makePhoneCall(facility.phone),
                                      icon: const Icon(Icons.phone, size: 18),
                                      label: const Text("CALL FACILITY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2E7D32),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () => LocationService.openMapDirections(facility.latitude, facility.longitude, facility.name),
                                      icon: const Icon(Icons.navigation, size: 18),
                                      label: const Text("NAVIGATE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
