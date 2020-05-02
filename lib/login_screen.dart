import 'package:flutter/services.dart';
import 'package:project_resto/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_resto/daily_needs_page.dart';


class login_page extends StatefulWidget {


  @override
  _login_pageState createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {

	//variables:
 String email;
 String password;
 String userID;
 bool loogedIn = false;

 //functions:

 //function 1
 Future<void> login() async{
     if(loogedIn==false){
			 try{
				 final auth = FirebaseAuth.instance;
				 final user =  await auth.signInWithEmailAndPassword(email: email, password: password);
				 if(user!=null){
				 	 setState(() {
				 	   loogedIn = true;
				 	 });
					 final FirebaseUser user = await auth.currentUser();
					 userID = user.uid;
					 var route = new MaterialPageRoute(
						 builder: (BuildContext context) =>
						 new dailyNeedsPage(),
					 );
					 Navigator.of(context).push(route);
				 }
			 }catch(e){
				 print(e);
			 }
		 }
 }



  @override
  Widget build(BuildContext context) {

    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height: 400,
	              child: Stack(
	                children: <Widget>[
                    Positioned(
                      right: MediaQuery. of(context). size. width/2-130,
	                    top: 90,
                      width: 200,
	                    height: 200,
	                    child: FadeAnimation(1.5, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/images/Resto_logo.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
                      top: 270,
                      right: MediaQuery. of(context). size. width/2-70,
	                    child: FadeAnimation(1.6, Container(
	                      margin: EdgeInsets.only(top: 30),
	                      child: Center(
	                        child: Text("Resto", style: TextStyle(color: Color(0xffdd3572), fontSize: 60,  fontFamily: 'Lucy the Cat'),),
	                      ),
	                    )),
	                  )
	                ],
	              ),
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeAnimation(1.8, Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Column(
	                      children: <Widget>[
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextField(
                              onChanged: (value){
                                setState(() {
                                  email = value;
                                });
                              },
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Email",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          child: TextField(
                              onChanged: (value){
                                setState(() {
                                  password = value;
                                });
                              },
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        )
	                      ],
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  FadeAnimation(2, InkWell(
                        onTap: (){
                           login();
                        },
                        child: Container(
	                      height: 50,
	                      decoration: BoxDecoration(
	                        borderRadius: BorderRadius.circular(10),
	                        gradient: LinearGradient(
	                          colors: [
	                            Color(0xffdd3572),
	                            Color(0xfff9b294),
	                          ]
	                        )
	                      ),
	                      child: Center(
	                        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
	                      ),
	                    ),
	                  )),
	                  SizedBox(height: 50,),
	                  FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Color(0xffdd3572)),)),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
      )
    );
  }
}