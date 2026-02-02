import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../models/property.dart';
import '../pages/reservation_page.dart';

/// ========================================
/// PROPERTY CARD WIDGET
/// Card with automatic image slider
/// ========================================

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const PropertyCard({
    Key? key,
    required this.property,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentImageIndex = 0;
  Timer? _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        final nextIndex = (_currentImageIndex + 1) % widget.property.images.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: UrbinoColors.white,
          borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Slider Section
            _buildImageSlider(),
            
            // Property Info Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRating(),
                      Text(
                        '€${widget.property.price}',
                        style: UrbinoTextStyles.bodyTextBold.copyWith(
                          color: UrbinoColors.darkBlue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Title
                  Text(
                    widget.property.title,
                    style: UrbinoTextStyles.bodyTextBold.copyWith(
                      fontSize: 14,
                      color: UrbinoColors.darkGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: UrbinoColors.warmGray,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          widget.property.location,
                          style: UrbinoTextStyles.smallText.copyWith(
                            fontSize: 11,
                            color: UrbinoColors.warmGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Property Details Row
                  Row(
                    children: [
                      _buildDetailIcon(Icons.bed_outlined, '${widget.property.bedrooms}'),
                      const SizedBox(width: 12),
                      _buildDetailIcon(Icons.bathtub_outlined, '${widget.property.bathrooms}'),
                      const SizedBox(width: 12),
                      _buildDetailIcon(Icons.square_foot, '${widget.property.area.toInt()}m²'),
                      const Spacer(),
                      // Action buttons: Details (open sheet) and Reserve (navigate)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: () => _showDetailsSheet(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: UrbinoColors.darkBlue.withOpacity(0.12)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              backgroundColor: UrbinoColors.white,
                            ),
                            child: Text('Détails', style: UrbinoTextStyles.smallText.copyWith(color: UrbinoColors.darkBlue, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _navigateToReservation(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UrbinoColors.gold,
                              foregroundColor: UrbinoColors.darkBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            child: Text('Réserver', style: UrbinoTextStyles.smallText.copyWith(fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: UrbinoColors.warmGray),
        const SizedBox(width: 4),
        Text(
          label,
          style: UrbinoTextStyles.smallText.copyWith(
            fontSize: 12,
            color: UrbinoColors.darkGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider() {
    return Stack(
      children: [
        // Image PageView
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(UrbinoBorderRadius.large),
            topRight: Radius.circular(UrbinoBorderRadius.large),
          ),
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.property.images.length,
              itemBuilder: (context, index) {
                final imagePath = widget.property.images[index];
                if (imagePath.startsWith('http')) {
                  return Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildLoadingPlaceholder();
                    },
                  );
                } else {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
                  );
                }
              },
            ),
          ),
        ),
        
        // Property Type Badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: UrbinoColors.darkBlue.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.property.propertyType,
              style: UrbinoTextStyles.smallText.copyWith(
                color: UrbinoColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        // Heart Icon (Favorite)
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: widget.onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: UrbinoColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: widget.isFavorite ? UrbinoColors.error : UrbinoColors.darkGray,
              ),
            ),
          ),
        ),

        // Page Indicators
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.property.images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 6,
                width: _currentImageIndex == index ? 20 : 6,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? UrbinoColors.gold
                      : UrbinoColors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToReservation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationPage(property: widget.property),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Center(
                      child: Container(
                        width: 50,
                        height: 6,
                        decoration: BoxDecoration(
                          color: UrbinoColors.warmGray.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: PageController(initialPage: _currentImageIndex),
                          itemCount: widget.property.images.length,
                          itemBuilder: (context, index) {
                            return Image.network(widget.property.images[index], fit: BoxFit.cover);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(widget.property.title, style: UrbinoTextStyles.heading2.copyWith(fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Text('€${widget.property.price}', style: UrbinoTextStyles.heading2.copyWith(color: UrbinoColors.darkBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: UrbinoColors.warmGray),
                        const SizedBox(width: 6),
                        Expanded(child: Text(widget.property.location, style: UrbinoTextStyles.smallText)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Specifications
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: UrbinoColors.offWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _specMini(Icons.square_foot, '${widget.property.area.toInt()} m²'),
                          _specMini(Icons.bed_outlined, '${widget.property.bedrooms} chambres'),
                          _specMini(Icons.bathtub_outlined, '${widget.property.bathrooms} salles'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text('Description', style: UrbinoTextStyles.heading2.copyWith(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(widget.property.description, style: UrbinoTextStyles.bodyText.copyWith(height: 1.5)),
                    const SizedBox(height: 20),

                    // Amenities
                    Text('Équipements', style: UrbinoTextStyles.heading2.copyWith(fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _buildDetailChip(Icons.wifi, 'WiFi'),
                        _buildDetailChip(Icons.kitchen, 'Cuisine équipée'),
                        _buildDetailChip(Icons.ac_unit, 'Climatisation'),
                        _buildDetailChip(Icons.local_laundry_service, 'Buanderie'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Fermer'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _navigateToReservation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: UrbinoColors.gold,
                              foregroundColor: UrbinoColors.darkBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Réserver maintenant'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _specMini(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: UrbinoColors.darkBlue, size: 20),
        const SizedBox(height: 6),
        Text(label, style: UrbinoTextStyles.smallText.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: UrbinoColors.paleBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: UrbinoColors.darkBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: UrbinoTextStyles.smallText.copyWith(
              fontSize: 11,
              color: UrbinoColors.darkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    final fullStars = widget.property.rating.floor();
    final hasHalfStar = (widget.property.rating - fullStars) >= 0.5;

    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < fullStars) {
            return const Icon(
              Icons.star,
              size: 16,
              color: UrbinoColors.gold,
            );
          } else if (index == fullStars && hasHalfStar) {
            return const Icon(
              Icons.star_half,
              size: 16,
              color: UrbinoColors.gold,
            );
          } else {
            return Icon(
              Icons.star_outline,
              size: 16,
              color: UrbinoColors.gold.withOpacity(0.3),
            );
          }
        }),
        const SizedBox(width: 4),
        Text(
          widget.property.rating.toStringAsFixed(1),
          style: UrbinoTextStyles.smallText.copyWith(
            fontWeight: FontWeight.w600,
            color: UrbinoColors.darkBlue,
          ),
        ),
      ],
    );
  }


  Widget _buildErrorImage() {
    return Container(
      color: UrbinoColors.lightBeige,
      child: const Center(
        child: Icon(
          Icons.home,
          size: 64,
          color: UrbinoColors.gold,
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: UrbinoColors.lightBeige,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            UrbinoColors.gold,
          ),
        ),
      ),
    );
  }
}
