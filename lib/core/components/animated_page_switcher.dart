import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

// Enumeration for available animation styles
enum AnimationStyle {
  sharedAxis,
  sharedAxisHorizontal,
  sharedAxisVertical,
  fadeThrough,
  fadeScale,
  containerTransform,
}

class TransitionWidget extends StatelessWidget {
  const TransitionWidget({
    super.key,
    required this.child,
    this.animationStyle = AnimationStyle.sharedAxis, // Default animation style
  });

  final Widget child;
  final AnimationStyle animationStyle;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        switch (animationStyle) {
          case AnimationStyle.sharedAxis:
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              fillColor: Colors.transparent,
              child: child,
            );
          case AnimationStyle.sharedAxisHorizontal:
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Colors.transparent,
              child: child,
            );
          case AnimationStyle.sharedAxisVertical:
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Colors.transparent,
              child: child,
            );
          case AnimationStyle.fadeThrough:
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              fillColor: Colors.transparent,
              child: child,
            );
          case AnimationStyle.fadeScale:
            return FadeScaleTransition(
              animation: primaryAnimation,
              child: child,
            );
          case AnimationStyle.containerTransform:
            // Note: ContainerTransform is a different kind of transition
            // typically used for shared element transitions between UI elements
            // Its implementation will differ from the others
            return Container(
              // Placeholder for container transform logic
              child: child,
            );
          default:
            return child;
        }
      },
      child: child,
    );
  }
}
