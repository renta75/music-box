import 'package:flutter/material.dart';
import '../global/colors.dart';
import '../models/review.dart';

class ReviewDialog extends StatelessWidget {
  const ReviewDialog({Key? key, required this.review}) : super(key: key);

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text("Review Details")))
        ]),
        body: SingleChildScrollView(
            child: Card(
          child: Column(
            children: [
              Container(
                  child: Text(
                    review.author!,
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                  alignment: Alignment.centerLeft),
              Text(
                review.content!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: colorBlackGradient92,
        )));
  }
}
