import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../presenters/assignment_presenter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _presenter.loadAssignments();
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAssignments = _presenter.assignments.length;
    final completedAssignments =
        _presenter.assignments.where((assignment) => assignment.iscompleted).length;
    final percent = totalAssignments == 0
      ? 0.0
      : (completedAssignments / totalAssignments).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: const Text('Homework Tracker'),
      ), // AppBar
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircularPercentIndicator(
                        radius: 120.0, // Larger size
                        lineWidth: 14.0,
                        percent: percent,
                        center: Text(
                          '${(percent * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ), // TextStyle
                        ), // Text
                        progressColor: Colors.purple,
                        backgroundColor: Colors.grey.shade300,
                        animation: true,
                        animationDuration: 800,
                        footer: const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Assignments Completed'),
                        ), // Padding
                      ), // CircularPercentIndicator
                    ), // Center
                    const SizedBox(height: 40),
                    Card(
                      child: ListTile(
                        title: const Text('Total Assignments'),
                        trailing: Text('$totalAssignments'),
                      ), // ListTile
                    ), // Card
                    Card(
                      child: ListTile(
                        title: const Text('Completed Assignments'),
                        trailing: Text('$completedAssignments'),
                      ), // ListTile
                    ), // Card
                  ],
                ), // Column
              ), // Padding
    ); // Scaffold
  }
}