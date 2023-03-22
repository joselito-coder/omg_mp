import 'package:flutter/material.dart';
import 'package:omg_mp/gey.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("Bantai"),
          accountEmail: Text('OmgBantai@gullyGang.com'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
                child: Image.asset('assets/ashishbantai.jpg',
                    width: 250, height: 250, fit: BoxFit.cover)),
          ),
          decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: AssetImage('assets/bestbantai.jpg'),
                  fit: BoxFit.fill)),
        ),
        ListTile(
          leading: Icon(Icons.music_note),
          title: Text('Songs'),
          onTap: () => Navigator.pop(context),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.video_call),
          title: Text('Videos'),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home())),
        ),
      ],
    ));
  }
}
