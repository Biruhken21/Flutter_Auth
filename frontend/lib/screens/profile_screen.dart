import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../widgets/app_bar.dart';
import '../models/user.dart';
import '../models/startup.dart';
import '../models/work_item.dart';
import '../utils/theme.dart';
import '../widgets/startup_card.dart';
import '../widgets/work_item_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data for startups
  final List<Startup> _relatedStartups = [
    Startup(
      id: '1',
      name: 'TechInnovate',
      description: 'AI-powered solutions for small businesses',
      industry: 'AI',
      stage: 'Seed',
    ),
    Startup(
      id: '2',
      name: 'GreenEco',
      description: 'Sustainable energy solutions for residential buildings',
      industry: 'CleanTech',
      stage: 'Series A',
    ),
    Startup(
      id: '3',
      name: 'HealthPlus',
      description: 'Digital health platform for remote patient monitoring',
      industry: 'HealthTech',
      stage: 'Pre-seed',
    ),
  ];
  
  // Mock data for work items
  final List<WorkItem> _relatedWorks = [
    WorkItem(
      id: '1',
      title: 'Mobile App Development',
      description: 'Developing a cross-platform mobile application for fitness tracking',
      category: 'Development',
      status: 'In Progress',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      imageUrl: 'https://picsum.photos/id/1/300/200',
    ),
    WorkItem(
      id: '2',
      title: 'UI/UX Design Project',
      description: 'Designing user interface for a new e-commerce platform',
      category: 'Design',
      status: 'Completed',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      imageUrl: 'https://picsum.photos/id/20/300/200',
    ),
    WorkItem(
      id: '3',
      title: 'Startup Idea Validation',
      description: 'Market research and validation for a new fintech startup concept',
      category: 'Research',
      status: 'Planning',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      imageUrl: 'https://picsum.photos/id/48/300/200',
    ),
  ];

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
    // Mock user data
    final user = User(
      id: 'user1',
      username: 'username',
      role: 'Developer',
      followerCount: 125,
      promiseCount: 48,
      cofounderCount: 7,
    );

    return Scaffold(
      appBar: const NewcomerAppBar(title: 'Profile'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.role,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(user.followerCount.toString(), 'Followers'),
                _buildStatColumn(user.promiseCount.toString(), 'Promises'),
                _buildStatColumn(user.cofounderCount.toString(), 'Cofounders'),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Similar Startups'),
              Tab(text: 'Similar Works'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts Tab
                Center(
                  child: Text(
                    'No posts yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                
                // Startups Tab
                _relatedStartups.isEmpty
                    ? Center(
                        child: Text(
                          'No similar startups',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _relatedStartups.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: StartupCard(
                              startup: _relatedStartups[index],
                              onTap: () {
                                // Handle startup tap
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selected startup: ${_relatedStartups[index].name}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                
                // Works Tab
                _relatedWorks.isEmpty
                    ? Center(
                        child: Text(
                          'No similar works',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _relatedWorks.length,
                        itemBuilder: (context, index) {
                          return WorkItemCard(
                            workItem: _relatedWorks[index],
                            onTap: () {
                              // Handle work item tap
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected work: ${_relatedWorks[index].title}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
