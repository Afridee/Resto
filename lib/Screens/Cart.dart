import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_resto/widgets/itemBuild.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project_resto/Screens/Supplies_page.dart';
import 'package:project_resto/Screens/daily_needs_page.dart';
import 'package:project_resto/widgets/Main_drawer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  //variables:
  String userID = '';
  int pageIndex = 2;
  PageController pageController;
  double  sliderValue = 0.0;
  bool showSpinner = false;

  //functions:

  //function 2
  Future<void> getUserID() async {
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
    pageController = PageController(initialPage: 2);
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return PageView(
        children: <Widget>[
          suppliesPage(),
          dailyNeedsPage(),
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xfff9b294),
                  Color(0xffdd3572),
                  Color(0xffdd3572),
                ]))),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              drawer: Drawer(
                child: mainDrawer(),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xfff9b294),
                      Color(0xffdd3572),
                      Color(0xffdd3572),
                ])),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 25.0),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text('Your',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0)),
                          SizedBox(width: 10.0),
                          Text('Cart',
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
                        borderRadius: BorderRadius.only(topRight: Radius.circular(75.0),
                      ),),
                      child: ListView(
                        primary: false,
                        padding: EdgeInsets.only(left: 25.0, right: 20.0),
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 45.0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 450.0,
                                  child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection(
                                            'users/' + userID + '/dailyNeeds')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Text('Loading..');
                                      }
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder: (context, index) {
                                              if (snapshot.data.documents[index]
                                                      ['qty'] >
                                                  0) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                  child: itemBuild(
                                                      imgPath: snapshot.data
                                                          .documents[index]['img'],
                                                      name: snapshot.data
                                                          .documents[index]['name'],
                                                      price: snapshot
                                                              .data.documents[index]
                                                          ['price'],
                                                      qty: snapshot.data
                                                          .documents[index]['qty'],
                                                      desc: snapshot.data
                                                          .documents[index]['desc'],
                                                      isSupplyPage: false),
                                                );
                                              }
                                              return Container(
                                                  height: 0.0, width: 0.0);
                                            });
                                      }
                                      return Container(height: 0.0, width: 0.0);
                                    },
                                  ))),
                          SizedBox(height: 20.0),
                          InkWell(
                            onLongPress: (){
                              setState(() {
                                 sliderValue = 100.0;
                              });
                            },
                            child: CircleAvatar(
                              radius: 62,
                              backgroundColor: Color(0xffdd3572),
                              child: SleekCircularSlider(
                                   initialValue: sliderValue,
                                  appearance: CircularSliderAppearance(
                                      size: 110,
                                      customColors: CustomSliderColors(progressBarColors: [Color(0xffffffff),Color(0xffffffff),Color(0xffffffff)],
                                      trackColor: Color(0xfff9b294),
                                      shadowColor: Colors.white,
                                      dotColor: Color(0xfff9b294)),
                                      customWidths: CustomSliderWidths(
                                          progressBarWidth: 5.0,
                                          handlerSize: 6.0
                                      ),
                                      infoProperties:InfoProperties(
                                          mainLabelStyle: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Varela'),
                                          topLabelText: ' Press and hold',
                                          topLabelStyle: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Varela'),
                                          bottomLabelText: '',
                                          bottomLabelStyle: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Varela'),
                                      )
                                  ),
                                  onChange: (double value) {
                                    setState(() {
                                       value = sliderValue;
                                       if(value==100.0){
                                           showSpinner = true;
                                       }
                                    });
                                  }),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: CurvedNavigationBar(
                index: 2,
                color: Color(0xffdd3572),
                backgroundColor: Colors.white,
                buttonBackgroundColor: Color(0xfff9b294),
                height: 50,
                items: <Widget>[
                  Icon(Icons.library_add, size: 30, color: Colors.white),
                  Icon(Icons.account_circle, size: 30, color: Colors.white),
                  Icon(Icons.shopping_cart, size: 30, color: Colors.white)
                ],
                animationDuration: Duration(milliseconds: 200),
                animationCurve: Curves.bounceInOut,
                onTap: (index) {
                  navBarOnTap(index);
                },
              ),
            ),
          )
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics());
  }
}
