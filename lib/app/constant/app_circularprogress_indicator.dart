import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  final Widget? icon;
  final double size;
  final double shakeDistance;
  final Duration duration;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showPulseEffect;
  final bool showRotation;
  final AnimationStyle animationStyle;

  const CustomProgressIndicator({
    super.key,
    this.icon,
    this.size = 64,
    this.shakeDistance = 6,
    this.duration = const Duration(milliseconds: 800),
    this.backgroundColor,
    this.iconColor,
    this.showPulseEffect = true,
    this.showRotation = true,
    this.animationStyle = AnimationStyle.combined,
  });

  @override
  State<CustomProgressIndicator> createState() =>
      _CustomProgressIndicatorState();
}

enum AnimationStyle {
  shakeOnly,
  pulseOnly,
  rotateOnly,
  combined,
  bounce,
  wave,
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    // Create animations based on selected style
    _setupAnimations();
  }

  void _setupAnimations() {
    switch (widget.animationStyle) {
      case AnimationStyle.shakeOnly:
        _shakeAnimation = Tween<double>(
          begin: -widget.shakeDistance,
          end: widget.shakeDistance,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutSine,
        ));
        break;

      case AnimationStyle.pulseOnly:
        _scaleAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.1), weight: 50),
          TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 0.9), weight: 50),
        ]).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;

      case AnimationStyle.rotateOnly:
        _rotationAnimation = Tween<double>(
          begin: 0,
          end: 2 * math.pi,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        break;

      case AnimationStyle.combined:
        _shakeAnimation = Tween<double>(
          begin: -widget.shakeDistance,
          end: widget.shakeDistance,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutSine,
        ));

        _scaleAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.05), weight: 50),
          TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 0.95), weight: 50),
        ]).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        if (widget.showRotation) {
          _rotationAnimation = Tween<double>(
            begin: 0,
            end: math.pi * 2,
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.linear,
          ));
        }
        break;

      case AnimationStyle.bounce:
        _bounceAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween<double>(begin: 0, end: -12), weight: 25),
          TweenSequenceItem(tween: Tween<double>(begin: -12, end: 0), weight: 25),
          TweenSequenceItem(tween: Tween<double>(begin: 0, end: -6), weight: 25),
          TweenSequenceItem(tween: Tween<double>(begin: -6, end: 0), weight: 25),
        ]).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;

      case AnimationStyle.wave:
        _opacityAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 1.0), weight: 50),
          TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.3), weight: 50),
        ]).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.primaryColor.withOpacity(0.1);
    final iconColor = widget.iconColor ?? theme.primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        Widget animatedChild = child!;

        // Apply animations based on style
        switch (widget.animationStyle) {
          case AnimationStyle.shakeOnly:
            animatedChild = Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: animatedChild,
            );
            break;

          case AnimationStyle.pulseOnly:
            animatedChild = Transform.scale(
              scale: _scaleAnimation.value,
              child: animatedChild,
            );
            break;

          case AnimationStyle.rotateOnly:
            animatedChild = Transform.rotate(
              angle: _rotationAnimation.value,
              child: animatedChild,
            );
            break;

          case AnimationStyle.combined:
            animatedChild = Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: widget.showRotation
                    ? Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: animatedChild,
                )
                    : animatedChild,
              ),
            );
            break;

          case AnimationStyle.bounce:
            animatedChild = Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: animatedChild,
            );
            break;

          case AnimationStyle.wave:
            animatedChild = Opacity(
              opacity: _opacityAnimation.value,
              child: animatedChild,
            );
            break;
        }

        return animatedChild;
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            if (widget.showPulseEffect)
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Center(
          child: ClipOval(
            child: SizedBox(
              width: widget.size * 0.6,
              height: widget.size * 0.6,
              child: IconTheme(
                data: IconThemeData(color: iconColor),
                child: Image.asset(
                  'assets/images/samadhantra_applogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      )

    );
  }
}