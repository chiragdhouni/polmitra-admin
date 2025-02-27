import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polmitra_admin/models/user.dart';
import 'package:polmitra_admin/enums/user_enums.dart';

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<PolmitraUser>> getUsersByNetaId(String netaId) async {
    try {
      final querySnapshot = await firestore.collection('users').where('netaId', isEqualTo: netaId).get();

      final users = querySnapshot.docs.map((doc) => PolmitraUser.fromDocument(doc)).toList();
      return users;
    } catch (e) {
      // Handle errors (e.g., print error message, throw exception)
      return []; // Return empty list on error
    }
  }

  Future<List<PolmitraUser>> getUsersByRole(UserRole role) async {
    try {
      final querySnapshot = await firestore.collection('users').where('role', isEqualTo: role.toString()).get();

      final users = querySnapshot.docs.map((doc) => PolmitraUser.fromDocument(doc)).toList();
      return users;
    } catch (e) {
      // Handle errors (e.g., print error message, throw exception)
      return []; // Return empty list on error
    }
  }

  Future<PolmitraUser?> getUserById(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      return PolmitraUser.fromDocument(doc);
    } catch (e) {
      return null; // Return null on error
    }
  }

  Future<void> updateUser(PolmitraUser user) async {
    try {
      await firestore.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      // Handle errors (e.g., print error message, throw exception)
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).delete();
    } catch (e) {
      // Handle errors (e.g., print error message, throw exception)
    }
  }
}
