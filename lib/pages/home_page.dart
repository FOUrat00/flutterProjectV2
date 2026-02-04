import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'package:provider/provider.dart';
import '../services/auth_manager.dart';
import '../models/property.dart';
import '../data/json_data.dart';
import '../widgets/property_card.dart';
import '../widgets/property_map.dart';
import 'property_details_page.dart';
import 'profile_settings_page.dart';
import 'ai_assistant_page.dart';
import 'roommate_matcher_page.dart';
import 'university_page.dart';
import 'payments_page.dart';
import 'favorites_page.dart';
import 'notifications_page.dart';
import '../services/favorites_manager.dart';
import '../services/user_manager.dart';
import '../services/notification_manager.dart';
import '../main.dart';

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

  final List<Property> _allProperties = JsonData.getProperties();
  List<Property> _filteredProperties = [];
  final FavoritesManager _favoritesManager = FavoritesManager();
  final UserManager _userManager = UserManager();
  final NotificationManager _notificationManager = NotificationManager();

  final TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 2000);
  int? _selectedBedrooms;

  final List<String> _categories = [
    'all',
    'studios',
    'apartments',
    'rooms',
    'luxury',
    'favorites',
  ];

  @override
  void initState() {
    super.initState();
    _filteredProperties = List.from(_allProperties);
    _searchController.addListener(_filterProperties);
    _favoritesManager.addListener(_filterProperties);
    _userManager.addListener(_onProfileChanged);
    _notificationManager.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _favoritesManager.removeListener(_filterProperties);
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _filterProperties() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProperties = _allProperties.where((property) {
        bool matchesCategory = true;
        if (_selectedCategory == 'studios') {
          matchesCategory = property.propertyType == 'Studio';
        } else if (_selectedCategory == 'apartments') {
          matchesCategory = property.propertyType == 'Apartment' ||
              property.propertyType == 'Loft';
        } else if (_selectedCategory == 'rooms') {
          matchesCategory = property.propertyType == 'Room';
        } else if (_selectedCategory == 'luxury') {
          matchesCategory =
              property.price > 800 || property.propertyType == 'Villa';
        } else if (_selectedCategory == 'favorites') {
          matchesCategory = _favoritesManager.isFavorite(property);
        }

        bool matchesSearch = property.title.toLowerCase().contains(query) ||
            property.location.toLowerCase().contains(query) ||
            property.description.toLowerCase().contains(query);

        bool matchesPrice = property.price >= _priceRange.start &&
            property.price <= _priceRange.end;

        bool matchesBedrooms = _selectedBedrooms == null ||
            property.bedrooms >= _selectedBedrooms!;

        return matchesCategory &&
            matchesSearch &&
            matchesPrice &&
            matchesBedrooms;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInternal) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(UrbinoL10n.translate('search_hint'),
                  style: UrbinoTextStyles.heading2(context)),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price Range (Monthly)',
                        style: UrbinoTextStyles.bodyTextBold(context)),
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
                        Text('€${_priceRange.start.round()}',
                            style: UrbinoTextStyles.smallText(context)),
                        Text('€${_priceRange.end.round()}',
                            style: UrbinoTextStyles.smallText(context)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Minimum Bedrooms',
                        style: UrbinoTextStyles.bodyTextBold(context)),
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
                            color: isSelected
                                ? UrbinoColors.darkBlue
                                : UrbinoColors.darkGray,
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
                  child: const Text('Reset',
                      style: TextStyle(color: UrbinoColors.error)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? UrbinoColors.deepNavy : UrbinoColors.offWhite,
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
        color: Theme.of(context).cardColor,
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
                gradient: UrbinoGradients.goldAccent(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home_work,
                      color: UrbinoColors.darkBlue, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    UrbinoL10n.translate('app_title'),
                    style: UrbinoTextStyles.bodyTextBold(context).copyWith(
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
                  hintText: UrbinoL10n.translate('search_hint'),
                  hintStyle: UrbinoTextStyles.smallText(context),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: UrbinoColors.warmGray,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.psychology_outlined,
                  color: UrbinoColors.darkBlue),
              onPressed: () => _navigateTo(const AIAssistantPage()),
              tooltip: 'AI Assistant',
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.favorite_outline_rounded,
                  color: UrbinoColors.darkBlue),
              onPressed: () => _navigateTo(const FavoritesPage()),
              tooltip: 'Favorites',
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => _navigateTo(const NotificationsPage()),
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined,
                      color: UrbinoColors.darkBlue),
                  if (_notificationManager.unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: UrbinoColors.brickOrange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          _notificationManager.unreadCount > 9
                              ? '9+'
                              : _notificationManager.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              tooltip: 'Notifications',
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
          child: const Row(children: [
            Icon(Icons.person, size: 18),
            SizedBox(width: 8),
            Text('Profile')
          ]),
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsPage(),
                ),
              ),
            );
          },
        ),
        PopupMenuItem(
          child: Row(children: [
            Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: 18),
            const SizedBox(width: 8),
            Text(UrbinoL10n.translate('dark_mode'))
          ]),
          onTap: () => UrbinoAuthApp.of(context)?.toggleTheme(),
        ),
        PopupMenuItem(
          child: Row(children: [
            const Icon(Icons.language, size: 18),
            const SizedBox(width: 8),
            Text(UrbinoL10n.translate('language'))
          ]),
          onTap: () {
            // Cycle: en -> it -> ar -> en
            final nextLang = UrbinoL10n.currentLanguage == 'en'
                ? 'it'
                : (UrbinoL10n.currentLanguage == 'it' ? 'ar' : 'en');
            UrbinoAuthApp.of(context)?.setLanguage(nextLang);
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () async {
            Navigator.pop(context);

            await context.read<AuthManager>().logout();

            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: Row(
            children: [
              const Icon(Icons.logout, size: 18, color: UrbinoColors.error),
              const SizedBox(width: 8),
              Text(UrbinoL10n.translate('logout'),
                  style: const TextStyle(color: UrbinoColors.error)),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: UrbinoColors.gold,
            backgroundImage: _userManager.profileImageBytes != null
                ? MemoryImage(_userManager.profileImageBytes!) as ImageProvider
                : (_userManager.profileImageUrl != null
                    ? NetworkImage(_userManager.profileImageUrl!)
                    : null),
            child: (_userManager.profileImageBytes == null &&
                    _userManager.profileImageUrl == null)
                ? Text(
                    _userManager.name[0].toUpperCase(),
                    style: UrbinoTextStyles.bodyTextBold(context)
                        .copyWith(color: UrbinoColors.darkBlue),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            _userManager.name.split(' ')[0],
            style: UrbinoTextStyles.bodyTextBold(context).copyWith(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? UrbinoColors.gold
                    : UrbinoColors.darkBlue),
          ),
          Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.dark
                  ? UrbinoColors.gold
                  : UrbinoColors.darkBlue),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                Text(UrbinoL10n.translate('categories'),
                    style: UrbinoTextStyles.heading2(context)
                        .copyWith(fontSize: 18)),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    gradient: UrbinoGradients.goldAccent(context),
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
                      UrbinoL10n.translate(category),
                      _getIconForCategory(category),
                      category == _selectedCategory,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _filterProperties();
                      },
                    )),
                const SizedBox(height: 16),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider()),
                const SizedBox(height: 8),
                _buildSidebarItem(UrbinoL10n.translate('roommate_matcher'),
                    Icons.people_outline, false,
                    onTap: () => _navigateTo(const RoommateMatcherPage())),
                _buildSidebarItem(UrbinoL10n.translate('uni_integration'),
                    Icons.school_outlined, false,
                    onTap: () => _navigateTo(const UniversityPage())),
                _buildSidebarItem(UrbinoL10n.translate('payments'),
                    Icons.payments_outlined, false,
                    onTap: () => _navigateTo(const PaymentsPage())),
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
        gradient: UrbinoGradients.backgroundLight(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UrbinoColors.gold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline,
              color: Theme.of(context).brightness == Brightness.dark
                  ? UrbinoColors.gold
                  : UrbinoColors.darkBlue,
              size: 32),
          const SizedBox(height: 8),
          Text(UrbinoL10n.translate('need_help'),
              style: UrbinoTextStyles.bodyTextBold(context).copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? UrbinoColors.gold
                      : UrbinoColors.darkBlue)),
          const SizedBox(height: 4),
          Text(UrbinoL10n.translate('support_msg'),
              style: UrbinoTextStyles.smallText(context),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, bool isSelected,
      {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: isSelected ? UrbinoGradients.primaryButton(context) : null,
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
          style: UrbinoTextStyles.bodyTextBold(context).copyWith(
            color: isSelected
                ? UrbinoColors.white
                : (Theme.of(context).brightness == Brightness.dark
                    ? UrbinoColors.paleBlue
                    : UrbinoColors.darkBlue),
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap ??
            () {
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
      case 'All Properties':
        return Icons.home;
      case 'Studios':
        return Icons.apartment;
      case 'Apartments':
        return Icons.business;
      case 'Rooms':
        return Icons.room_preferences;
      case 'luxury':
        return Icons.star;
      case 'favorites':
        return Icons.favorite;
      default:
        return Icons.home;
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
            Text(UrbinoL10n.translate('welcome'),
                style:
                    UrbinoTextStyles.heading1(context).copyWith(fontSize: 28)),
            const SizedBox(height: 8),
            Text(UrbinoL10n.translate('subtitle'),
                style: UrbinoTextStyles.subtitle(context)),
          ],
        ),
        InkWell(
          onTap: _showFilterDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: UrbinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: UrbinoColors.lightGold.withOpacity(0.5)),
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
                const Icon(Icons.tune_rounded,
                    color: UrbinoColors.darkBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: UrbinoTextStyles.bodyTextBold(context).copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? UrbinoColors.gold
                          : UrbinoColors.darkBlue),
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
        : (_filteredProperties.map((p) => p.price).reduce((a, b) => a + b) /
                _filteredProperties.length)
            .toInt();

    return Row(
      children: [
        Expanded(
            child: _buildStatCard(
                'Active Listings',
                '${_filteredProperties.length}',
                Icons.house_rounded,
                UrbinoColors.darkBlue)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard('Avg. Monthly', '€$avgPrice',
                Icons.payments_outlined, UrbinoColors.brickOrange)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard('Verified', '100%',
                Icons.verified_user_outlined, UrbinoColors.success)),
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
            Text(UrbinoL10n.translate(_selectedCategory),
                style: UrbinoTextStyles.heading2(context)),
            const SizedBox(height: 4),
            Container(height: 2, width: 32, color: UrbinoColors.gold),
          ],
        ),
        Text(
          'Showing ${_filteredProperties.length} results',
          style: UrbinoTextStyles.bodyText(context)
              .copyWith(color: UrbinoColors.warmGray, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPropertyGrid() {
    if (_filteredProperties.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.search_off,
                size: 64, color: UrbinoColors.warmGray),
            const SizedBox(height: 16),
            Text('No properties found',
                style: UrbinoTextStyles.heading2(context)
                    .copyWith(color: UrbinoColors.warmGray)),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters or search query'),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1600)
          crossAxisCount = 5;
        else if (constraints.maxWidth > 1200)
          crossAxisCount = 4;
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PropertyDetailsPage(property: property),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                Text(label, style: UrbinoTextStyles.smallText(context)),
                const SizedBox(height: 4),
                Text(value,
                    style: UrbinoTextStyles.heading2(context).copyWith(
                        fontSize: 20,
                        color: isDark ? UrbinoColors.gold : color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
