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
            Icons.house,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "HOME",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "PROFILE",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.music_note,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "MUSICPLAYER",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_music,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "PLAYLISTS",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.help,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: "HELP",
        ),
        BottomNavigationBarItem(icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
          ),
          label: "ADD"
        ),
      ],
    );
  }
}

// Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
