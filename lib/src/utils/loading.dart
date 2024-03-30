import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RiveAnimation.asset(
        'assets/icons/now_loading.riv',
        fit: BoxFit.cover,
      ),
    );
  }
}
