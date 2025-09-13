import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_service.dart';
import '../../widgets/common/bottom_navigation_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.star, color: Color(0xFF4A90E2), size: 24),
          ),
        ],
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          final user = userService.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildUserProfileCard(
                  user.name,
                  user.height,
                  user.currentWeight,
                  user.tags,
                ),
                const SizedBox(height: 20),
                _buildPledgeSection(context),
                const SizedBox(height: 20),
                _buildChatsSection(context),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationWidget(currentRoute: '/home'),
    );
  }

  Widget _buildUserProfileCard(
    String name,
    String height,
    int weight,
    List<String> tags,
  ) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF4A90E2), width: 3),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/fat_donkey.jpg',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   'Hello, Oct10_115lb',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag('ENTJ', const Color(0xFFE8F4FD)),
                    _buildTag('${height}cm, ${weight}lb', const Color(0xFFF0F0F0)),
                    _buildTag('Aquarius', const Color(0xFFF0F0F0)),
                    _buildTag('Single', const Color(0xFFF0F0F0)),
                    _buildTag('Long-term', const Color(0xFFF0F0F0)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: backgroundColor == const Color(0xFFE8F4FD)
              ? const Color(0xFF4A90E2)
              : Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPledgeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF9500),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'I pledge:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: Add edit functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You cannot edit ID and pledge until you lose 5 lbs!'),
                      backgroundColor: Colors.grey,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.edit, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Eg. Every time I crave for snacks, I will donate 5 dollars to Lay\'s as a tribute.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF4A90E2),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Chats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.add, color: Colors.grey, size: 24),
          ],
        ),
        const SizedBox(height: 16),
        _buildChatItem(
          'Daniel 😊',
          'I thought we\'ve met before',
          '2',
          const Color(0xFF4CAF50),
          context,
        ),
        const SizedBox(height: 12),
        _buildChatItem(
          'Group Chat (9.1 - 10.1)',
          'I am hitting 120lbs today!',
          '4',
          const Color(0xFFFF5722),
          context,
          isGroupChat: true,
          groupChatType: 'weight-loss',
        ),
        const SizedBox(height: 12),
        _buildChatItem(
          'Fitness Motivation Squad',
          'Who\'s joining me for morning workout?',
          '2',
          const Color(0xFF9C27B0),
          context,
          isGroupChat: true,
          groupChatType: 'fitness',
        ),
      ],
    );
  }

  Widget _buildChatItem(
    String name,
    String message,
    String count,
    Color avatarColor,
    BuildContext context, {
    bool isGroupChat = false,
    String? groupChatType,
  }) {
    return GestureDetector(
      onTap: () {
        if (isGroupChat) {
          if (groupChatType == 'fitness') {
            Navigator.pushNamed(context, '/fitness-chat');
          } else {
            Navigator.pushNamed(context, '/group-chat');
          }
        } else {
          Navigator.pushNamed(context, '/chat');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: avatarColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColor,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
