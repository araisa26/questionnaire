import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String buttonLabel;
  final Function onPressed;
  final bool isPrimary;

  const Button.primary({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
  }) : isPrimary = true;

  const Button.accent({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
  }) : isPrimary = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isPrimary
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.secondary,
        ),
        shape: WidgetStateProperty.all(null),
      ),
      onPressed: () => onPressed(),
      child: Text(
        buttonLabel,
        style: isPrimary
            ? TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.secondary,
              )
            : const TextStyle(
                fontWeight: FontWeight.w700,
              ),
      ),
    );
  }
}
