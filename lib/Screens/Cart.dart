import 'dart:async';

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
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  //variables:
  String userID = '';
  double  sliderValue = 0.0;
  bool showSpinner = false;
  int totalCost = 0;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  bool connectedToInternet = true;

  //functions:

  //function 2
  Future<void> getUserID() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userID = user.uid;
    });
    totalCostCalculation();
  }

  //function 3


  //function 4


  //function 5
  Future<void> confirm() async{
    final CollectionReference items = Firestore.instance.collection('users/${userID}/dailyNeeds');

    var itemList = new List();

    await for(var snapshot in items.snapshots()){
      for(var item in snapshot.documents){
        if(item.data['qty']>0)
        itemList.add(item.data);
      }
      break;
    }

    final DocumentReference userInformation = Firestore.instance.document('users/${userID}');

    Map<String, dynamic> userInfo;

    await for(var snapshot in userInformation.snapshots()){
      userInfo = snapshot.data;
      break;
    }

    final CollectionReference userRecord = Firestore.instance.collection('users/${userID}/records');

    await userRecord.document().setData({
      'time' : DateTime.now(),
      'items' : itemList,
      'status' : 'Processing',
      'totalCost' : totalCost
    });

    await for(var snapshot in items.snapshots()){
      for(var item in snapshot.documents){
        if(item.data['qty']>0){
          items.document(item.documentID).setData({
            'qty' : 0
          }, merge: true);
        }
      }
      break;
    }

    _showDialog();

    setState(() {
      totalCost = 0;
      showSpinner = false;
    });
  }

  //6
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Purchase Successful!", style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Varela'),),
          content: new Text("We got your Order. Will be reaching you soon.", style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Varela'),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK", style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold), ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Color(0xffdd3572),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
        );
      },
    );
  }

  void _customDialog(String img, String text) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(text, style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Varela'),),
          content: Image.asset(img),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK", style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold), ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Color(0xffdd3572),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
        );
      },
    );
  }

  //7
  Future<void> totalCostCalculation() async{
    await setState(() {
      totalCost = 0;
    });

    final CollectionReference items = Firestore.instance.collection('users/${userID}/dailyNeeds');


    await for(var snapshot in items.snapshots()){
      for(var item in snapshot.documents){
         setState(() {
           totalCost = totalCost + item.data['price']*item.data['qty'];
         });
      }
      break;
    }

  }

  @override
  void initState() {
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        setState(() {
          connectedToInternet = true;
        });
      }else if(result == ConnectivityResult.none){
        setState(() {
          connectedToInternet = false;
        });
      }
    });
    getUserID();
    super.initState();
  }

  //8
  void totalCostCalculation2(String x, int value){
      if(x=='add'){
        setState(() {
          totalCost = totalCost + value;
        });
      }else if(x=='deduct'){
        setState(() {
          totalCost = totalCost - value;
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                                        isSupplyPage: false,
                                                        isCartPage: true,
                                                    TC: totalCostCalculation2),
                                                  );
                                                }
                                                return Container(
                                                    height: 0.0, width: 0.0);
                                              });
                                        }
                                        return Container(height: 0.0, width: 0.0);
                                      },
                                    ))),
                            SizedBox(height: 15.0),
                            Center(child: Text('Total: ৳${totalCost}', style: TextStyle(fontSize: 20, color: Color(0xffdd3572), fontFamily: 'Varela', fontWeight: FontWeight.bold),textAlign: TextAlign.right,)),
                            SizedBox(height: 15.0),
                            InkWell(
                              onLongPress: (){
                                 if(totalCost>0 && connectedToInternet){
                                   setState(() {
                                     totalCostCalculation();
                                     sliderValue = 100.0;
                                   });
                                   confirm();
                                 }else{
                                   if(totalCost==0 && connectedToInternet){
                                     _customDialog('assets/images/uboughtnothing.png', 'You bought Nothing...');
                                   }
                                   if(!connectedToInternet){
                                     _customDialog('assets/images/noInternet.png', 'Please check your connection');
                                   }
                                 }
                              },
                              child: CircleAvatar(
                                radius: 68,
                                backgroundColor: Color(0xffdd3572),
                                child: SleekCircularSlider(
                                     initialValue: sliderValue,
                                    appearance: CircularSliderAppearance(
                                        size: 120,
                                        customColors: CustomSliderColors(progressBarColors: [Color(0xffffffff),Color(0xffffffff),Color(0xffffffff)],
                                        trackColor: Color(0xfff9b294),
                                        shadowColor: Colors.white,
                                        dotColor: Color(0xfff9b294)),
                                        customWidths: CustomSliderWidths(
                                            progressBarWidth: 5.0,
                                            handlerSize: 6.0
                                        ),
                                        infoProperties:InfoProperties(
                                            mainLabelStyle: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold),
                                            topLabelText: ' Press and hold',
                                            topLabelStyle: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold),
                                            bottomLabelText: 'to confirm',
                                            bottomLabelStyle: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold),
                                        )
                                    ),
                                    onChange: (double value) {
                                      setState(() {
                                         value = sliderValue;
                                         if(value==100.0 && sliderValue==100.0 && totalCost>0){
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
              ),
    );
  }
}
