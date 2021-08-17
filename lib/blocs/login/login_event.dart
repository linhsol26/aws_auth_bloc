import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithEmailPasswordButtonPressed extends LoginEvent {
  final String email, password;

  LoginWithEmailPasswordButtonPressed(
      {required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
