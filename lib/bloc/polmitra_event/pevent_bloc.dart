import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_event.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_state.dart';
import 'package:polmitra_admin/models/event.dart';
import 'package:polmitra_admin/services/prefs_services.dart';
import 'package:polmitra_admin/services/user_service.dart';

class EventBloc extends Bloc<PolmitraEvent, PolmitraEventState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final UserService userService;

  EventBloc(this.firestore, this.storage, this.userService)
      : super(AddEventInitial()) {
    on<LoadEvents>(_loadEvents);
    on<UpdateEventActiveStatus>(_onUpdateEventActiveStatus);
  }

  FutureOr<void> _loadEvents(
      LoadEvents event, Emitter<PolmitraEventState> emit) async {
    emit(EventLoading());
    try {
      final snapshot = await firestore.collection('events').get();

      final events =
          snapshot.docs.map((doc) => Event.fromDocument(doc)).toList();

      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateEventActiveStatus(
      UpdateEventActiveStatus event, Emitter<PolmitraEventState> emit) async {
    try {
      await firestore
          .collection('events')
          .doc(event.eventId)
          .update({'isActive': event.isActive});

      if (state is EventsLoaded) {
        final updatedEvents = (state as EventsLoaded).events.map((e) {
          if (e.id == event.eventId) {
            return e.copyWith(
                isActive: event
                    .isActive); // Assuming Event model has a copyWith method
          }
          return e;
        }).toList();

        for (var event in updatedEvents) {
          // update user points
          var karyaKarta = event.karyakarta;
          var userApprovedEvents = updatedEvents
              .where((eventPred) =>
                  event.karyakarta?.uid == karyaKarta?.uid &&
                  eventPred.isActive)
              .length;

          var updatedUser = karyaKarta?.copyWith(points: userApprovedEvents);
          if (updatedUser != null) {
            await userService.updateUser(updatedUser);
            await PrefsService.saveUser(updatedUser);
          }
        }

        emit(EventsLoaded(updatedEvents));
      }
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
