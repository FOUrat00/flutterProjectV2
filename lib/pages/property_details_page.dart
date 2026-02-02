import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/property.dart';
import 'reservation_page.dart';
import '../services/favorites_manager.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Property property;

  const PropertyDetailsPage({Key? key, required this.property})
      : super(key: key);

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? UrbinoColors.deepNavy : UrbinoColors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      backgroundColor: UrbinoColors.darkBlue,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: Icon(
                _favoritesManager.isFavorite(widget.property)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoritesManager.isFavorite(widget.property)
                    ? UrbinoColors.error
                    : Colors.white,
              ),
              onPressed: () =>
                  _favoritesManager.toggleFavorite(widget.property),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) =>
                  setState(() => _currentImageIndex = index),
              itemCount: widget.property.images.length,
              itemBuilder: (context, index) {
                final imagePath = widget.property.images[index];
                if (imagePath.startsWith('http')) {
                  return Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  );
                } else {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.property.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentImageIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? UrbinoColors.gold
                          : Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: UrbinoColors.paleBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.property.propertyType,
                  style: UrbinoTextStyles.bodyTextBold(context).copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? UrbinoColors.gold
                        : UrbinoColors.darkBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: UrbinoColors.gold, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    widget.property.rating.toString(),
                    style: UrbinoTextStyles.bodyTextBold(context)
                        .copyWith(fontSize: 16),
                  ),
                  Text(
                    ' (12 reviews)',
                    style: UrbinoTextStyles.smallText(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(widget.property.title,
              style: UrbinoTextStyles.heading2(context)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: UrbinoColors.warmGray, size: 18),
              const SizedBox(width: 4),
              Text(widget.property.location,
                  style: UrbinoTextStyles.subtitle(context)
                      .copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 32),
          _buildSpecifications(),
          const SizedBox(height: 32),
          Text('Description',
              style: UrbinoTextStyles.heading2(context).copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          Text(
            widget.property.description,
            style: UrbinoTextStyles.bodyText(context).copyWith(height: 1.6),
          ),
          const SizedBox(height: 32),
          _buildAvailabilityCalendar(),
          const SizedBox(height: 32),
          _buildAmenities(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UrbinoColors.lightGold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _specItem(
              Icons.square_foot, '${widget.property.area.toInt()} m²', 'Area'),
          _specItem(
              Icons.bed_outlined, '${widget.property.bedrooms}', 'Bedrooms'),
          _specItem(Icons.bathtub_outlined, '${widget.property.bathrooms}',
              'Bathrooms'),
        ],
      ),
    );
  }

  Widget _specItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon,
            color: Theme.of(context).brightness == Brightness.dark
                ? UrbinoColors.gold
                : UrbinoColors.darkBlue,
            size: 24),
        const SizedBox(height: 8),
        Text(value, style: UrbinoTextStyles.bodyTextBold(context)),
        Text(label, style: UrbinoTextStyles.smallText(context)),
      ],
    );
  }

  Widget _buildAmenities() {
    final List<Map<String, dynamic>> amenities = [
      {'icon': Icons.wifi, 'label': 'High-speed WiFi'},
      {'icon': Icons.ac_unit, 'label': 'Air Conditioning'},
      {'icon': Icons.kitchen, 'label': 'Equipped Kitchen'},
      {'icon': Icons.local_laundry_service, 'label': 'Laundry'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What this place offers',
            style: UrbinoTextStyles.heading2(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        ...amenities
            .map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(a['icon'],
                          color: UrbinoColors.darkBlue.withOpacity(0.7),
                          size: 20),
                      const SizedBox(width: 12),
                      Text(a['label'],
                          style: UrbinoTextStyles.bodyText(context)),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '€${widget.property.price}',
                style: UrbinoTextStyles.heading2(context).copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? UrbinoColors.gold
                      : UrbinoColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('Total per month',
                  style: UrbinoTextStyles.smallText(context)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReservationPage(property: widget.property),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Check Availability'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Availability Calendar',
            style: UrbinoTextStyles.heading2(context).copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: UrbinoColors.lightGold.withOpacity(0.3)),
            boxShadow: const [UrbinoShadows.soft],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('February 2026',
                      style: UrbinoTextStyles.bodyTextBold(context)),
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {}),
                    ],
                  )
                ],
              ),
              const Divider(),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 28,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  // Mock some booked days
                  final isBooked = [5, 6, 12, 13, 14, 20, 21].contains(day);
                  return Container(
                    decoration: BoxDecoration(
                      color: isBooked
                          ? UrbinoColors.error.withOpacity(0.1)
                          : UrbinoColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBooked
                            ? UrbinoColors.error.withOpacity(0.3)
                            : UrbinoColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isBooked
                              ? UrbinoColors.error
                              : UrbinoColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _calendarLegend(UrbinoColors.success, 'Available'),
                  const SizedBox(width: 24),
                  _calendarLegend(UrbinoColors.error, 'Booked'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _calendarLegend(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: UrbinoTextStyles.smallText(context)),
      ],
    );
  }
}
