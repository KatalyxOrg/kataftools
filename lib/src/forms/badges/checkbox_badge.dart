import 'package:flutter/material.dart';

class CheckboxBadge extends StatelessWidget {
  const CheckboxBadge({super.key, required this.isChecked, required this.onCheck, required this.title});

  final bool isChecked;
  final Function(bool) onCheck;

  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onCheck(!isChecked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isChecked ? Theme.of(context).colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(100)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: isChecked ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
