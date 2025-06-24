import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colours.dart';

class ScoreBoardScreen extends StatelessWidget {
  final int wins;
  final int losses;
  final int draws;

  const ScoreBoardScreen({
    Key? key,
    required this.wins,
    required this.losses,
    required this.draws,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.06;

    TextStyle customFontWhite = GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: baseFontSize * 0.6,
        letterSpacing: 2,
      ),
    );

    TextStyle titleFontWhite = GoogleFonts.coiny(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: baseFontSize * 2.0,
        fontWeight: FontWeight.bold,
      ),
    );

    // Determine the maximum score so we can scale the bars accordingly
    final maxScore = [wins, losses, draws].reduce((a, b) => a > b ? a : b);
    // Avoid division by zero:
    final adjustedMax = maxScore == 0 ? 1 : maxScore;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('resources/BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Score Board',
                  style: titleFontWhite,
                  textAlign: TextAlign.center,
                ),

                // Replace the Table with three horizontal bars
                Column(
                  children: [
                    _buildBarRow(
                      label: "Wins",
                      value: wins,
                      maxValue: adjustedMax,
                      style: customFontWhite,
                    ),
                    SizedBox(height: 16),
                    _buildBarRow(
                      label: "Losses",
                      value: losses,
                      maxValue: adjustedMax,
                      style: customFontWhite,
                    ),
                    SizedBox(height: 16),
                    _buildBarRow(
                      label: "Draws",
                      value: draws,
                      maxValue: adjustedMax,
                      style: customFontWhite,
                    ),
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainColor.accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to Game',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: baseFontSize * 0.9,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBarRow({
    required String label,
    required int value,
    required int maxValue,
    required TextStyle style,
  }) {
    final double fraction = value / maxValue;

    return Row(
      children: [
        // Label (e.g. "Wins")
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: style,
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(width: 12),

        // Progress bar
        Expanded(
          flex: 6,
          child: LinearProgressIndicator(
            value: fraction,
            color: Colors.greenAccent,
            backgroundColor: Colors.grey.withOpacity(0.3),
            minHeight: 20,
          ),
        ),
        SizedBox(width: 12),

        // Value (e.g. 5)
        Expanded(
          flex: 1,
          child: Text(
            value.toString(),
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
