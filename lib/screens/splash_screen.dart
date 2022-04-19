import 'package:flutter/material.dart';
import 'package:tmdb/utils/my_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const Material(
      
      color: MyColors.backgroundColor,
      child: CircularProgressIndicator(),
    );
  }
}
