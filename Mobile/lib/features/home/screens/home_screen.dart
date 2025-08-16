import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'User';

  void _logout(BuildContext context) {
    context.read<AuthController>().logout(context);
  }

  Future<String?> fetchUserName() async {
    try {
      final response = await Provider.of<ProfileController>(
        context,
        listen: false,
      ).fetchProfile();
      return response['name'];
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserName().then((name) {
      setState(() {
        userName = name ?? 'User';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final userProfile = profileController.userProfile;
    final isLoading = profileController.isLoading;
    final profilePicUrl = userProfile?['profilePicture'];
    final userInitials = userName.isNotEmpty
        ? userName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: true,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                          child:
                              profilePicUrl != null && profilePicUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(profilePicUrl),
                                )
                              : CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppTheme.primaryColor
                                      .withOpacity(0.12),
                                  child: Text(
                                    userInitials,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: AppTextStyles.body2.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                userName.isNotEmpty
                                    ? userName
                                    : userProfile?['name'] ?? 'User',
                                style: AppTextStyles.heading2.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'logout') {
                              _logout(context);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: AppTheme.errorColor,
                                  ),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('Logout'),
                                ],
                              ),
                            ),
                          ],
                          child: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // AI Assistant Card
                    _buildAIAssistantCard(),
                    const SizedBox(height: 24),
                    // Health Overview Cards
                    _buildHealthOverviewCards(),
                    const SizedBox(height: 24),
                    // Quick Actions
                    _buildQuickActions(context),
                    const SizedBox(height: 24),
                    // AI Insights / Recommendations
                    Text(
                      'AI Insights',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAIInsights(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAIAssistantCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Color(0xFF7C3AED),
                size: 32,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                'How can I help you with your health today?',
                style: AppTextStyles.body1.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.mic_rounded,
                color: Color(0xFF7C3AED),
                size: 28,
              ),
              onPressed: () {},
              tooltip: 'Ask AI',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthOverviewCards() {
    final cards = [
      _buildHealthDashboardCard(
        icon: Icons.favorite_rounded,
        label: 'Vitals',
        value: '72 bpm',
        color: Colors.redAccent,
        subtitle: 'Heart Rate',
      ),
      _buildHealthDashboardCard(
        icon: Icons.mood_rounded,
        label: 'Mood',
        value: '😊',
        color: Colors.orangeAccent,
        subtitle: 'Happy',
      ),
      _buildHealthDashboardCard(
        icon: Icons.nightlight_round,
        label: 'Sleep',
        value: '7.5 h',
        color: Colors.blueAccent,
        subtitle: 'Last Night',
      ),
      _buildHealthDashboardCard(
        icon: Icons.directions_walk_rounded,
        label: 'Activity',
        value: '5,200',
        color: Colors.green,
        subtitle: 'Steps',
      ),
    ];
    return SizedBox(
      // Remove fixed height for flexible cards
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i != 0) const SizedBox(width: 16),
              cards[i],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDashboardCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 6)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.13),
              child: Icon(icon, color: color, size: 28),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.heading2.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: AppTextStyles.body2.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.edit_note_rounded,
        'label': 'Log Symptom',
        'color': Colors.pinkAccent,
        'onTap': () {},
      },
      {
        'icon': Icons.smart_toy_rounded,
        'label': 'Ask AI',
        'color': const Color(0xFF7C3AED),
        'onTap': () {},
      },
      {
        'icon': Icons.calendar_today_rounded,
        'label': 'Book Appt.',
        'color': Colors.teal,
        'onTap': () {},
      },
      {
        'icon': Icons.chat_bubble_rounded,
        'label': 'Start Chat',
        'color': Colors.blueAccent,
        'onTap': () {},
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map(
            (action) => _buildQuickAction(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
              color: action['color'] as Color,
              onTap: action['onTap'] as VoidCallback,
            ),
          )
          .toList(),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color.withOpacity(0.13),
            foregroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    final insights = [
      {
        'icon': Icons.lightbulb_outline_rounded,
        'color': AppTheme.primaryColor,
        'text': 'Tip: Drink water regularly and take short walks.',
      },
      {
        'icon': Icons.favorite_rounded,
        'color': Colors.redAccent,
        'text': 'Your heart rate is in a healthy range today.',
      },
      {
        'icon': Icons.nightlight_round,
        'color': Colors.blueAccent,
        'text': 'You slept 7.5 hours last night. Great job!',
      },
      {
        'icon': Icons.emoji_emotions_rounded,
        'color': Colors.orangeAccent,
        'text': 'Mood: Happy. Keep up the positivity!',
      },
      {
        'icon': Icons.calendar_today_rounded,
        'color': Colors.teal,
        'text': 'Next appointment: Dr. Smith, Mon 10:00 AM.',
      },
    ];
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final item = insights[i];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 170,
                    child: Text(
                      item['text'] as String,
                      style: AppTextStyles.body1.copyWith(
                        color: AppTheme.primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
