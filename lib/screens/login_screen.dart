import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:tmdb/utils/app_routes.dart';
import 'package:tmdb/utils/my_colors.dart';
import 'package:tmdb/utils/my_fields_validations.dart';
import 'package:tmdb/utils/my_text_styles.dart';
import 'package:tmdb/widgets/confirm_button.dart';
import 'package:tmdb/widgets/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  final Function onSignUpClick;
  const LoginScreen({required this.onSignUpClick});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _rememberFocusNode = FocusNode();
  final _confirmFocusNode = FocusNode();
  final _cancelFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool rememberLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _cancelFocusNode.dispose();
    _rememberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Beamer.of(context).beamToNamed(AppRoutes.home);
        } else {
          Beamer.of(context).beamToNamed(AppRoutes.root);
        }
        if (state is AuthenticationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Wrong Credentials")));
        }
      },
      child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: MyColors.backgroundColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_buildLoginForm(state)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthenticationState state) {
    return Form(
      key: _formKey,
      child: Container(
        height: 810,
        width: 552,
        child: Card(
          color: MyColors.backgroundCardColor,
          elevation: 10,
          child: state is AuthenticationAuthenticating
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Text(
                        "Welcome to MusicBox",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Averta',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Please Log In",
                        style: TextStyle(
                            color: Colors.white.withOpacity(.6),
                            fontSize: 12,
                            fontFamily: 'Averta'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextFormField(
                        controller: _emailController,
                        label: "Email",
                        fieldValidator: MyFieldValidations.validateEmail,
                        autofocus: true,
                        expanded: true,
                        focusNode: _emailFocusNode,
                        nextFocus: _passwordFocusNode,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MyTextFormField(
                        controller: _passwordController,
                        label: "Password",
                        isPasswordField: true,
                        fieldValidator: MyFieldValidations.validatePassword,
                        expanded: true,
                        focusNode: _passwordFocusNode,
                        nextFocus: _confirmFocusNode,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ConfirmButton(
                        onPressed: () {
                          var error = MyFieldValidations.validateEmail(
                              context, _emailController.value.text);
                          _formKey.currentState!.validate();
                          if (error == null) {
                            // context.read<AuthenticationCubit>().redirectToLoginPage();
                            context.read<AuthenticationCubit>().makeLogin(
                                email: _emailController.value.text,
                                password: _passwordController.value.text);
                          }
                        },
                        title: "Login",
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildRememberLoginButton() {
    return [
      Checkbox(
        value: rememberLogin,
        onChanged: (selected) {
          setState(
            () {
              rememberLogin = selected!;
            },
          );
        },
      ),
      TextButton(
        focusNode: _rememberFocusNode,
        onPressed: () {
          setState(() {
            rememberLogin = !rememberLogin;
          });
        },
        child: Text(
          "Remember Me!",
          style: MyTextStyles.dataTableText
              .copyWith(color: MyColors.cardTextColor),
        ),
      )
    ];
  }
  
}
