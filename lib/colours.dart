import 'package:flutter/material.dart';

class MainColor {
  static Color primaryColor = const Color(0xFFff4b4b);
  static Color secondaryColor = const Color.fromARGB(255, 250, 218, 124);
  static Color accentColor = const Color(0xFF4169e8);
  static Color backgroundColor = const Color(0xFF292B4D);
  static Color gridBackgroundColor = Color.fromARGB(188, 70, 70, 70);
  static Color xColor = Color.fromARGB(255, 255, 255, 255);
  static Color oColor = Color.fromARGB(255, 255, 255, 255);
  static Color liteText = const Color.fromARGB(255, 111, 71, 255);
  static Color topicColor1 = Color.fromARGB(202, 255, 0, 200);
  static Color box1color = Color.fromARGB(255, 0, 11, 85); // #000b55
  static Color box2color = Color.fromARGB(255, 111, 71, 255);
  static Color wincolor = Color.fromARGB(204, 179, 255, 0);
  static Color white = Color.fromARGB(255, 255, 255, 255);
  static Color seaGreen = Color.fromARGB(255, 0, 151, 178);
  static Color litePurple = const Color.fromARGB(255, 140, 0, 255);

  // Gradient colors for winning cells glow
  static List<Color> winGradientColors = [
    Color.fromARGB(255, 187, 0, 0), // Bright red-ish
    Color.fromARGB(255, 251, 255, 5), // Yellowish
  ];

  // Glow adjustment properties (all defined here)
  static List<Color> winGlowGradientColors = winGradientColors;
  static double winGlowOpacity = 0.8; // Opacity (0.0 - 1.0)
  static double winGlowBlurRadius = 30.0; // Blur radius for softness
  static double winGlowSpreadRadius = 10.0; // Spread radius for size
  static int winGlowSpeed = 3; // Animation duration (in seconds)
}
