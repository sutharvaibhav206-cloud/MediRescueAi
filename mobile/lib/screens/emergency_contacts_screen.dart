import 'package:flutter/material.dart';
import '../services/offline_storage_service.dart';
import '../services/location_service.dart';
import '../models/emergency_contact.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContactModel> _contacts = [];
  String _nationalNumber = '112';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final num = await OfflineStorageService.getNationalEmergencyNumber();
    final contactsList = await OfflineStorageService.getSavedContacts();
    if (mounted) {
      setState(() {
        _nationalNumber = num;
        _contacts = contactsList;
        _isLoading = false;
      });
    }
  }

  void _showAddContactDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final relCtrl = TextEditingController(text: "Family");

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add Emergency Contact", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC2185B))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Contact Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: relCtrl,
                decoration: const InputDecoration(labelText: "Relationship (e.g. Parent, Doctor)", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC2185B), foregroundColor: Colors.white),
              onPressed: () async {
                if (nameCtrl.text.trim().isNotEmpty && phoneCtrl.text.trim().isNotEmpty) {
                  final newContact = EmergencyContactModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text.trim(),
                    phoneNumber: phoneCtrl.text.trim(),
                    relationship: relCtrl.text.trim(),
                  );
                  await OfflineStorageService.saveContact(newContact);
                  Navigator.of(ctx).pop();
                  _loadData();
                }
              },
              child: const Text("SAVE CONTACT"),
            ),
          ],
        );
      },
    );
  }

  void _showEditNationalNumberDialog() {
    final numCtrl = TextEditingController(text: _nationalNumber);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Configure National Emergency Number", style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: numCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Emergency Number (e.g. 112, 108, 911)", border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (numCtrl.text.trim().isNotEmpty) {
                  await OfflineStorageService.setNationalEmergencyNumber(numCtrl.text.trim());
                  Navigator.of(ctx).pop();
                  _loadData();
                }
              },
              child: const Text("UPDATE"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC2185B),
        title: const Text("📞 Emergency Contacts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Configure Emergency Number',
            onPressed: _showEditNationalNumberDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFC2185B)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  // Main Emergency Hotline Call Card
                  Card(
                    elevation: 3,
                    color: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(Icons.phone_forwarded, color: Colors.white, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            "NATIONAL EMERGENCY HOTLINE",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nationalNumber,
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.black),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFD32F2F),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => LocationService.makePhoneCall(_nationalNumber),
                              icon: const Icon(Icons.call, size: 22),
                              label: Text(
                                "CALL HOTLINE ($_nationalNumber)",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Personal Emergency Contacts",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.person_add, color: Color(0xFFC2185B)),
                        onPressed: _showAddContactDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Contacts List
                  ..._contacts.map((contact) {
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFCE4EC),
                          child: Text(
                            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : 'C',
                            style: const TextStyle(color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${contact.relationship} • ${contact.phoneNumber}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () => LocationService.makePhoneCall(contact.phoneNumber),
                            ),
                            if (contact.id != '1' && contact.id != '2')
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                onPressed: () async {
                                  await OfflineStorageService.deleteContact(contact.id);
                                  _loadData();
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC2185B),
                        side: const BorderSide(color: Color(0xFFC2185B)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _showAddContactDialog,
                      icon: const Icon(Icons.add),
                      label: const Text("ADD NEW EMERGENCY CONTACT", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
