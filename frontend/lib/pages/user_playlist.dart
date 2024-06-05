import 'package:flutter/material.dart';

class UserPlaylist extends StatefulWidget {
  const UserPlaylist({Key? key}) : super(key: key);

  @override
  State<UserPlaylist> createState() => _UserPlaylistState();
}





class _UserPlaylistState extends State<UserPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFF1D1C1C)),
          child: Stack(
            children: [
              Positioned(
                left: 68,
                top: 48,
                child: Text(
                  'My Playlists',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Noto Sans Bengali UI',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 2.88,
                  ),
                ),
              ),
              Positioned(
                left: 75,
                top: 141,
                child: Text(
                  'Recently Generated',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Noto Sans Bengali UI',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.60,
                  ),
                ),
              ),
              Positioned(
                left: 101,
                top: 299,
                child: Text(
                  'Saved Playlists',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Noto Sans Bengali UI',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.60,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 123,
                child: Container(
                  width: 320,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 281,
                child: Container(
                  width: 320,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 347,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFF097931),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 347,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFF9A1010),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 350,
                top: 131,
                child: Container(
                  width: 10,
                  height: 47,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 357,
                child: Text(
                  'Demonstration Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 375,
                child: Text(
                  'Mood: <Mood>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 398,
                child: Text(
                  '120 Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 357,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 357,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 182,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFF097931),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 192,
                child: Text(
                  'Demonstration Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 210,
                child: Text(
                  'Mood: <Mood>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 233,
                child: Text(
                  '120 Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 192,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 446,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFF0D6BC3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 456,
                child: Text(
                  'Demonstration Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 474,
                child: Text(
                  'Mood: <Mood>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 497,
                child: Text(
                  '120 Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 456,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 545,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFFB57514),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 555,
                child: Text(
                  'Demonstration Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 573,
                child: Text(
                  'Mood: <Mood>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 596,
                child: Text(
                  '120 Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 555,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 52,
                top: 644,
                child: Container(
                  width: 257,
                  height: 75,
                  decoration: ShapeDecoration(
                    color: Color(0xFF3936C0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 654,
                child: Text(
                  'Demonstration Title',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 672,
                child: Text(
                  'Mood: <Mood>',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 695,
                child: Text(
                  '120 Songs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 1.20,
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 654,
                child: Container(
                  width: 57,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 708,
                child: Container(
                  width: 360,
                  height: 92,
                  decoration: BoxDecoration(color: Color(0xFF097931)),
                ),
              ),
              Positioned(
                left: 84,
                top: 722,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 63.01,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF4BB165),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 272,
                top: 722,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 63.01,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF4BB165),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 180,
                top: 722,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                  child: Container(
                    width: 63.01,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFF4BB165),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}