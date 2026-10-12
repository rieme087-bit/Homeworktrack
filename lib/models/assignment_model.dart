import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Assignment {
  final String? id;
  final String title;
  bool iscompleted;

  Assignment({this.id, required this.title, this.iscompleted = false});

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
          title: assignmentData['title'] as String,
          iscompleted: assignmentData['iscompleted'] as bool? ?? false,
        ));
      });
    }
    return assignments;
  }

  static Future<String?> saveAssignment(Assignment assignment) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return null;
    }

    final newRef = _db.child('assignments/$userId').push();
    await newRef.set({
      'title': assignment.title,
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

  static Future<List<Assignment>> fetchAssignments() => loadAssignments();

  static Future<String?> addAssignment(String title) =>
      saveAssignment(Assignment(title: title));
}





    
    
