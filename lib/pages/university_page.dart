import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../services/news_service.dart';

class UniversityPage extends StatefulWidget {
  const UniversityPage({Key? key}) : super(key: key);

  @override
  State<UniversityPage> createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('🎓 University Life'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: UrbinoGradients.primaryButton(context),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: UrbinoColors.gold,
          indicatorWeight: 4,
          labelStyle: UrbinoTextStyles.bodyTextBold(context),
          unselectedLabelStyle: UrbinoTextStyles.bodyText(context),
          tabs: const [
            Tab(text: 'Academics'),
            Tab(text: 'Events'),
            Tab(text: 'Campus Life'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAcademicsTab(),
          _buildEventsTab(),
          _buildCampusLifeTab(),
        ],
      ),
    );
  }

  Widget _buildAcademicsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _sectionTitle('Critical Deadlines'),
        _deadlineItem('Exam Enrollment', 'Feb 15, 2026', Icons.assignment_late,
            UrbinoColors.error),
        _deadlineItem('Scholarship Application', 'Mar 01, 2026',
            Icons.account_balance_wallet, UrbinoColors.warning),
        _deadlineItem('Thesis Proposal', 'Mar 15, 2026',
            Icons.description_outlined, UrbinoColors.darkBlue),
        const SizedBox(height: 32),
        _sectionTitle('Quick Access'),
        _buildQuickAccessGrid(),
      ],
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _sectionTitle('Upcoming Events'),
        _eventCard(
          'Renaissance Gala',
          'Palazzo Ducale • Friday 20:00',
          'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=600&auto=format&fit=crop',
          'A formal evening celebrating Urbino\'s heritage.',
        ),
        _eventCard(
          'Erasmus Welcome Party',
          'Urbino Center • Saturday 22:00',
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=600&auto=format&fit=crop',
          'The biggest international student gathering of the semester.',
        ),
        _eventCard(
          'Hack Urbino 2026',
          'Scientific Pole • Mar 12, 09:00',
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=600&auto=format&fit=crop',
          '48 hours of innovation and coding in the heart of Italy.',
        ),
      ],
    );
  }

  Widget _buildCampusLifeTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _sectionTitle('Mensa Daily Menu'),
        _buildMensaCard(),
        const SizedBox(height: 32),
        _sectionTitle('Library Occupancy'),
        _buildLibraryStatus('Central Library', 0.85, UrbinoColors.error),
        _buildLibraryStatus(
            'Scientific Pole Library', 0.30, UrbinoColors.success),
        const SizedBox(height: 32),
        _sectionTitle('Local News'),
        FutureBuilder<List<NewsItem>>(
          future: NewsService().fetchNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Failed to load news: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No news available.');
            }
            return Column(
              children: snapshot.data!
                  .map((news) => _newsItem(news.title, 'Just now'))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: UrbinoColors.gold,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(title,
              style: UrbinoTextStyles.heading2(context).copyWith(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _deadlineItem(String title, String date, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: UrbinoTextStyles.bodyTextBold(context)),
        subtitle:
            Text('Due: $date', style: UrbinoTextStyles.smallText(context)),
        trailing: TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added $title to calendar')),
            );
          },
          icon: const Icon(Icons.edit_calendar, size: 18),
          label: const Text('Add'),
          style: TextButton.styleFrom(foregroundColor: UrbinoColors.darkBlue),
        ),
      ),
    );
  }

  Widget _eventCard(
      String title, String info, String imageUrl, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [UrbinoShadows.soft],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: UrbinoColors.paleBlue,
                child: const Icon(Icons.image,
                    size: 40, color: UrbinoColors.darkBlue),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: UrbinoTextStyles.bodyTextBold(context)
                            .copyWith(fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: UrbinoColors.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('STUDENT RATE',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: UrbinoColors.darkBlue)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: UrbinoColors.warmGray),
                    const SizedBox(width: 4),
                    Text(info, style: UrbinoTextStyles.smallText(context)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(description,
                    style: UrbinoTextStyles.bodyText(context)
                        .copyWith(fontSize: 14)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: UrbinoColors.darkBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('I\'M INTERESTED'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {},
                      color: Theme.of(context).brightness == Brightness.dark
                          ? UrbinoColors.gold
                          : UrbinoColors.darkBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _quickAccessItem('Course Catalog', Icons.book_outlined),
        _quickAccessItem('ESSE3 Login', Icons.vpn_key_outlined),
        _quickAccessItem('Email (Outlook)', Icons.email_outlined),
        _quickAccessItem('Student Wifi', Icons.wifi_protected_setup),
      ],
    );
  }

  Widget _quickAccessItem(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UrbinoColors.gold.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: UrbinoColors.gold, size: 20),
          const SizedBox(width: 8),
          Text(title,
              style: UrbinoTextStyles.smallText(context)
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMensaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: UrbinoColors.gold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant, color: UrbinoColors.brickOrange),
              const SizedBox(width: 8),
              Text('Duchi Mensa - Today\'s Special',
                  style: UrbinoTextStyles.bodyTextBold(context)),
            ],
          ),
          const Divider(height: 24),
          Text('• Lasagna alla Bolognese (Traditional)',
              style: UrbinoTextStyles.bodyText(context)),
          Text('• Grilled Vegetables & Scamorza (V)',
              style: UrbinoTextStyles.bodyText(context)),
          const SizedBox(height: 12),
          const Text('Price for students: €3.50',
              style: TextStyle(
                  color: UrbinoColors.success, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLibraryStatus(String name, double occupancy, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: UrbinoTextStyles.bodyTextBold(context)),
            Text('${(occupancy * 100).toInt()}% Full',
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: occupancy,
            backgroundColor: UrbinoColors.paleBlue,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _newsItem(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: UrbinoColors.paleBlue,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.article_outlined,
                color: UrbinoColors.gold, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text,
                    style: UrbinoTextStyles.bodyTextBold(context)
                        .copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
