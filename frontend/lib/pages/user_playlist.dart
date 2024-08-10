
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/playlist_ribon.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/components/playlist.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
    List<Playlist> playlists = [];
    User? user;
    // bool isLoading = true; 

    Future<void> fetchUserPlaylist() async {
      // try{
      //   user = FirebaseAuth.instance.currentUser;
        
      //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: user?.email).get();
      //   String documentID = querySnapshot.docs.first.id;

      //   QuerySnapshot qs = await FirebaseFirestore.instance.collection('Users').doc(documentID).collection('Playlists').get();

      //   if(qs.docs.isNotEmpty){
      //     // var docData = qs.docs.first.data() as Map<String, dynamic>;
      //     setState(() {
      //         playlists = qs.docs.map((doc) => Playlist.fromMap(doc.data() as Map<String, dynamic>)).toList();
      //     });
      //   }


      // } catch(error){
      //   print("Failed to fetch Playlists $error");
      // }

        try {
          user = FirebaseAuth.instance.currentUser;

          // if (user == null) {
          //   print("No user is currently signed in.");
          //   return;
          // }

          // print("User email: ${user?.email}");

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('Users')
              .where('UserEmail', isEqualTo: user?.email)
              .get();

          // if (querySnapshot.docs.isEmpty) {
          //   print("No user document found for the current user.");
          //   return;
          // }

          String documentID = querySnapshot.docs.first.id;

          QuerySnapshot qs = await FirebaseFirestore.instance
              .collection('Users')
              .doc(documentID)
              .collection('Playlists')
              .get();

          if (qs.docs.isNotEmpty) {
            setState(() {
              playlists = qs.docs
                  .map((doc) => Playlist.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();
            });
          } else {
            print("No playlists found for the current user.");
          }
        } catch (error) {
          print("Failed to fetch Playlists: $error");
      }
    }

    @override
    void initState() {
      super.initState();
      fetchUserPlaylist();
    }

  //Rhevan's Original
  /*
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                  child: Text(
                    "My Playlists",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    "Recently Generated",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Happy',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIgG2NEOhqsD7?si=0bd9af73b1294d0e',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    "Saved Playlists",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Sad',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIdChYeHNDfK5?si=24280582960a4173',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: PlaylistRibbon(
                    currentIndex: 0,
                    onTap: (index) {
                      print('Tapped on index: $index');
                    },
                    mood: 'Angry',
                    songCount: 10,
                    playlistLink: '37i9dQZF1EIgNZCaOGb0Mi?si=f0985e4d1cf14fa4',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        // Replace bottomNavigationBar with your BottomNavbar component
        currentIndex: 1, // Set current index accordingly
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/audio');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/help');
              break;
          }
        },
      ),
    );
  }*/
  //Test Code to check DB connection
  /*@override
  Widget build(BuildContext context) {
    // fetchUserPlaylist();
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Playlists')),
      body: playlists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(playlists[index].name),
                  subtitle: Text('${playlists[index].description}\nSongs: ${playlists[index].songCount}'),
                  onTap: () {
                    // Handle tap, e.g., open link
                    print('Tapped on ${playlists[index].link}');
                  },
                );
              },
            ),
    );
  }*/
  //PlaylistRibon is causing an error here

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    print(playlists.first.name);
    print(playlists.first.description);
    print(playlists.first.link);

    if (playlists.isNotEmpty && mounted) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
                child: Text(
                  "My Playlists",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Text(
                  "Recently Generated",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Text(
                  "Saved Playlists",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    var playlist = playlists[index];
                    
                    // Null check
                    if (playlist == null) return SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: PlaylistRibbon(
                        currentIndex: index,
                        onTap: (index) {
                          print('Tapped on index: $index');
                        },
                        mood: playlist.name,
                        songCount: playlist.songCount,
                        playlistLink: playlist.link,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: NavBar(
          currentIndex: 1,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/camera');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/userprofile');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/audio');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/userplaylist');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/help');
                break;
            }
          },
        ),
      );
    // } 
    // else {
    //   return Center(child: CircularProgressIndicator());  // Or some other fallback UI
    // }
    }  
  }
  //SingleChildScrollView is throwing an error
  // @override
  // Widget build(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   // print(playlists.first.name);
  //   // print(playlists.first.description);
  //   // print(playlists.first.link);
  //   // print(playlists.first.songCount);
  //   if (playlists.isNotEmpty && mounted) {
  //     return Scaffold(
  //       backgroundColor: Theme.of(context).colorScheme.primary,
  //       body: SafeArea(
  //         child: playlists.isNotEmpty 
  //           ? SingleChildScrollView(
  //               child: SizedBox(
  //                 width: screenWidth,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(20, 25, 0, 0),
  //                       child: Text(
  //                         "My Playlists",
  //                         style: TextStyle(
  //                           fontSize: 40,
  //                           fontFamily: 'Roboto',
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).colorScheme.secondary,
  //                         ),
  //                         textAlign: TextAlign.left,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
  //                       child: Text(
  //                         "Recently Generated",
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontFamily: 'Roboto',
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).colorScheme.secondary,
  //                         ),
  //                         textAlign: TextAlign.left,
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
  //                       child: Text(
  //                         "Saved Playlists",
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontFamily: 'Roboto',
  //                           fontWeight: FontWeight.w400,
  //                           color: Theme.of(context).colorScheme.secondary,
  //                         ),
  //                         textAlign: TextAlign.left,
  //                       ),
  //                     ),
  //                     ...playlists.map((playlist) {
  //                       int index = playlists.indexOf(playlist);
  //                       return Padding(
  //                         padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
  //                         child: PlaylistRibbon(
  //                           currentIndex: index,
  //                           onTap: (index) {
  //                             print('Tapped on index: $index');
  //                           },
  //                           mood: playlist.name, // Assuming the name indicates the mood
  //                           songCount: playlist.songCount,
  //                           playlistLink: playlist.link,
  //                         ),
  //                       );
  //                     }).toList(),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           : Center(child: Text('No Playlists Available')),
  //       ),
  //       bottomNavigationBar: NavBar(
  //         currentIndex: 1,
  //         onTap: (index) {
  //           switch (index) {
  //             case 0:
  //               Navigator.pushReplacementNamed(context, '/camera');
  //               break;
  //             case 1:
  //               Navigator.pushReplacementNamed(context, '/userprofile');
  //               break;
  //             case 2:
  //               Navigator.pushReplacementNamed(context, '/audio');
  //               break;
  //             case 3:
  //               Navigator.pushReplacementNamed(context, '/userplaylist');
  //               break;
  //             case 4:
  //               Navigator.pushReplacementNamed(context, '/help');
  //               break;
  //           }
  //         },
  //       ),
  //     );
  //   } else {
  //     return Scaffold(
  //       body: Center(child: CircularProgressIndicator()),
  //     );
  //   }
  // }


/*
    @override
    Widget build(BuildContext context){
      final screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: PlaylistRibbon(
                currentIndex: 1,
                onTap: (index){
                  print('Tappped on Index: $index');
                },
                mood: playlists.first.name,
                songCount: playlists.first.songCount,
                playlistLink: playlists.first.link,
                ),
            ),
          ),
        ),
      bottomNavigationBar: NavBar(
        currentIndex: 1, // Set current index accordingly
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/camera');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/userprofile');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/audio');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/userplaylist');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/help');
              break;
          }
        },
      ),
    );  
    }*/
    
}

