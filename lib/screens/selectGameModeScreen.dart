import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colours.dart';
import 'game_mainscreen.dart';

class SelectGameModeScreen extends StatefulWidget {
  const SelectGameModeScreen({Key? key}) : super(key: key);

  @override
  State<SelectGameModeScreen> createState() => _SelectGameModeScreenState();
}

class _SelectGameModeScreenState extends State<SelectGameModeScreen> {
  // List of game modes (dropdown items)
  final List<String> modes = ['Easy Mode', 'Medium Mode', 'Hard Mode'];

  // Currently selected mode
  String? _selectedMode;

  // Tracks if our custom dropdown is open
  bool _isDropdownOpen = false;

  // Font style variable for the dropdown items
  final TextStyle dropdownFontStyle = GoogleFonts.orbitron(
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  // List of avatar image file names (robot.png removed)
  final List<String> avatars = [
    'alien.png',
    'astro.png',
    'rocket.png',
    'satelight.png',
  ];

  // Track which avatar is selected (if any)
  int? _selectedAvatarIndex;

  // GlobalKeys to detect bounding boxes of the dropdown button and menu
  final GlobalKey _dropDownKey = GlobalKey();
  final GlobalKey _dropDownMenuKey = GlobalKey();

  /// Closes the dropdown if the user taps outside the dropdown area.
  void _handleTapDown(TapDownDetails details) {
    if (!_isDropdownOpen) return;

    RenderBox? dropDownBox =
        _dropDownKey.currentContext?.findRenderObject() as RenderBox?;
    RenderBox? menuBox =
        _dropDownMenuKey.currentContext?.findRenderObject() as RenderBox?;
    if (dropDownBox == null || menuBox == null) return;

    final dropDownOffset = dropDownBox.localToGlobal(Offset.zero);
    final menuOffset = menuBox.localToGlobal(Offset.zero);
    final dropDownRect = Rect.fromLTWH(
      dropDownOffset.dx,
      dropDownOffset.dy,
      dropDownBox.size.width,
      dropDownBox.size.height,
    );
    final menuRect = Rect.fromLTWH(
      menuOffset.dx,
      menuOffset.dy,
      menuBox.size.width,
      menuBox.size.height,
    );

    final tapPos = details.globalPosition;
    if (!dropDownRect.contains(tapPos) && !menuRect.contains(tapPos)) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.06;

    // Title font style (Orbitron)
    final TextStyle titleFontWhite = GoogleFonts.orbitron(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: baseFontSize,
        fontWeight: FontWeight.bold,
      ),
    );

    // Shadow style for titles (as in provided snippet)
    final List<Shadow> titleShadows = [
      const Shadow(
        offset: Offset(8.0, 4.0),
        blurRadius: 8.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('resources/BG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Expanded main content with pinned footer at bottom.
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: _handleTapDown,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar Section (remains at the top)
                        Text(
                          'Select your Avatar',
                          style: titleFontWhite.copyWith(shadows: titleShadows),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        // Avatar Grid with updated formatting
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: avatars.asMap().entries.map((entry) {
                            final index = entry.key;
                            final avatar = entry.value;
                            final bool isSelected =
                                (index == _selectedAvatarIndex);

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedAvatarIndex = index;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? MainColor.secondaryColor
                                      : MainColor.seaGreen,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.yellow
                                        : Colors.white,
                                    width: 5,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  'resources/$avatar',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      size: 24,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                        // Game Mode Section remains below Avatar Section
                        Text(
                          'Select your Game Mode',
                          style: titleFontWhite.copyWith(shadows: titleShadows),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // CUSTOM DROPDOWN "BUTTON"
                        Container(
                          key: _dropDownKey,
                          decoration: BoxDecoration(
                            color: MainColor.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          width: double.infinity,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _isDropdownOpen = !_isDropdownOpen;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedMode ?? 'Select Game Mode',
                                  style: dropdownFontStyle.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                                Icon(
                                  _isDropdownOpen
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ANIMATED CONTAINER FOR THE MENU ITEMS
                        AnimatedContainer(
                          key: _dropDownMenuKey,
                          duration: const Duration(milliseconds: 300),
                          height: _isDropdownOpen ? (modes.length * 67.0) : 0,
                          curve: Curves.easeInOut,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: MainColor.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: modes.map((mode) {
                                  final String assetPath =
                                      'resources/${mode.toLowerCase().split(' ')[0]}.png';
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _selectedMode = mode;
                                        _isDropdownOpen = false;
                                      });
                                      // Navigate based on mode selection.
                                      final avatarPath = _selectedAvatarIndex !=
                                              null
                                          ? 'resources/${avatars[_selectedAvatarIndex!]}'
                                          : 'resources/alien.png';

                                      if (mode == 'Easy Mode') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => GameScreen(
                                              userAvatarPath: avatarPath,
                                            ),
                                          ),
                                        );
                                      } else if (mode == 'Medium Mode') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => GameScreen(
                                              isMediumMode: true,
                                              userAvatarPath: avatarPath,
                                            ),
                                          ),
                                        );
                                      } else if (mode == 'Hard Mode') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => GameScreen(
                                              isHardMode: true,
                                              userAvatarPath: avatarPath,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(mode, style: dropdownFontStyle),
                                          Image.asset(
                                            assetPath,
                                            width: 24,
                                            height: 50,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.image_not_supported,
                                                size: 24,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              // Pinned Footer
              Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  'Designed by Amal Fernando',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
