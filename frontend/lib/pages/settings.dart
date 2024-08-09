import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart'; // Adjust the import based on your file structure
import 'package:frontend/pages/user_profile.dart';

import '../theme/theme.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/camera');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Theme Change Button
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Change Theme'),
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Switch(
                    value: themeProvider.themeData == darkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleTheme();
                    },
                  );
                },
              ),
            ),
            Divider(),

            // Help Menu Button
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/help');
              },
            ),
            Divider(),

            // Profile Changes Button
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile Changes'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/userprofile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
