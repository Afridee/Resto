import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class mainDrawer extends StatefulWidget {

  String userID;

  @override
  _mainDrawerState createState() => _mainDrawerState();
}


class _mainDrawerState extends State<mainDrawer> {

  //variables:
  String Resturant_name = 'null';

  //Functions:

  //function 1:
  Future<void> get_user_info() async{
    final DocumentReference user_info = Firestore.instance.document('users/'+widget.userID);
    await for(var snapshot in user_info.snapshots()){
      await setState(() {
        Resturant_name = snapshot.data['name'];
      });
      print(Resturant_name);
      break;
    }
  }

  //function 2:
  Future<void> getUserID() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    widget.userID = user.uid;
  }

  @override
  void initState() {
    getUserID();
    get_user_info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xfff9b294),
                      Color(0xffdd3572),
                    ]
                )
            ),
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(top: 80, bottom: 80,left: 15),
                title: Text(
                  Resturant_name,
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 50
                  ),
                ),
                onTap: (){
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text(
                  'Add Item to your daily needs',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  get_user_info();
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  'Daily Needs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: (){
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(
                  'Cart',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: (){
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text(
                  'Records',
                  style: TextStyle(
                      fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.arrow_back),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),
                ),
                onTap: ()async{
                },
              ),
            ],
          ),
        )
    );
  }
}




