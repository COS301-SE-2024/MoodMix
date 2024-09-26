import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _shouldNavigate = false;

  Future<void> _handleLogin() async {
    final email = _usernameOrEmailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.login(email: email, password: password);

    setState(() {
      _isLoading = false;
    });

    if (result == 'Success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      setState(() {
        _shouldNavigate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Login failed')),
      );
    }
  }

  Future<bool> _checkCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    if (email.isNotEmpty && password.isNotEmpty) {
      await _authService.login(email: email, password: password);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_shouldNavigate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/linkspotify');
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
          ),
        )
            : SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
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
                              Navigator.pop(context);
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: screenWidth * 0.75,
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: screenWidth * 0.065,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 35),
                        SizedBox(
                          width: screenWidth * 0.75,
                          child: TextField(
                            key: Key('Username Or Email'),
                            cursorColor: Theme.of(context).colorScheme.secondary,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            controller: _usernameOrEmailController,
                            decoration: InputDecoration(
                              hintText: 'Username or Email',
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
                        SizedBox(
                          width: screenWidth * 0.75,
                          child: TextField(
                            key: Key('Password'),
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
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
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
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Forgot your password?",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Terms and Conditions",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  key: Key('Login Button'),
                                  height: 70,
                                  padding: EdgeInsets.fromLTRB(0, 0, screenWidth * 0.1, 0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onPressed: _handleLogin,
                                    label: Text(
                                      'Log In',
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
