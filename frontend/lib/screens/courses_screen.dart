import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../models/course.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Course> _allCourses = [
    Course(id: '1', title: 'Flutter Basics', description: 'Learn the basics of Flutter.', imageUrl: 'https://picsum.photos/id/1011/300/200'),
    Course(id: '2', title: 'Advanced Dart', description: 'Deep dive into Dart programming.', imageUrl: 'https://picsum.photos/id/1012/300/200'),
    Course(id: '3', title: 'State Management', description: 'Explore state management solutions.', imageUrl: 'https://picsum.photos/id/1013/300/200'),
  ];
  final List<Course> _wjCourses = [
    Course(
      id: 'wj1',
      title: 'Brain Storming Course',
      description: 'Learn creative brainstorming techniques.',
      imageUrl: 'https://picsum.photos/seed/brainstorm/300/200',
    ),
    Course(
      id: 'wj2',
      title: 'Wrong Journey Courses',
      description: 'Learn from mistakes and wrong paths.',
      imageUrl: 'https://picsum.photos/seed/wrongjourney/300/200',
    ),
  ];
  List<Course> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredCourses = List.from(_allCourses);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterCourses(String query) {
    setState(() {
      _filteredCourses = _allCourses
          .where((c) => c.title.toLowerCase().contains(query.toLowerCase())
              || c.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewcomerAppBar(title: 'Courses'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCourses,
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'All Courses (${_filteredCourses.length})'),
              Tab(text: 'Your Courses (${_allCourses.where((c) => c.isSubscribed).length})'),
              Tab(text: 'wj_courses (${_wjCourses.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseList(_filteredCourses),
                _buildCourseList(_allCourses.where((c) => c.isSubscribed).toList()),
                _buildCourseListView(_wjCourses),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses found.'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  course.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(course.isSubscribed ? 'Unsubscribe' : 'Subscribe'),
                        onPressed: () {
                          setState(() {
                            course.isSubscribed = !course.isSubscribed;
                            _filteredCourses = List.from(_allCourses);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourseListView(List<Course> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses available.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                course.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(course.title),
            subtitle: Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  course.isSubscribed = !course.isSubscribed;
                  _filteredCourses = List.from(_allCourses);
                });
              },
              child: Text(course.isSubscribed ? 'Unsubscribe' : 'Subscribe'),
            ),
          ),
        );
      },
    );
  }
}
