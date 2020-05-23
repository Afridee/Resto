import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_resto/widgets/itemBuild.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project_resto/Screens/daily_needs_page.dart';
import 'package:project_resto/widgets/Main_drawer.dart';
import 'package:project_resto/Screens/Cart.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class suppliesPage extends StatefulWidget {

  final Function() SQ; //

  const suppliesPage({Key key, this.SQ}) : super(key: key);

  @override
  _suppliesPageState createState() => _suppliesPageState();
}

class _suppliesPageState extends State<suppliesPage> {
  //variables:
  String userID = '';

  //functions:

  //function 1
  Future<void> getUserID() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userID = user.uid;
    });
  }
  //function 2
  bool searchFunctionality(String query, String item) {
    return item.toLowerCase().trim().contains(query.toLowerCase().trim());
  }

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
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
                  Text('Our',
                      style: TextStyle(
                          fontFamily: 'comfortaa',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0)),
                  SizedBox(width: 10.0),
                  Text('Products',
                      style: TextStyle(
                          fontFamily: 'comfortaa',
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
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(100.0),
                              child: SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  spinnerMode: true,
                                  spinnerDuration: 5000,
                                  size: 50,
                                  customColors: CustomSliderColors(progressBarColors: [Color(0xffdd3572),Color(0xfff9b294)],
                                      trackColor: Color(0xfff9b294),
                                      shadowColor: Colors.white,
                                      dotColor: Color(0xfff9b294)),
                                  customWidths: CustomSliderWidths(
                                      progressBarWidth: 5.0,
                                      handlerSize: 6.0
                                  ),
                                ),),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  if (widget.SQ() == '' ||
                                      widget.SQ() == null) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: itemBuild(
                                          imgPath: snapshot
                                              .data.documents[index]['img'],
                                          name: snapshot.data.documents[index]
                                              ['name'],
                                          price: snapshot.data.documents[index]
                                              ['price'],
                                          qty: snapshot.data.documents[index]
                                              ['qty'],
                                          desc: snapshot.data.documents[index]
                                              ['desc'],
                                          isSupplyPage: true),
                                    );
                                  } else if (widget.SQ() != '' ||
                                      widget.SQ() != null) {
                                    if (searchFunctionality(
                                        widget.SQ(),
                                        snapshot.data.documents[index]
                                            ['name'])) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        child: itemBuild(
                                            imgPath: snapshot
                                                .data.documents[index]['img'],
                                            name: snapshot.data.documents[index]
                                                ['name'],
                                            price: snapshot
                                                .data.documents[index]['price'],
                                            qty: snapshot.data.documents[index]
                                                ['qty'],
                                            desc: snapshot.data.documents[index]
                                                ['desc'],
                                            isSupplyPage: true),
                                      );
                                    }
                                  }
                                  return Container(height: 0.0, width: 0.0);
                                });
                          }
                          return Container(height: 0.0, width: 0.0);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
