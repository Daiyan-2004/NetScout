import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../emergency/emergency_connect_screen.dart';
import '../networks/network_list_screen.dart';
import '../profile/profile_screen.dart';
import '../networks/my_networks_screen.dart';
import '../diagnostics/speed_test_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data — replace with real region/floor data from services later.
  final List<_Floor> _floors = const [
    _Floor(
      name: '1st Floor',
      regions: [
        _Region(
          name: 'Library Hall',
          imagePath: 'assets/images/regions/library_hall.png',
        ),
        _Region(
          name: 'Reading Room',
          imagePath: 'assets/images/regions/reading_room.png',
        ),
        _Region(
          name: 'Main Lobby',
          imagePath: 'assets/images/regions/main_lobby.png',
        ),
        _Region(
          name: 'Cafeteria',
          imagePath: 'assets/images/regions/cafeteria.png',
        ),
      ],
    ),
    _Floor(
      name: '2nd Floor',
      regions: [
        _Region(
          name: 'CSE Lab 1',
          imagePath: 'assets/images/regions/cse_lab_1.png',
        ),
        _Region(
          name: 'CSE Lab 2',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 3',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 4',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 5',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'Faculty Room',
          imagePath: 'assets/images/regions/faculty_room.png',
        ),
      ],
    ),
    _Floor(
      name: '3rd Floor',
      regions: [
        _Region(
          name: 'CSE Lab 1',
          imagePath: 'assets/images/regions/cse_lab_1.png',
        ),
        _Region(
          name: 'CSE Lab 2',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 3',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 4',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 5',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'Faculty Room',
          imagePath: 'assets/images/regions/faculty_room.png',
        ),
      ],
    ),
    _Floor(
      name: '4th Floor',
      regions: [
        _Region(
          name: 'CSE Lab 1',
          imagePath: 'assets/images/regions/cse_lab_1.png',
        ),
        _Region(
          name: 'CSE Lab 2',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 3',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 4',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'CSE Lab 5',
          imagePath: 'assets/images/regions/cse_lab_2.png',
        ),
        _Region(
          name: 'Faculty Room',
          imagePath: 'assets/images/regions/faculty_room.png',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Floor> get _filteredFloors {
    if (_searchQuery.trim().isEmpty) return _floors;
    final query = _searchQuery.toLowerCase();
    return _floors
        .map((floor) {
      final matched = floor.regions
          .where((r) => r.name.toLowerCase().contains(query))
          .toList();
      return _Floor(name: floor.name, regions: matched);
    })
        .where((floor) => floor.regions.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'NetScout',
              style: TextStyle(
                color: Color(0xFF0F2A5C),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F2A5C)),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      endDrawer: const _AppMenuDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // --- Section 1: Regions label + search bar ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Regions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F2A5C),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search regions...',
                      hintStyle: const TextStyle(color: Colors.black38),
                      prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.black45),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: Color(0xFF1B6EA8), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Section 2: Floors + region grid ---
            Expanded(
              child: _filteredFloors.isEmpty
                  ? const Center(
                child: Text(
                  'No regions found',
                  style: TextStyle(color: Colors.black45),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: _filteredFloors.length,
                itemBuilder: (context, index) {
                  final floor = _filteredFloors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          floor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F2A5C),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.95,
                          children: floor.regions
                              .map((region) => _RegionBox(region: region))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EmergencyConnectScreen()),
          );
        },
        backgroundColor: const Color(0xFFE23E3E),
        icon: const Icon(Icons.bolt_rounded, color: Colors.white),
        label: const Text(
          'Emergency Connect',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _RegionBox extends StatelessWidget {
  final _Region region;

  const _RegionBox({required this.region});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NetworkListScreen(regionName: region.name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  region.imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE8F1F8),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.meeting_room_outlined,
                      color: Color(0xFF1B6EA8),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Text(
                region.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F2A5C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppMenuDrawer extends StatelessWidget {
  const _AppMenuDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F2A5C),
                ),
              ),
            ),
            const Divider(height: 1),
            _MenuItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.wifi_rounded,
              label: 'My Networks',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyNetworksScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.speed_rounded,
              label: 'Speed Test',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SpeedTestScreen()),
              ),
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            const Spacer(),
            const Divider(height: 1),
            _MenuItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              onTap: () async {
                // Drawer বন্ধ হওয়ার আগেই navigator ধরে রাখি,
                // কারণ await-এর পর এই context আর থাকবে না।
                final navigator = Navigator.of(context);
                await AuthService().signOut();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1B6EA8)),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F2A5C),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(); // close drawer first
        onTap();
      },
    );
  }
}

class _Floor {
  final String name;
  final List<_Region> regions;

  const _Floor({required this.name, required this.regions});
}

class _Region {
  final String name;
  final String imagePath;

  const _Region({required this.name, required this.imagePath});
}