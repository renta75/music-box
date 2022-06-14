import 'package:flutter/material.dart';
import 'package:tmdb/blocs/authentication_cubit/authentication_cubit.dart';

class LogoffScreen extends StatefulWidget {
  const LogoffScreen({Key? key, required this.cubit}) : super(key: key);
  final AuthenticationCubit cubit;

  @override
  State<LogoffScreen> createState() => _LogoffScreenState();
}

class _LogoffScreenState extends State<LogoffScreen> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign off',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                widget.cubit.logout();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
              ),
              child: const Text(
                'Sign off',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
