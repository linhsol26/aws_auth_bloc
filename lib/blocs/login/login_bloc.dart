import 'package:aws_auth_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_event.dart';
import 'package:aws_auth_bloc/blocs/login/login_event.dart';
import 'package:aws_auth_bloc/blocs/login/login_state.dart';
import 'package:aws_auth_bloc/presistance/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationRepository _authenticationRepository;

  LoginBloc(AuthenticationBloc authenticationBloc,
      AuthenticationRepository authenticationRepository)
      : _authenticationBloc = authenticationBloc,
        _authenticationRepository = authenticationRepository,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithEmailPasswordButtonPressed) {
      yield* _mapLoginWithEmailPasswordToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailPasswordToState(
      LoginWithEmailPasswordButtonPressed event) async* {
    yield LoginLoading();

    try {
      await _authenticationRepository.signInWithEmailPassword(
          event.email, event.password);
      final user = await _authenticationRepository.getCurrentUser();
      if (user.name != '') {
        _authenticationBloc.add(UserLoggedIn(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Login Failed.');
      }
    } catch (e) {
      yield LoginFailure(error: e.toString());
    }
  }
}
