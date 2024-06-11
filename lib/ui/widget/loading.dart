import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.4),
      child: Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: Colors.red,
          rightDotColor: Colors.black,
          size: 40,
        ),
      ),
    );
  }
}
