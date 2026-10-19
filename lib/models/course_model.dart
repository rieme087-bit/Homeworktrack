import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;
  final String? description;

  Course({required this.id, required this.name, this.description});

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<Course>> fetchCourses() async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return [];

  final snapshot = await _firestore
      .collection('courses')
      .where('userId', isEqualTo: userId)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return Course(
      id: doc.id,
      name: data['name'],
      description: data['description'],
    );
  }).toList();
}

static Future<String?> addCourse(String name, String? description) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return null;

  final document = await _firestore.collection('courses').add({
    'name': name,
    'description': description,
    'userId': userId,
  });
  return document.id;
}

static Future<void> deleteCourse(String courseId) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  final course = _firestore.collection('courses').doc(courseId);
  final snapshot = await course.get();
  if (snapshot.data()?['userId'] != userId) {
    throw StateError('Cannot delete a course that does not belong to the user.');
  }
  await course.delete();
}
}