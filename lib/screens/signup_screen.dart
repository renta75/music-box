import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:tmdb/utils/invitation_details.dart';
import 'package:tmdb/utils/my_colors.dart';
import 'package:tmdb/utils/my_fields_validations.dart';
import 'package:tmdb/utils/my_text_styles.dart';
import 'package:tmdb/widgets/confirm_button.dart';
import 'package:tmdb/widgets/my_text_form_field.dart';


class SignUpScreen extends StatefulWidget {
  final Function onSignInClick;
  final InvitationDetails? invitationDetails;

  const SignUpScreen({
    required this.onSignInClick,
    this.invitationDetails,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _email2FocusNode = FocusNode();
  final _password2FocusNode = FocusNode();
  final _confirmPassword2FocusNode = FocusNode();
  final _name2FocusNode = FocusNode();
  final _companyName2FocusNode = FocusNode();
  final _accountName2FocusNode = FocusNode();
  final _confirm2FocusNode = FocusNode();
  final _controller = ScrollController();
  bool isInvitation = false;
  String? invitationUrl;

  @override
  void initState() {
    super.initState();

    // handle registration for Invitation
    final invitationDetails = widget.invitationDetails;
    if (invitationDetails != null) {
      //
      isInvitation = true;
      invitationUrl = invitationDetails.invitationUrl;

      var fullName = '${invitationDetails.name}  ${invitationDetails.lastName}';

      _emailController.text = invitationDetails.email!;
      _nameController.text = fullName;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _companyNameController.dispose();
    _accountNameController.dispose();
    _accountNameController.dispose();
    _email2FocusNode.dispose();
    _name2FocusNode.dispose();
    _password2FocusNode.dispose();
    _companyName2FocusNode.dispose();
    _confirmPassword2FocusNode.dispose();
    _accountName2FocusNode.dispose();
    _confirm2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  _buildSignUpForm(state)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSignUpForm(AuthenticationState state) {
    return Form(
        key: _formKey,
        child: Container(
          width: 552,
          height: 1080,
          child: Card(
            color: MyColors.backgroundCardColor,
            elevation: 10,
            child: (state is AuthenticationSigningUp ||
                    state is AuthenticationAuthenticating)
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
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
                          "Sign Up Instruction",
                          style: TextStyle(
                              color: Colors.white.withOpacity(.6),
                              fontSize: 12,
                              fontFamily: 'Averta'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            MyTextFormField(
                              autofocus: true,
                              focusNode: _name2FocusNode,
                              nextFocus: _email2FocusNode,
                              controller: _nameController,
                              label: "Name",
                              expanded: true,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyTextFormField(
                              focusNode: _email2FocusNode,
                              nextFocus: _password2FocusNode,
                              controller: _emailController,
                              label: "Email",
                              fieldValidator: MyFieldValidations.validateEmail,
                              expanded: true,
                              readOnly: isInvitation,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyTextFormField(
                              focusNode: _password2FocusNode,
                              nextFocus: _confirmPassword2FocusNode,
                              controller: _passwordController,
                              label: "Password",
                              isPasswordField: true,
                              fieldValidator:
                                  MyFieldValidations.validatePassword,
                              expanded: true,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyTextFormField(
                              focusNode: _confirmPassword2FocusNode,
                              nextFocus: _companyName2FocusNode,
                              controller: _confirmPasswordController,
                              label:
                                  "Password again",
                              isPasswordField: true,
                              fieldValidator: (BuildContext context,
                                  String? passwordConfirmation) {
                                if (_passwordController.value.text !=
                                    passwordConfirmation) {
                                  return "Password is not correct";
                                }
                                return null;
                              },
                              expanded: true,
                            ),
                          ],
                        ),

                        //
                        if (isInvitation == false) ...[
                          Row(
                            children: [
                              MyTextFormField(
                                focusNode: _companyName2FocusNode,
                                nextFocus: _accountName2FocusNode,
                                controller: _companyNameController,
                                label: "Company Name",
                                expanded: true,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MyTextFormField(
                                focusNode: _accountName2FocusNode,
                                nextFocus: _confirm2FocusNode,
                                controller: _accountNameController,
                                label: "Account Name",
                                expanded: true,
                              ),
                            ],
                          ),
                        ],
                        SizedBox(
                          height: 20,
                        ),
                        ConfirmButton(
                          onPressed: () {
                            var error = MyFieldValidations.validateEmail(
                                context, _emailController.value.text);
                            _formKey.currentState!.validate();
                            if (error == null) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              final name = _nameController.text;
                              String? companyName = _companyNameController.text;
                              String? accountName = _accountNameController.text;

                              if (isInvitation) {
                                companyName = null;
                                accountName = null;
                              }
                              context.read<AuthenticationCubit>().signup(
                                    email: email,
                                    password: password,
                                    name: name,
                                    companyName: companyName,
                                    accountName: accountName,
                                    invitattionUrl: invitationUrl,
                                  );
                            }
                          },
                          title: "Sign Up",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _buildLoginButton(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildAzureRegistrationButton(),
                      ],
                    ),
                  ),
          ),
        ));
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onSignInClick();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF585876),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              "LogIn",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAzureRegistrationButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AZURE AD REGISTRATION',
                style: MyTextStyles.dataTableViewAll.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: 170,
                color: MyColors.mobilityOneLightGreenColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
