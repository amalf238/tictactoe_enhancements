import 'package:flutter/material.dart';
import 'colours.dart';

/// WinningCellGlow creates an animated gradient glow effect for a widget,
/// using glow properties defined in MainColor.
class WinningCellGlow extends StatefulWidget {
  final Widget child;
  const WinningCellGlow({Key? key, required this.child}) : super(key: key);

  @override
  _WinningCellGlowState createState() => _WinningCellGlowState();
}

class _WinningCellGlowState extends State<WinningCellGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: MainColor.winGlowSpeed),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: MainColor.winGlowGradientColors[0]
          .withOpacity(MainColor.winGlowOpacity),
      end: MainColor.winGlowGradientColors[1]
          .withOpacity(MainColor.winGlowOpacity),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value ?? MainColor.winGlowGradientColors[0],
                MainColor.winGlowGradientColors[1],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _colorAnimation.value!
                    .withOpacity(MainColor.winGlowOpacity),
                blurRadius: MainColor.winGlowBlurRadius,
                spreadRadius: MainColor.winGlowSpreadRadius,
              ),
            ],
          ),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

/// SpinningWidget rotates its child continuously.
class SpinningWidget extends StatefulWidget {
  final Widget child;
  const SpinningWidget({Key? key, required this.child}) : super(key: key);

  @override
  _SpinningWidgetState createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<SpinningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}
