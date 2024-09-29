import 'package:flutter/material.dart';

//SideMenu to select preferences
class PreferenceMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Drawer(
      child:ListView(
        padding: EdgeInsets.zero,
        children:[
         DrawerHeader(
           child: Text(
             'Select your Music Preferences',
             style: TextStyle(
               color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
               fontSize:24,
             ),
           ),
         ),
          CheckboxListTile(
            title: Text("Rock"),
            value: false,
            onChanged: (bool? value){},
          ),
          CheckboxListTile(
            title: Text("Hip-Hop"),
            value: false,
            onChanged: (bool? value){},
          ),
          CheckboxListTile(
            title: Text("Classical"),
            value: false,
            onChanged: (bool? value){},
          ),
       ],
      ),
    );
  }
}