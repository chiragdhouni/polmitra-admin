import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polmitra_admin/bloc/polls/polls_event.dart';
import 'package:polmitra_admin/bloc/polls/polls_state.dart';
import 'package:polmitra_admin/models/poll.dart';
import 'package:polmitra_admin/services/user_service.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  final FirebaseFirestore firestore;
  final UserService userService;

  PollBloc(this.firestore, this.userService) : super(PollInitial()) {
    on<LoadPolls>(_onLoadPolls);
    on<UpdatePollActiveStatus>(_onUpdatePollActiveStatus);
  }

  FutureOr<void> _onLoadPolls(LoadPolls event, Emitter<PollState> emit) async {
    emit(PollLoading());
    try {
      final querySnapshot = await firestore.collection('polls').get();

      final polls = querySnapshot.docs.map((doc) => Poll.fromDocument(doc)).toList();
      emit(PollsLoaded(polls));
    } catch (e) {
      emit(PollError(e.toString()));
    }
  }

  FutureOr<void> _onUpdatePollActiveStatus(UpdatePollActiveStatus event, Emitter<PollState> emit) async {
    try {
      await firestore.collection('polls').doc(event.pollId).update({'isActive': event.isActive});

      if (state is PollsLoaded) {
        final polls = (state as PollsLoaded).polls.map((poll) {
          if (poll.id == event.pollId) {
            return poll.copyWith(isActive: event.isActive);
          }
          return poll;
        }).toList();
        emit(PollsLoaded(polls));
      }
    } catch (e) {
      emit(PollError(e.toString()));
    }
  }
}
