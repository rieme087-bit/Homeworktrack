import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class Assignment {
  final String title;
  bool iscompleted;
  
  Assignment({required this.title, this.iscompleted = false,});

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  static Future<List<Assignment>> loadAssignments() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final snapshot = await _db.child('assignments/userId').get();
    final List<Assignment> assignments = [];
    
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        assignments.add(Assignment(
          title: value['title'],
          iscompleted: value['iscompleted'],
        ));
      });
    }
    return assignments;
  }

  static Future<void> saveAssignment(Assignment assignment) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return;
    }

    final newRef = _db.child('assignments/$userId').push();
    await newRef.set({
      'title': assignment.title,
      'iscompleted': assignment.iscompleted,
    });
  }
  static Future<void> updateCompletionStatus(String assignmentId, bool iscompleted) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) 
      return;

      final snapshot = await _db.child('assignments/$userId').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final entry = data.entries.firstWhere((entry) => entry.key == assignmentId);
        final ref = _db.child('assignments/$userId/${entry.key}');
        final updatedStatus = iscompleted;
        await ref.update({
          'iscompleted': updatedStatus,
        });
      }
  }
}

    
    
