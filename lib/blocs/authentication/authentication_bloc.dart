import 'package:aws_auth_bloc/blocs/authentication/authentication_event.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_state.dart';
import 'package:aws_auth_bloc/presistance/authentication_repository.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    } 
    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    } 
    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();

    try {
      final currentUser = await _authenticationRepository.getCurrentUser();

      if (currentUser.name != '') {
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(error: e.toString());
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authenticationRepository.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
