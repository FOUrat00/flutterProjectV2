import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/property.dart';
import '../data/json_data.dart';
import '../widgets/property_card.dart';
import '../widgets/property_map.dart';
import 'property_details_page.dart';
import 'profile_settings_page.dart';

/// ========================================
/// HOME PAGE (DASHBOARD)
/// Main dashboard with navbar, sidebar, and property listings
/// ========================================

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({
    Key? key,
    this.userEmail = 'student@urbino.it',
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarOpen = true;
  bool _showMap = false;
  String _selectedCategory = 'All Properties';
  
  // Data State
  final List<Property> _allProperties = JsonData.getProperties();
  List<Property> _filteredProperties = [];
  final Set<String> _favoriteIds = {};
  
  // Filter State
  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 2000);
  int? _selectedBedrooms;
  
  // Categories
  final List<String> _categories = [
    'All Properties',
    'Studios',
    'Apartments',
    'Rooms',
    'Luxury',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProperties = List.from(_allProperties);
    _searchController.addListener(_filterProperties);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProperties() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredProperties = _allProperties.where((property) {
        // 1. Filter by Category
        bool matchesCategory = true;
        if (_selectedCategory == 'Studios') {
          matchesCategory = property.propertyType == 'Studio';
        } else if (_selectedCategory == 'Apartments') {
          matchesCategory = property.propertyType == 'Apartment' || property.propertyType == 'Loft';
        } else if (_selectedCategory == 'Rooms') {
          matchesCategory = property.propertyType == 'Room';
        } else if (_selectedCategory == 'Luxury') {
          matchesCategory = property.price > 800 || property.propertyType == 'Villa';
        } else if (_selectedCategory == 'Favorites') {
          matchesCategory = _favoriteIds.contains(property.id);
        }

        // 2. Filter by Search Query
        bool matchesSearch = property.title.toLowerCase().contains(query) ||
                             property.location.toLowerCase().contains(query) ||
                             property.description.toLowerCase().contains(query);

        // 3. Filter by Price
        bool matchesPrice = property.price >= _priceRange.start && property.price <= _priceRange.end;

        // 4. Filter by Bedrooms
        bool matchesBedrooms = _selectedBedrooms == null || property.bedrooms >= _selectedBedrooms!;

        return matchesCategory && matchesSearch && matchesPrice && matchesBedrooms;
      }).toList();
    });
  }

  void _toggleFavorite(String propertyId) {
    setState(() {
      if (_favoriteIds.contains(propertyId)) {
        _favoriteIds.remove(propertyId);
      } else {
        _favoriteIds.add(propertyId);
      }
      // Re-filter if we are in Favorites tab
      if (_selectedCategory == 'Favorites') {
        _filterProperties();
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInternal) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Filter Properties', style: UrbinoTextStyles.heading2),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price Range (Monthly)', style: UrbinoTextStyles.bodyTextBold),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 2000,
                      divisions: 20,
                      activeColor: UrbinoColors.gold,
                      inactiveColor: UrbinoColors.paleBlue,
                      labels: RangeLabels(
                        '€${_priceRange.start.round()}',
                        '€${_priceRange.end.round()}',
                      ),
                      onChanged: (values) {
                        setStateInternal(() => _priceRange = values);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('€${_priceRange.start.round()}', style: UrbinoTextStyles.smallText),
                        Text('€${_priceRange.end.round()}', style: UrbinoTextStyles.smallText),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Minimum Bedrooms', style: UrbinoTextStyles.bodyTextBold),
                   const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: List.generate(5, (index) {
                        final count = index + 1;
                        final isSelected = _selectedBedrooms == count;
                        return ChoiceChip(
                          label: Text('$count+'),
                          selected: isSelected,
                          selectedColor: UrbinoColors.gold,
                          backgroundColor: UrbinoColors.paleBlue,
                          labelStyle: TextStyle(
                            color: isSelected ? UrbinoColors.darkBlue : UrbinoColors.darkGray,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setStateInternal(() {
                              _selectedBedrooms = selected ? count : null;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(0, 2000);
                      _selectedBedrooms = null;
                    });
                    _filterProperties();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset', style: TextStyle(color: UrbinoColors.error)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Apply changes from dialog to main state
                    });
                    _filterProperties();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UrbinoColors.offWhite,
      body: Row(
        children: [
          if (_isSidebarOpen) _buildSidebar(),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildNavbar(),
                    Expanded(
                      child: _showMap 
                          ? PropertyMap(properties: _filteredProperties)
                          : _buildMainContent(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: FloatingActionButton.extended(
                    onPressed: () => setState(() => _showMap = !_showMap),
                    backgroundColor: UrbinoColors.darkBlue,
                    foregroundColor: UrbinoColors.white,
                    elevation: 5,
                    icon: Icon(_showMap ? Icons.list : Icons.map),
                    label: Text(_showMap ? 'Show List' : 'Show Map'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: UrbinoColors.white,
        boxShadow: const [UrbinoShadows.soft],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _isSidebarOpen ? Icons.menu_open : Icons.menu,
                color: UrbinoColors.darkBlue,
              ),
              onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: UrbinoGradients.goldAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home_work, color: UrbinoColors.darkBlue, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Urbino Housing',
                    style: UrbinoTextStyles.bodyTextBold.copyWith(
                      fontSize: 16,
                      color: UrbinoColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: 300,
              height: 42,
              decoration: BoxDecoration(
                color: UrbinoColors.paleBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search properties...',
                  hintStyle: UrbinoTextStyles.smallText,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: UrbinoColors.warmGray,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: UrbinoColors.darkBlue),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: UrbinoColors.brickOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            _buildProfileMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: const Row(children: [Icon(Icons.person, size: 18), SizedBox(width: 8), Text('Profile')]),
          onTap: () {
            // Close popup first (optional but good practice usually handled auto, but here explicitly navigating)
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsPage(userEmail: widget.userEmail),
                ),
              ),
            );
          },
        ),
        const PopupMenuItem(
          child: Row(children: [Icon(Icons.settings, size: 18), SizedBox(width: 8), Text('Settings')]),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
          child: const Row(
            children: [
              Icon(Icons.logout, size: 18, color: UrbinoColors.error),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: UrbinoColors.error)),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: UrbinoColors.gold,
            child: Text(
              widget.userEmail[0].toUpperCase(),
              style: UrbinoTextStyles.bodyTextBold.copyWith(color: UrbinoColors.darkBlue),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.userEmail.split('@')[0],
            style: UrbinoTextStyles.bodyTextBold.copyWith(fontSize: 14, color: UrbinoColors.darkBlue),
          ),
          const Icon(Icons.arrow_drop_down, color: UrbinoColors.darkBlue),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 260,
      decoration: BoxDecoration(
        color: UrbinoColors.white,
        boxShadow: const [UrbinoShadows.soft],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories', style: UrbinoTextStyles.heading2.copyWith(fontSize: 18)),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    gradient: UrbinoGradients.goldAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ..._categories.map((category) => _buildSidebarItem(
                  category,
                  _getIconForCategory(category),
                  category == _selectedCategory,
                )),
                const SizedBox(height: 16),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Divider()),
                const SizedBox(height: 8),
                _buildSidebarItem('Favorites', Icons.favorite, 'Favorites' == _selectedCategory),
                _buildSidebarItem('My Bookings', Icons.bookmark_outline, false),
                _buildSidebarItem('Messages', Icons.message_outlined, false),
              ],
            ),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: UrbinoGradients.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UrbinoColors.gold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: UrbinoColors.darkBlue, size: 32),
          const SizedBox(height: 8),
          Text('Need Help?', style: UrbinoTextStyles.bodyTextBold.copyWith(color: UrbinoColors.darkBlue)),
          const SizedBox(height: 4),
          Text('Contact our support team', style: UrbinoTextStyles.smallText, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: isSelected ? UrbinoGradients.primaryButton : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? UrbinoColors.white : UrbinoColors.darkBlue,
          size: 22,
        ),
        title: Text(
          title,
          style: UrbinoTextStyles.bodyTextBold.copyWith(
            color: isSelected ? UrbinoColors.white : UrbinoColors.darkBlue,
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          setState(() {
            _selectedCategory = title;
          });
          _filterProperties();
        },
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'All Properties': return Icons.home;
      case 'Studios': return Icons.apartment;
      case 'Apartments': return Icons.business;
      case 'Rooms': return Icons.room_preferences;
      case 'Luxury': return Icons.star;
      default: return Icons.home;
    }
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 32),
          _buildStatsRow(),
          const SizedBox(height: 48),
          _buildResultsHeader(),
          const SizedBox(height: 24),
          _buildPropertyGrid(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Urbino University Housing', style: UrbinoTextStyles.heading1.copyWith(fontSize: 28)),
            const SizedBox(height: 8),
            Text('Exclusive accommodations for international students', style: UrbinoTextStyles.subtitle),
          ],
        ),
        InkWell(
          onTap: _showFilterDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: UrbinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: UrbinoColors.lightGold.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, color: UrbinoColors.darkBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: UrbinoTextStyles.bodyTextBold.copyWith(color: UrbinoColors.darkBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final avgPrice = _filteredProperties.isEmpty 
        ? 0 
        : (_filteredProperties.map((p) => p.price).reduce((a, b) => a + b) / _filteredProperties.length).toInt();

    return Row(
      children: [
        Expanded(child: _buildStatCard('Active Listings', '${_filteredProperties.length}', Icons.house_rounded, UrbinoColors.darkBlue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Avg. Monthly', '€$avgPrice', Icons.payments_outlined, UrbinoColors.brickOrange)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Verified', '100%', Icons.verified_user_outlined, UrbinoColors.success)),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectedCategory, style: UrbinoTextStyles.heading2),
            const SizedBox(height: 4),
            Container(height: 2, width: 32, color: UrbinoColors.gold),
          ],
        ),
        Text(
          'Showing ${_filteredProperties.length} results',
          style: UrbinoTextStyles.bodyText.copyWith(color: UrbinoColors.warmGray, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPropertyGrid() {
    if (_filteredProperties.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.search_off, size: 64, color: UrbinoColors.warmGray),
            const SizedBox(height: 16),
            Text('No properties found', style: UrbinoTextStyles.heading2.copyWith(color: UrbinoColors.warmGray)),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters or search query'),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1600) crossAxisCount = 5;
        else if (constraints.maxWidth > 1200) crossAxisCount = 4;
        else if (constraints.maxWidth > 800) crossAxisCount = 3;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.8,
          ),
          itemCount: _filteredProperties.length,
          itemBuilder: (context, index) {
            final property = _filteredProperties[index];
            return PropertyCard(
              property: property,
              isFavorite: _favoriteIds.contains(property.id),
              onFavoriteToggle: () => _toggleFavorite(property.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsPage(property: property),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: UrbinoColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [UrbinoShadows.soft],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: UrbinoTextStyles.smallText),
                const SizedBox(height: 4),
                Text(value, style: UrbinoTextStyles.heading2.copyWith(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



