import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Tango"),
            accountEmail: Text("abc@abc.com"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            subtitle: Text("Tango"),
            trailing: Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}
