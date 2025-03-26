import 'package:flutter/material.dart';

const Color textColor = Color(0xff303030);
class ElevatedBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? disabledColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double elevation;
  final Color shadowColor;
  final Color backgroundColor;

  const ElevatedBtn({
    Key? key,
    required this.text,
    required this.onPressed,
    this.disabledColor,
    this.width,
    this.height,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w900,
    this.borderRadius,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.trailingIcon,
    this.elevation = 7,
    this.backgroundColor= const Color(0xffFEC34E),
    this.shadowColor = const Color(0xaaFEC34E)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width ?? screenWidth * 0.8, // Default width is 90% of screen width
      height: height ?? 50, // Default height is 50
      child: Center(
        child: ElevatedButton(
          onPressed: (isLoading || !isEnabled) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? backgroundColor
                : disabledColor ?? backgroundColor.withOpacity(0.5),
            disabledBackgroundColor:
            disabledColor ?? backgroundColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(50),
            ),
            elevation: isEnabled ? elevation : 0,
            shadowColor: shadowColor,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const DotLoader() // Use the animated DotLoader
                  : Center(child: _buildButtonContent()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (leadingIcon == null && trailingIcon == null) {
      return Text(
        text,
        key: const ValueKey("buttonText"),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: "Avenir",
          color: isEnabled ? textColor : textColor.withOpacity(0.5),
        ),
      );
    }

    return Row(
      key: const ValueKey("buttonWithIcons"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: leadingIcon!,
          ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: "Avenir",
            color: isEnabled ? textColor : textColor.withOpacity(0.5),
          ),
        ),
        if (trailingIcon != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: trailingIcon!,
          ),
      ],
    );
  }
}

class DotLoader extends StatefulWidget {
  const DotLoader({Key? key}) : super(key: key);

  @override
  _DotLoaderState createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Full animation duration
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Create a delay for each dot
              final animationValue = (_controller.value + (index * 0.3)) % 1;
              final scale = animationValue < 0.5
                  ? 1 + (animationValue * 2)
                  : 2 - (animationValue * 2);
              return Transform.scale(
                scale: scale.clamp(0.8, 1.2),
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}
