import 'package:aws_auth_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_event.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_state.dart';
import 'package:aws_auth_bloc/blocs/login/login_bloc.dart';
import 'package:aws_auth_bloc/blocs/login/login_event.dart';
import 'package:aws_auth_bloc/blocs/login/login_state.dart';
import 'package:aws_auth_bloc/presistance/api_provider.dart';
import 'package:aws_auth_bloc/presistance/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amplify_flutter/amplify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiProvider api = ApiProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // signUp();
  }

  signUp() async {
    // await api.signUpWithEmailPassword('nhglinh263@gmail.com', 'Linh1234@');
    await Amplify.Auth.confirmSignUp(
        username: 'nhglinh263@gmail.com', confirmationCode: '626416');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            final authBloc = BlocProvider.of<AuthenticationBloc>(context);
            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }
            if (state is AuthenticationFailure) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(state.error),
                  TextButton(
                    child: Text('Retry'),
                    onPressed: () {
                      authBloc.add(AppLoaded());
                    },
                  )
                ],
              ));
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService =
        RepositoryProvider.of<AuthenticationRepository>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        _loginBloc.add(LoginWithEmailPasswordButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Email is required.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        isDense: true,
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null) {
                          return 'Password is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      child: Text('LOG IN'),
                      onPressed:
                          state is LoginLoading ? () {} : _onLoginButtonPressed,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
