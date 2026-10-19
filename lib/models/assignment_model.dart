import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Assignment {
  final String? id;
  final String title;
  bool iscompleted;
  final String courseName;

  Assignment({
    this.id,
    required this.title,
    required this.courseName,
    this.iscompleted = false,
  });

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  static Future<List<Assignment>> loadAssignments() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final snapshot = await _db.child('assignments/$userId').get();
    final List<Assignment> assignments = [];

    if (snapshot.exists) {
      final data = Map<Object?, Object?>.from(snapshot.value as Map);
      data.forEach((key, value) {
        final assignmentData = Map<String, dynamic>.from(value as Map);
        assignments.add(Assignment(
          id: key.toString(),
          title: assignmentData['title'],
          courseName: assignmentData['courseName'] ?? 'Unknown',
          iscompleted: assignmentData['iscompleted'] ?? false,
        ));
      });
    }
    return assignments;
  }

  static Future<String?> saveAssignment(Assignment assignment, String courseName) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return null;
    }

    final newRef = _db.child('assignments/$userId').push();
    await newRef.set({
      'title': assignment.title,
      'courseName' : courseName,
      'iscompleted': assignment.iscompleted,
    });
    return newRef.key;
  }

  static Future<void> updateCompletionStatus(
    String assignmentId,
    bool iscompleted,
  ) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    await _db
        .child('assignments/$userId/$assignmentId')
        .update({'iscompleted': iscompleted});
  }

  static Future<void> deleteAssignment(String assignmentId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    await _db.child('assignments/$userId/$assignmentId').remove();
  }

  static Future<List<Assignment>> fetchAssignments() => loadAssignments();

  static Future<String?> addAssignment(String title, String courseName) async {
    return saveAssignment(
      Assignment(title: title, courseName: courseName),
      courseName,
    );
  }
}





    
    
