import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable button that applies the app's primary styling and a subtle scale
/// animation on press. It adapts to the current theme (light/dark) by using the
/// colors defined in [TransControlTheme].
class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool isOutlined;

  const StyledButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.roboto(),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          );

    final button = isOutlined
        ? OutlinedButton(onPressed: onPressed, style: style ?? baseStyle, child: child)
        : ElevatedButton(onPressed: onPressed, style: style ?? baseStyle, child: child);

    // Apply a subtle scale animation on tap using flutter_animate
    return button.animate().scale(begin: 1.0, end: 0.96, duration: 100.ms, curve: Curves.easeOut);
  }
}
