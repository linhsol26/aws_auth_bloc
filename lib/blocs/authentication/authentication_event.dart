import 'package:aws_auth_bloc/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class UserLoggedIn extends AuthenticationEvent {
  final User? user;

  UserLoggedIn({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user!];
}

class UserLoggedOut extends AuthenticationEvent {}
