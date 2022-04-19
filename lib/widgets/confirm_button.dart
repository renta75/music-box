import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool canClick;

  const ConfirmButton({
    required this.onPressed,
    this.canClick = true,
    this.title = 'Confirm',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: canClick ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xff49AD16)),
        minimumSize: MaterialStateProperty.all(Size(121, 37)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // <-- Radius
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        ),
      ),
      child: Text(
        '$title',
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
