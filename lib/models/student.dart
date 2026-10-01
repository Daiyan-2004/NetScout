import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id; // Firebase uid
  final String name;
  final String department;
  final bool isVerified;
  final String studentId;
  final String email;
  final String? batch;
  final DateTime? createdAt;

  const Student({
    required this.id,
    required this.name,
    required this.department,
    this.isVerified = false,
    this.studentId = '',
    this.email = '',
    this.batch,
    this.createdAt,
  });

  factory Student.fromMap(
      String id,
      Map<String, dynamic> map, {
        bool isVerified = false,
      }) {
    final created = map['createdAt'];
    return Student(
      id: id,
      name: (map['name'] ?? '') as String,
      department: (map['department'] ?? '') as String,
      isVerified: isVerified,
      studentId: (map['studentId'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      batch: map['batch'] as String?,
      createdAt: created is Timestamp ? created.toDate() : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'studentId': studentId,
    'email': email,
    'department': department,
    'batch': batch,
    'createdAt': FieldValue.serverTimestamp(),
  };
}