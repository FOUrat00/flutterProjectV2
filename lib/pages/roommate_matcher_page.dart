import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../data/mock_data.dart';

class RoommateMatcherPage extends StatefulWidget {
  const RoommateMatcherPage({Key? key}) : super(key: key);

  @override
  State<RoommateMatcherPage> createState() => _RoommateMatcherPageState();
}

class _RoommateMatcherPageState extends State<RoommateMatcherPage> {
  int _currentIndex = 0;

  void _nextRoommate() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % MockData.roommates.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roommate = MockData.roommates[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤝 Roommate Matcher'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: UrbinoGradients.primaryButton(context),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find your ideal housemate in Urbino',
                style: UrbinoTextStyles.heading2(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildMatcherCard(roommate),
              const SizedBox(height: 48),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatcherCard(Map<String, dynamic> roommate) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(UrbinoBorderRadius.xlarge),
        boxShadow: [UrbinoShadows.elevated],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(UrbinoBorderRadius.xlarge)),
            child: Image.network(
              roommate['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(roommate['name'],
                        style: UrbinoTextStyles.heading1(context)
                            .copyWith(fontSize: 24)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: UrbinoColors.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(roommate['major'],
                          style: UrbinoTextStyles.labelText(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Habits', style: UrbinoTextStyles.bodyTextBold(context)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (roommate['habits'] as List)
                      .map((h) => _tag(h, UrbinoColors.darkBlue))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text('Hobbies', style: UrbinoTextStyles.bodyTextBold(context)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (roommate['hobbies'] as List)
                      .map((h) => _tag(h, UrbinoColors.brickOrange))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Chip(
      label: Text(label,
          style: const TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleButton(Icons.close, UrbinoColors.error, () => _nextRoommate()),
        const SizedBox(width: 32),
        _circleButton(Icons.favorite, UrbinoColors.success, () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('It\'s a Match! 🎉 Start chatting now.')));
          _nextRoommate();
        }),
      ],
    );
  }

  Widget _circleButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [UrbinoShadows.medium],
          border: Border.all(color: color.withOpacity(0.2), width: 2),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}
