import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_resto/Screens/Records.dart';
import 'package:project_resto/Screens/login_screen.dart';
import 'package:project_resto/Screens/resetPassword.dart';


class mainDrawer extends StatefulWidget {

  @override
  _mainDrawerState createState() => _mainDrawerState();
}


class _mainDrawerState extends State<mainDrawer> {

  //variables:
  String userID='';

  //Functions:

  //function 2:
  Future<void> getUserID() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userID = user.uid;
    });
  }

  @override
  void initState() {
    getUserID();
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
              StreamBuilder(
                stream: Firestore.instance.document('users/'+userID).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData && snapshot.data!=null){
                     return ListTile(
                       contentPadding: EdgeInsets.only(top: 120, bottom: 80,left: 15),
                       title: Text(
                         snapshot.data['name'],
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 50
                         ),
                       ),
                       onTap: (){
                       },
                     );
                   }else if(!snapshot.hasData || snapshot.data==null){
                    return ListTile(
                      contentPadding: EdgeInsets.only(top: 120, bottom: 80,left: 15),
                      title: Text(
                        'Loading..',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 50
                        ),
                      ),
                      onTap: (){
                      },
                    );
                  }
                   return Container(height: 0,width: 0,);
                }
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
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new RecordDataTable(),
                  );
                  Navigator.of(context).push(route);
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
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new resetPasswordPage(title: 'Reset Password',img: 'assets/images/resetPassIcon.png'),
                  );
                  Navigator.of(context).push(route);
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
                  final auth = FirebaseAuth.instance;
                  await auth.signOut();
                  var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new login_page(),
                  );
                  Navigator.of(context).push(route);
                },
              ),
            ],
          ),
        )
    );
  }
}




