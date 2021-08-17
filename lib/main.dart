import 'package:aws_auth_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_state.dart';
import 'package:aws_auth_bloc/pages/home_page.dart';
import 'package:aws_auth_bloc/pages/login_page.dart';
import 'package:aws_auth_bloc/presistance/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'amplifyconfiguration.dart';
import 'blocs/authentication/authentication_event.dart';

void main() => runApp(RepositoryProvider<AuthenticationRepository>(
      create: (context) {
        return AuthenticationRepository();
      },
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authRepo =
              RepositoryProvider.of<AuthenticationRepository>(context);
          return AuthenticationBloc(authRepo)..add(AppLoaded());
        },
        child: MyApp(),
      ),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }

    setState(() {
      _amplifyConfigured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.black,
        home: _amplifyConfigured
            ? BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return HomePage(user: state.user!);
                  }
                  return LoginPage();
                },
              )
            : Center(child: Text('Not config amp.')));
  }
}
