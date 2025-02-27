import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polmitra_admin/models/user.dart';

class Poll {
  final String id;
  final String question;
  final List<String> options;
  final String netaId;
  final PolmitraUser? neta;
  final Map<String, int> responses;
  final List<PolmitraUser> responders;
  final bool isActive;
  final PolmitraUser? createdBy;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  String get totalVotes => responses.values.reduce((summation, element) => summation + element).toString();

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.netaId,
    this.responses = const {},
    this.responders = const [],
    required this.isActive,
    this.neta,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Poll.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Poll(
      id: doc.id,
      question: data['question'] ?? '',
      options: List.from(data['options'] ?? []),
      netaId: data['netaId'] ?? '',
      responses: Map<String, int>.from(data['responses'] ?? {}),
      responders: data['responders'] != null
          ? List<PolmitraUser>.from((data['responders'] as List).map((responder) => PolmitraUser.fromMap(responder)))
          : [],
      isActive: data['isActive'] ?? false,
      neta: data['neta'] != null ? PolmitraUser.fromMap(data['neta']) : null,
      createdBy: data['createdBy'] != null ? PolmitraUser.fromMap(data['createdBy']) : null,
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'netaId': netaId,
      'responses': responses,
      'responders': responders,
      'isActive': isActive,
      'neta': neta?.toMap(),
      'createdBy': createdBy?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Poll copyWith({
    String? question,
    List<String>? options,
    String? netaId,
    Map<String, int>? responses,
    List<PolmitraUser>? responders,
    bool? isActive,
    PolmitraUser? neta,
    Timestamp? updatedAt,
  }) {
    return Poll(
      id: id,
      question: question ?? this.question,
      options: options ?? this.options,
      netaId: netaId ?? this.netaId,
      responses: responses ?? this.responses,
      responders: responders ?? this.responders,
      isActive: isActive ?? this.isActive,
      neta: neta ?? this.neta,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
