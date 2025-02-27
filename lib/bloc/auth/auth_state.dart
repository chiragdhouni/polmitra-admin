import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:polmitra_admin/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final PolmitraUser user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SignUpSuccess extends AuthState {
  final User user;
  final String role;

  const SignUpSuccess({required this.user, required this.role});

  @override
  List<Object> get props => [user, role];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}
