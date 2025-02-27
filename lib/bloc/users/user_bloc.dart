import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polmitra_admin/bloc/users/user_event.dart';
import 'package:polmitra_admin/bloc/users/user_state.dart';
import 'package:polmitra_admin/models/user.dart';
import 'package:polmitra_admin/services/prefs_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore firestore;

  UserBloc(this.firestore) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUserActiveStatus>(_onUpdateUserActiveStatus);
  }

  FutureOr<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final querySnapshot = await firestore.collection('users').get();

      final userId = await PrefsService.getUserId();

      final userFutures = querySnapshot.docs.map((doc) async {
        return PolmitraUser.fromDocument(doc);
      }).toList();

      final users = await Future.wait(userFutures);

      users.removeWhere((element) => element.uid == userId);

      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateUserActiveStatus(UpdateUserActiveStatus event, Emitter<UserState> emit) async {
    try {
      await firestore.collection('users').doc(event.userId).update({'isActive': event.isActive});

      if (state is UsersLoaded) {
        final updatedUsers = (state as UsersLoaded).users.map((user) {
          if (user.uid == event.userId) {
            return user.copyWith(isActive: event.isActive); // Assuming copyWith method is defined in User model
          }
          return user;
        }).toList();
        emit(UsersLoaded(updatedUsers));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
