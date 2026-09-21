import 'package:flutter/material.dart';
import 'package:homework_tracker/Presenters/course_presenter.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter presenter = CoursePresenter();

  void _showAddCourseDialog() {
    String name = '';
    String? description;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter course name',
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter course description (optional)',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final trimmedName = name.trim();
                if (trimmedName.isNotEmpty) {
                  setState(() {
                    presenter.addCourse(trimmedName, description: description);
                  });
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
  final courses = presenter.courses;

    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course.name),
            subtitle: course.description != null ? Text(course.description!) : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}