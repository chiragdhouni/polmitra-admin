import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/auth/auth_event.dart';
import 'package:polmitra_admin/bloc/auth/auth_state.dart';
import 'package:polmitra_admin/enums/user_enums.dart';
import 'package:polmitra_admin/models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthBloc(this._auth, this._firestore) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  FutureOr<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final user = userCredential.user;
      log("User : ${userCredential.user?.uid}");
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc("lzybasultfNUL6n6fd3HWFO0w1i1")
            .get();
        log("user doc : ${userDoc.data()}");
        final finalUser = PolmitraUser.fromDocument(userDoc);

        if (finalUser.role == UserRole.superadmin.toString()) {
          emit(AuthSuccess(user: PolmitraUser.fromDocument(userDoc)));
        } else {
          emit(const AuthFailure(error: 'User not found'));
        }
      } else {
        emit(const AuthFailure(error: 'User not found'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
