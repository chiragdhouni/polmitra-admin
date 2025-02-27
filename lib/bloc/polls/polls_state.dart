import 'package:polmitra_admin/models/poll.dart';

abstract class PollState {}

class PollInitial extends PollState {}

class PollLoading extends PollState {}

class PollError extends PollState {
  final String message;

  PollError(this.message);
}

class PollsLoaded extends PollState {
  final List<Poll> polls;

  PollsLoaded(this.polls);
}
