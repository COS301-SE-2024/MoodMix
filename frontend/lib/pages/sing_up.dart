import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/auth_service.dart';

class SignUp extends StatefulWidget {
  final AuthService authService;
  const SignUp({Key? key, required this.authService}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final result = await widget.authService.registration(
      email: email,
      password: password,
      username: username,
    );

    if (result == 'Success') {
      Navigator.pushNamed(context, '/linkspotify');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                        width: screenWidth,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                iconSize: 35,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                  dispose();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/SimpleLogo.svg',
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.1),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: screenWidth * 0.75,
                              child: Text(
                                'Create your account',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 35),
                            Container(
                              width: screenWidth * 0.75,
                              child: TextField(
                                cursorColor: Theme.of(context).colorScheme.secondary,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: screenWidth * 0.75,
                              child: TextField(
                                cursorColor: Theme.of(context).colorScheme.secondary,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: screenWidth * 0.75,
                              child: TextField(
                                cursorColor: Theme.of(context).colorScheme.secondary,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: screenWidth * 0.75,
                              child: TextField(
                                cursorColor: Theme.of(context).colorScheme.secondary,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Container(
                          color: Theme.of(context).colorScheme.primary,
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Divider(
                                color: Theme.of(context).colorScheme.secondary,
                                thickness: 2,
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/login');
                                            },
                                            child: Text(
                                              "Already have an account?",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Uri _url = Uri.parse("https://github.com/COS301-SE-2024/MoodMix");
                                              if (!await launchUrl(_url)) {
                                                throw 'Could not launch $_url';
                                              }
                                            },
                                            child: Text(
                                              "Terms and Conditions",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 70,
                                      padding: EdgeInsets.fromLTRB(0, 0, screenWidth * 0.1, 0),
                                      child: FloatingActionButton.extended(
                                          key: Key('createAccountButton'),
                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        onPressed: _createAccount,
                                        label: Text(
                                          'Create',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
