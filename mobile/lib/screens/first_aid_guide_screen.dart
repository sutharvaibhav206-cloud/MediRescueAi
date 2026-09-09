import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/first_aid.dart';
import '../widgets/disclaimer_card.dart';

class FirstAidGuideScreen extends StatefulWidget {
  const FirstAidGuideScreen({super.key});

  @override
  State<FirstAidGuideScreen> createState() => _FirstAidGuideScreenState();
}

class _FirstAidGuideScreenState extends State<FirstAidGuideScreen> {
  List<FirstAidGuideModel> _allGuides = [];
  List<FirstAidGuideModel> _filteredGuides = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Injuries',
    'Burns',
    'Bleeding',
    'Breathing emergencies',
    'Heat-related problems',
    'Allergic reactions',
    'Bites and stings',
    'Common illnesses',
  ];

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  void _loadGuides() async {
    setState(() => _isLoading = true);
    final guides = await ApiService.getFirstAidGuides();
    if (mounted) {
      setState(() {
        _allGuides = guides;
        _filterGuides();
        _isLoading = false;
      });
    }
  }

  void _filterGuides() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredGuides = _allGuides.where((guide) {
        final matchesCat = _selectedCategory == 'All' ||
            guide.category.toLowerCase().contains(_selectedCategory.toLowerCase());
        final matchesQuery = query.isEmpty ||
            guide.title.toLowerCase().contains(query) ||
            guide.whatHappened.toLowerCase().contains(query) ||
            guide.immediateFirstAid.any((step) => step.toLowerCase().contains(query));
        return matchesCat && matchesQuery;
      }).toList();
    });
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'bone':
        return Icons.healing;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'water_drop':
        return Icons.water_drop;
      case 'air':
        return Icons.air;
      case 'thermostat':
        return Icons.thermostat;
      case 'warning':
        return Icons.warning_amber;
      case 'bug_report':
        return Icons.bug_report;
      default:
        return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006A60),
        title: const Text("🩹 First-Aid Knowledge Base", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: const Color(0xFF006A60),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterGuides(),
                  decoration: InputDecoration(
                    hintText: "Search first-aid guides (e.g. burn, fracture, choking)...",
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF006A60)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterGuides();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF006A60) : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = cat;
                                _filterGuides();
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

          // Guides List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF006A60)))
                : _filteredGuides.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.search_off, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("No matching first-aid guides found.", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredGuides.length,
                        itemBuilder: (context, index) {
                          final guide = _filteredGuides[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ExpansionTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_getIconData(guide.icon), color: const Color(0xFF00796B)),
                              ),
                              title: Text(
                                guide.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF004D40)),
                              ),
                              subtitle: Text(
                                "Category: ${guide.category}",
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAlignment.start,
                                    children: [
                                      // What Happened
                                      const Text("What happened?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.teal)),
                                      const SizedBox(height: 2),
                                      Text(guide.whatHappened, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                      const Divider(height: 20),

                                      // Immediate First Aid
                                      const Text("Immediate First Aid:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D40))),
                                      const SizedBox(height: 6),
                                      ...guide.immediateFirstAid.asMap().entries.map((e) => Padding(
                                            padding: const EdgeInsets.only(bottom: 4.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAlignment.start,
                                              children: [
                                                Text("${e.key + 1}. ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                                Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13))),
                                              ],
                                            ),
                                          )),
                                      const SizedBox(height: 12),

                                      // Do & Don't
                                      Row(
                                        crossAxisAlignment: CrossAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAlignment.start,
                                              children: [
                                                const Text("DO", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 12)),
                                                ...guide.doList.map((d) => Text("• $d", style: const TextStyle(fontSize: 12))),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAlignment.start,
                                              children: [
                                                const Text("DON'T", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12)),
                                                ...guide.dontList.map((d) => Text("• $d", style: const TextStyle(fontSize: 12))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // When to Seek Emergency Help
                                      const Text("When to seek emergency help:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 13)),
                                      ...guide.whenToSeekHelp.map((w) => Text("⚠️ $w", style: const TextStyle(fontSize: 12, color: Colors.deepOrange))),

                                      const SizedBox(height: 10),
                                      const DisclaimerCard(),
                                    ],
                                  ),
                                ),
                              ],
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
