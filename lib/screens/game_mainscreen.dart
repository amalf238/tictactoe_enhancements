import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../animations.dart'; // Import our centralized animations.
import '../colours.dart';
import '../gameModes.dart';
import '../winner.dart';
import 'scoreBoardScreen.dart';
import 'selectGameModeScreen.dart';

class GameScreen extends StatefulWidget {
  final bool isHardMode;
  final bool isMediumMode;
  final String userAvatarPath; // Selected user avatar (for X)

  const GameScreen({
    Key? key,
    this.isHardMode = false,
    this.isMediumMode = false,
    required this.userAvatarPath,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> displayXO = List.generate(9, (_) => '');
  List<int> matchedIndexes = [];
  String resultDeclaration = '';
  List<Map<String, dynamic>> moveHistory = [];
  int userWins = 0;
  int userLosses = 0;
  int userDraws = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('resources/BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                children: [
                  // Title
                  SizedBox(
                    height: screenWidth * 0.12,
                    child: Center(
                      child: Text(
                        widget.isHardMode
                            ? 'Tic Tac Toe | Hard'
                            : widget.isMediumMode
                                ? 'Tic Tac Toe | Medium'
                                : 'Tic Tac Toe | Easy',
                        style: GoogleFonts.coiny(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 3,
                            fontSize: baseFontSize * 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Grid of game cells
                  SizedBox(
                    height: screenWidth * 1.0,
                    child: GridView.builder(
                      itemCount: 9,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: screenWidth * 0.02,
                        crossAxisSpacing: screenWidth * 0.02,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        bool isWinningCell = matchedIndexes.contains(index);

                        // Build the content of the cell (image for X/O)
                        Widget content = _buildCellImage(displayXO[index]);
                        if (isWinningCell) {
                          // Wrap the image with spinning effect from animations.dart
                          content = SpinningWidget(child: content);
                        }

                        // Build the cell container with border etc.
                        Widget cell = Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: screenWidth * 0.005,
                              color: Colors.white,
                            ),
                            color: isWinningCell
                                ? null // background provided by the glow effect
                                : displayXO[index] == 'X'
                                    ? MainColor.box1color
                                    : displayXO[index] == 'O'
                                        ? MainColor.box2color
                                        : MainColor.gridBackgroundColor,
                          ),
                          child: Center(child: content),
                        );
                        if (isWinningCell) {
                          // Wrap winning cells in animated gradient glow from animations.dart
                          cell = WinningCellGlow(child: cell);
                        }
                        return GestureDetector(
                          onTap: () => _tapped(index),
                          child: cell,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Result text
                  Text(
                    resultDeclaration,
                    style: GoogleFonts.coiny(
                      textStyle: TextStyle(
                        color: Colors.white,
                        letterSpacing: 3,
                        fontSize: baseFontSize * 1.2,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: _undoLastMove,
                    icon: const Icon(Icons.undo, color: Colors.white),
                    tooltip: 'Undo last move',
                    iconSize: 40,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.accentColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 19,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScoreBoardScreen(
                            wins: userWins,
                            losses: userLosses,
                            draws: userDraws,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Score Board',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: baseFontSize * 0.9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.accentColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 19,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelectGameModeScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Change Game Mode',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: baseFontSize * 0.9,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the widget to display inside a cell:
  /// - For 'X', shows the user's chosen avatar.
  /// - For 'O', shows robot.png.
  /// - Otherwise, empty.
  Widget _buildCellImage(String cellValue) {
    if (cellValue == 'X') {
      return Image.asset(
        widget.userAvatarPath,
        fit: BoxFit.contain,
      );
    } else if (cellValue == 'O') {
      return Image.asset(
        'resources/robot.png',
        fit: BoxFit.contain,
      );
    } else {
      return Container();
    }
  }

  void _tapped(int index) {
    if (displayXO[index].isNotEmpty) return;
    if (checkWinner(displayXO) != null) return;

    setState(() {
      displayXO[index] = 'X';
      moveHistory.add({'index': index, 'symbol': 'X'});
    });

    _checkWinnerAndShowDialog();

    if (checkWinner(displayXO) == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (checkWinner(displayXO) == null) {
          _appPlaysO();
        }
      });
    }
  }

  void _appPlaysO() {
    if (checkWinner(displayXO) != null) return;

    int? moveIndex;
    if (widget.isMediumMode) {
      moveIndex = mediumAIMove(displayXO);
    } else if (widget.isHardMode) {
      moveIndex = hardAIMove(displayXO);
    } else {
      moveIndex = easyAIMove(displayXO);
    }

    if (moveIndex == null) {
      _checkWinnerAndShowDialog();
      return;
    }

    setState(() {
      displayXO[moveIndex!] = 'O';
      moveHistory.add({'index': moveIndex, 'symbol': 'O'});
    });

    _checkWinnerAndShowDialog();
  }

  void _checkWinnerAndShowDialog() {
    final String? winner = checkWinner(displayXO);
    if (winner == 'X' || winner == 'O') {
      if (winner == 'X') {
        userWins++;
      } else {
        userLosses++;
      }
      matchedIndexes = _getWinningIndices(winner!);
      setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        if (checkWinner(displayXO) == winner) {
          showWinnerDialog(
            context,
            winner,
            isSinglePlayer: true,
            onReset: _resetBoard,
          );
        }
      });
    } else if (winner == 'Draw') {
      userDraws++;
      matchedIndexes = [];
      setState(() {});
      showWinnerDialog(
        context,
        'Draw',
        isSinglePlayer: true,
        onReset: _resetBoard,
      );
    }
  }

  List<int> _getWinningIndices(String symbol) {
    List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var condition in winningConditions) {
      if (displayXO[condition[0]] == symbol &&
          displayXO[condition[1]] == symbol &&
          displayXO[condition[2]] == symbol) {
        return condition;
      }
    }
    return [];
  }

  void _undoLastMove() {
    if (moveHistory.isEmpty) return;
    setState(() {
      final lastMove = moveHistory.removeLast();
      displayXO[lastMove['index']] = '';

      // If the undone move belonged to the AI, also revert the preceding
      // player move so the board state stays consistent.
      if (lastMove['symbol'] == 'O' && moveHistory.isNotEmpty) {
        final previousMove = moveHistory.removeLast();
        displayXO[previousMove['index']] = '';
      }

      matchedIndexes.clear();
      resultDeclaration = '';
    });
  }

  void _resetBoard() {
    setState(() {
      displayXO = List.generate(9, (_) => '');
      matchedIndexes.clear();
      resultDeclaration = '';
      moveHistory.clear();
    });
  }
}
