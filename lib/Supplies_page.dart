import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_resto/widgets/itemBuild.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project_resto/daily_needs_page.dart';


class suppliesPage extends StatefulWidget {
  @override
  _suppliesPageState createState() => _suppliesPageState();
}

class _suppliesPageState extends State<suppliesPage> {

  //variables:
  Icon custom_Icon = Icon(Icons.search);
  Widget search_text = Text('');
  String userID = '';
  int pageIndex = 0;
  PageController pageController;

  //functions:

  //function 1
  void seacrchIconState(){
    setState(() {
      if (this.custom_Icon.icon == Icons.search) {
        this.custom_Icon = Icon(Icons.cancel);
        this.search_text = TextField(
            decoration: InputDecoration(
              hintText: "Search Here...",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white, fontSize: 20));
      } else {
        this.custom_Icon = Icon(Icons.search);
        this.search_text = Text('');
      }
    });
  }
  //function 2
  Future<void> getUserID() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    userID = user.uid;
  }
  //function 3
  onPageChanged(int pageIndex) {
    if (!mounted) return;
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //function 4
  navBarOnTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xfff9b294),
                          Color(0xffdd3572),
                          Color(0xffdd3572),
                        ]
                    )
                )
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: search_text,
            actions: <Widget>[
              IconButton(
                icon: custom_Icon,
                onPressed: () {
                  seacrchIconState();
                },
              )
            ],
          ),
          drawer: Drawer(
            //child: mainDrawer(userID: widget.userID),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xfff9b294),
                      Color(0xffdd3572),
                      Color(0xffdd3572),
                    ]
                )
            ),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 25.0),
                Padding(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[
                      Text('Our',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0)),
                      SizedBox(width: 10.0),
                      Text('Products',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 25.0))
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: MediaQuery.of(context).size.height - 185.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
                  ),
                  child: ListView(
                    primary: false,
                    padding: EdgeInsets.only(left: 25.0, right: 20.0),
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 45.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height - 300.0,
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('supplies')
                                    .snapshots(),
                                builder: (context, snapshot){
                                  if(!snapshot.hasData){
                                    return const Text('Loading..');
                                  }
                                  if(snapshot.hasData && snapshot.data!=null){
                                    return ListView.builder(
                                        itemCount: snapshot.data.documents.length,
                                        itemBuilder: (context, index){
                                          print(snapshot.data.documents[index]['img']);
                                          return itemBuild(imgPath: snapshot.data.documents[index]['img'],
                                              name: snapshot.data.documents[index]['name'],
                                              price: snapshot.data.documents[index]['price'],
                                              qty: snapshot.data.documents[index]['qty'],
                                              desc: snapshot.data.documents[index]['desc'],
                                              isSupplyPage: true);
                                        }
                                    );
                                  }
                                  return Container(height: 0.0, width: 0.0);
                                },
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /*InkWell(
                          onTap: (){
                            print(userID);
                          },
                          child: Container(
                            height: 65.0,
                            width: 120.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xffdd3572),
                                      Color(0xffdd3572),
                                    ]
                                )
                            ),
                            child: Center(
                                child: Text('Checkout',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        fontSize: 15.0))),
                          ),
                        )*/
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: 0,
            color: Color(0xffdd3572),
            backgroundColor: Colors.white,
            buttonBackgroundColor: Color(0xfff9b294),
            height: 50,
            items: <Widget>[
              Icon(Icons.library_add, size: 30, color: Colors.white),
              Icon(Icons.account_circle, size: 30, color: Colors.white),
              Icon(Icons.shopping_cart, size: 30, color: Colors.white)
            ],
            animationDuration: Duration(
                milliseconds: 200
            ),
            animationCurve: Curves.bounceInOut,
            onTap: (index){
              navBarOnTap(index);
            },
          ),
        ),
        dailyNeedsPage()
      ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics()
    );
  }
}