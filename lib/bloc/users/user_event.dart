abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class UpdateUserActiveStatus extends UserEvent {
  final String userId;
  final bool isActive;

  UpdateUserActiveStatus(this.userId, this.isActive);
}