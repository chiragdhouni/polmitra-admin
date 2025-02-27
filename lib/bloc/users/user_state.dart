import 'package:polmitra_admin/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UsersLoaded extends UserState {
  final List<PolmitraUser> users;

  UsersLoaded(this.users);
}
