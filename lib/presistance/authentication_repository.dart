import 'package:aws_auth_bloc/models/user.dart';
import 'package:aws_auth_bloc/presistance/api_provider.dart';

class AuthenticationRepository {
  ApiProvider api = ApiProvider();

  Future<void> signInWithEmailPassword(String email, String password) =>
      api.signInWithEmailPassword(email, password);

  Future<User> getCurrentUser() => api.getCurrentUser();

  Future<void> signOut() => api.signOut();
}
