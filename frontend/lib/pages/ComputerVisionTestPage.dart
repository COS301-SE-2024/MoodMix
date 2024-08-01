
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/main.dart'; 
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//This is a Page to Compare an Image to its GrayScaled Version 
class CVPage extends StatefulWidget{
  const CVPage({Key? key}): super(key:key);
  // String path = '';
  // static const MethodChannel platform = MethodChannel('boofcvChannel');

  @override
  State<CVPage> createState() => _CVPage(); 
}

class _CVPage extends State<CVPage>{

  void initState(){
    setState(() {
      
    });
  }

  //Could make it return a String of the grayscale?
  // Future<void> processImage(String imagePath) async{
  //   try{
  //     final String result = await CVPage.platform.invokeMethod('convertGrayScale',{'image':imagePath});
  //     print(result);
  //   }
  //   on PlatformException catch (e){
  //     print("failed to process");
  //   }
  // }

  
  //A Container with Two Images One Gray Scale the other is the original
  @override
  Widget build(BuildContext context){
    // processImage('assets/images/images.jpeg');

  //   return Scaffold(
  //     body:SafeArea(
  //       child:Center(
  //         child:Container(
  //           padding: EdgeInsets.all(20),
  //           child:Column(mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ElevatedButton(onPressed: () async {
  //               const channel = MethodChannel('boofcvChannel');
  //               String path = await channel.invokeMethod('convertGrayScale');

  //               Image(image: AssetImage('assets/images/grayscale.jpeg'));
  //             }, child: const Text('Convert To GrayScale')),
  //             Image(image: AssetImage('assets/images/images.jpeg')),
  //             SizedBox(height: 20),
  //             // Image(image: AssetImage('assets/images/grayscale.jpeg')),
  //           ],
  //           )
  //         )
  //       ),
  //     )
  //   );

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Playlists').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Playlists Found'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? data['PlaylistName'] ?? 'No Name'),
                subtitle: Text(data['description'] ?? data['PlaylistDescription'] ?? 'No Description'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}