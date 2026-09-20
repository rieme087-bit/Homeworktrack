import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class CourseLisrtScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter Presenter = CoursePresenter();

  void _showAddCourseDialog() {
    string name = '';
    String? description;
  }
}