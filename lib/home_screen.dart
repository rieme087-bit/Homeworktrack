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
    final colorScheme = Theme.of(context).colorScheme;
    final totalAssignments = _presenter.assignments.length;
    final completedAssignments =
        _presenter.assignments.where((assignment) => assignment.iscompleted).length;
    final percent = totalAssignments == 0
      ? 0.0
      : (completedAssignments / totalAssignments).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework Tracker'),
      ), // AppBar
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              children: [
                Text(
                  'Your progress',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep up the momentum.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: CircularPercentIndicator(
                    radius: 104,
                    lineWidth: 12,
                    percent: percent,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(percent * 100).round()}%',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedAssignments of $totalAssignments',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    progressColor: colorScheme.primary,
                    backgroundColor: Colors.grey.shade300,
                    animation: true,
                    animationDuration: 800,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'ASSIGNMENTS COMPLETED',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.assignment_outlined),
                    title: const Text('Total Assignments'),
                    trailing: Text(
                      '$totalAssignments',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text('Completed Assignments'),
                    trailing: Text(
                      '$completedAssignments',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            ),
    ); // Scaffold
  }
}