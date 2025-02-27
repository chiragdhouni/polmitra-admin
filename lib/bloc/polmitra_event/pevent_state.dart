import '../../models/event.dart';

abstract class PolmitraEventState {}

class AddEventInitial extends PolmitraEventState {}

class AddEventLoading extends PolmitraEventState {}

class AddEventSuccess extends PolmitraEventState {}

class AddEventFailure extends PolmitraEventState {
  final String error;

  AddEventFailure(this.error);
}

class EventInitial extends PolmitraEventState {}

class EventLoading extends PolmitraEventState {}

class EventsLoaded extends PolmitraEventState {
  final List<Event> events;

  EventsLoaded(this.events);
}

class EventError extends PolmitraEventState {
  final String message;

  EventError(this.message);
}