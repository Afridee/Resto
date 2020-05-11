import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class itemDetail extends StatefulWidget {
  final String imgPath;
  final int price;
  final String name;
  final String desc;
  final bool addToDailyNeeds;

  itemDetail({this.imgPath, this.price, this.name, this.desc, this.addToDailyNeeds});

  @override
  _itemDetailState createState() => _itemDetailState();
}

class _itemDetailState extends State<itemDetail> {

  //variables:
  String userID = '';

  //functions:

  //function 1:
  Future<void> addToDailyNeeds() async{
    final DocumentReference qty = Firestore.instance.document('users/${userID}/dailyNeeds/${widget.name}');

    await qty.setData({
      'desc' : widget.desc,
      'name' : widget.name,
      'img' : widget.imgPath,
      'qty' : 0,
      'price': widget.price
    }, merge: true);

    _showDialog();
  }
  //function 2:
  Future<void> getUserID() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    userID = user.uid;
  }
  //function 3
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Item Added!", style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Varela'),),
          content: new Text("The item you selected has been added to your daily needs", style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'Varela'),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'Varela', fontWeight: FontWeight.bold), ),
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

  @override
  void initState() {
    getUserID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffdd3572)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      body: ListView(
          children: [
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                  'Description:',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffdd3572))
              ),
            ),
            SizedBox(height: 15.0),
            Hero(
                tag: widget.name,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xfff9b294),
                  child: ClipOval(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                       child: Image.network(widget.imgPath,
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                )
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text(widget.name,
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffdd3572))),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text('৳'+widget.price.toString(),
                  style: TextStyle(
                      color: Color(0xFF575E67),
                      fontFamily: 'Varela',
                      fontSize: 22.0)),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50.0,
                child: Text(widget.desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 16.0,
                        color: Color(0xFFB4B8B9))
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
                child: widget.addToDailyNeeds? InkWell(
                  onTap: (){
                    addToDailyNeeds();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xffdd3572)
                      ),
                      child: Center(
                          child: Text('Add to daily needs',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          )
                      )
                  ),
                ) : Container(
                  height: 0.0,
                  width: 0.0,
                )
            ),
            SizedBox(height: 20.0)
          ]
      ),
    );
  }
}