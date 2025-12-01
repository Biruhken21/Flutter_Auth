import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NewcomerAppBar(title: 'Jobs'),
      body: const Center(
        child: Text(
          'Jobs Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
