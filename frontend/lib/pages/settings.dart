import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:frontend/pages/user_profile.dart';
import '../auth/auth_service.dart';
import '../theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  final AuthService _authService = AuthService();
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
              leading: Icon(Icons.key),
              title: Text('Change Password'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final email = prefs.getString('email') ?? '';
                if (email != "") {
                  final result = await _authService.sendPasswordResetEmail(email);
                  if (result == 'Success') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset email sent')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result ?? 'Failed to send reset email')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Log out and retry if no email has been sent.')),
                  );
                }
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
