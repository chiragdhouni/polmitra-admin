import 'package:cloud_firestore/cloud_firestore.dart';

class PolmitraUser {
  final String uid;
  final String netaId;
  final PolmitraUser? neta;
  final String email;
  final String languagePreference;
  final String role;
  final bool isActive;
  final String name;
  final int? points;

  PolmitraUser(
      {required this.uid,
      required this.netaId,
      required this.email,
      required this.languagePreference,
      required this.role,
      required this.isActive,
      required this.name,
      this.neta,
      this.points});

  factory PolmitraUser.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PolmitraUser(
        uid: doc.id,
        netaId: data['netaId'] ?? '',
        email: data['email'] ?? '',
        languagePreference: data['languagePreference'] ?? '',
        role: data['role'] ?? '',
        isActive: data['isActive'] ?? true,
        neta: data['neta'] != null ? PolmitraUser.fromMap(data['neta']) : null,
        name: data['name'] ?? '',
        points: data['points'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'netaId': netaId,
      'email': email,
      'languagePreference': languagePreference,
      'role': role,
      'isActive': isActive,
      'neta': neta?.toMap(),
      'name': name,
      'points': points
    };
  }

  PolmitraUser copyWith(
      {String? netaId,
      String? email,
      String? languagePreference,
      String? role,
      bool? isActive,
      PolmitraUser? neta,
      String? name,
      int? points}) {
    return PolmitraUser(
        uid: uid,
        netaId: netaId ?? this.netaId,
        email: email ?? this.email,
        languagePreference: languagePreference ?? this.languagePreference,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        neta: neta,
        name: name ?? this.name,
        points: points ?? this.points);
  }

  factory PolmitraUser.fromMap(Map<String, dynamic> input) {
    return PolmitraUser(
        uid: input['uid'] ?? '',
        netaId: input['netaId'] ?? '',
        email: input['email'] ?? '',
        languagePreference: input['languagePreference'] ?? '',
        role: input['role'] ?? '',
        isActive: input['isActive'] ?? true,
        neta: input['neta'] != null ? PolmitraUser.fromMap(input['neta']) : null,
        name: input['name'] ?? '',
        points: input['points'] ?? 0);
  }
}
