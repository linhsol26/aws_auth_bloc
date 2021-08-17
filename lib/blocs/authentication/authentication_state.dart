import 'package:aws_auth_bloc/models/user.dart';
import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final User? user;

  AuthenticationAuthenticated({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user!];
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
