import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/screens/login_screen.dart';
import 'package:tmdb/screens/signup_screen.dart';
import 'package:tmdb/utils/invitation_details.dart';
import 'package:tmdb/utils/my_colors.dart';


class AuthenticationScreen extends StatefulWidget {
  final InvitationDetails? invitationDetails;
  const AuthenticationScreen({Key? key, this.invitationDetails})
      : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    //
    if (widget.invitationDetails != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        // show SignUpScreen card
        _toggleCardFlip();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: LoginScreen(
          onSignUpClick: _toggleCardFlip,
        ),
        back: SignUpScreen(
          onSignInClick: _toggleCardFlip,
          invitationDetails: widget.invitationDetails,
        ),
      ),
    );
  }

  void _toggleCardFlip() {
    cardKey.currentState!.toggleCard();
  }
}
