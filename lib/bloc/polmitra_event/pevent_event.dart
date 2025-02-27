
abstract class PolmitraEvent {}

class LoadEvents extends PolmitraEvent {

  LoadEvents();
}

class UpdateEventActiveStatus extends PolmitraEvent {
  final String eventId;
  final bool isActive;

  UpdateEventActiveStatus(this.eventId, this.isActive);
}
