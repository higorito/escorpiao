import 'package:escorpionico_proj/src/theme/theme.dart';
import 'package:flutter/material.dart';

class DocumentBoxWidget extends StatelessWidget {
  const DocumentBoxWidget({
    super.key,
    required this.uploaded,
    required this.icon,
    required this.labels,
    this.onTap,
  });

  final bool uploaded;
  final Widget icon;
  final String labels;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: onTap,
          child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: uploaded ? AppTheme.lightOrange : Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppTheme.orangeColor),
    ),
    child: Column(
      children: [
        Expanded(flex: 4, child: icon ) ,
        Expanded(
          child: Text(
            labels,
            style: TextStyle(
              color: uploaded ? Colors.orange : AppTheme.orangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
          ),
        );
  }
}
