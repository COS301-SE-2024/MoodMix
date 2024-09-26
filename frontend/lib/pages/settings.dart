import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';
import '../theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                    activeColor: Colors.white,
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
            Divider(),

            // Logout Button
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () async {
                // Handle logout logic
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('email'); // Remove email
                await prefs.remove('password'); // Remove password
                await prefs.remove('spotify_access_token');
                await prefs.remove('token_timestamp');
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
