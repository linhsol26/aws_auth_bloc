import 'package:aws_auth_bloc/blocs/authentication/authentication_bloc.dart';
import 'package:aws_auth_bloc/blocs/authentication/authentication_event.dart';
import 'package:aws_auth_bloc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Id: ${widget.user.email}',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                // Add UserLoggedOut to authentication event stream.
                authBloc.add(UserLoggedOut());
              },
            )
          ],
        ),
      ),
    );
  }
}
