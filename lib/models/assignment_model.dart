class Assignment {
  final String title;
  bool iscompleted;
  
  Assignment({
    required this.title,
    this.iscompleted = false,
  });

  static Future<Object?> fetchAssignments() async {}

  static Future<void> addAssignment(String title) async {}

  static Future<void> updateCompletionStatus(int index, List<Assignment> assignments) async {}
}