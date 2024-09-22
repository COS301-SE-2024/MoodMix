import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "HOME",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.my_library_music_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "PLAYLISTS",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
          label: "PROFILE",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "HELP",
        ),
      ],
    );
  }
}

// Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
