// import 'package:flutter/material.dart';
// import 'package:flutter_web_auth/flutter_web_auth.dart';
// import '../auth/auth_service.dart';
// import 'dart:js' as js;
//
// class LinkSpotify extends StatefulWidget {
//   const LinkSpotify({Key? key}) : super(key: key);
//
//   @override
//   State<LinkSpotify> createState() => _LinkSpotifyState();
// }
//
// class _LinkSpotifyState extends State<LinkSpotify> {
//   final AuthService _authService = AuthService();
//
//   void _linkSpotify() async {
//
//     await _authService.authenticateWithSpotify(context);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     handleCallback();
//   }
//
//   void handleCallback() {
//     final Uri uri = Uri.parse(js.context['window'].location.href);
//     final String? code = uri.queryParameters['code'];
//     final String? error = uri.queryParameters['error'];
//     if (code != null) {
//       print('Authorization code: $code');
//     } else if (error != null) {
//       print('Authentication error: $error');
//     } else {
//       print('Unexpected callback');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 33, 33, 33),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 25, 0, 60),
//               child: Text(
//                 "Link Your\nSpotify",
//                 style: TextStyle(
//                   fontSize: 40,
//                   fontFamily: 'Roboto',
//                   fontWeight: FontWeight.w200,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     width: screenWidth / 1.4,
//                     child: Text(
//                       "Why link your Spotify?",
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontWeight: FontWeight.w500,
//                         color: const Color.fromARGB(171, 255, 255, 255),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight / 25),
//                   SizedBox(
//                     width: screenWidth / 1.4,
//                     child: Text(
//                       "This application offers many features that are reliant on the link between this application and your Spotify account.",
//                       style: TextStyle(
//                         fontFamily: 'Roboto',
//                         fontWeight: FontWeight.w500,
//                         color: const Color.fromARGB(171, 255, 255, 255),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: 80,
//                     width: screenWidth / 1.4,
//                     child: OutlinedButton(
//                       onPressed: _linkSpotify,
//                       style: OutlinedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         foregroundColor: Colors.white,
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Image(
//                           image: AssetImage(
//                               "assets/images/Spotify_Full_Logo_RGB_White.png"),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: EdgeInsets.all(20.0),
//                       child: Text(
//                         "\n\nTerms and Conditions",
//                         style: TextStyle(
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
