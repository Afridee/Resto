import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:project_resto/Screens/product_details.dart';

class itemBuild extends StatefulWidget {

 final String name;
 final String imgPath;
 final int price;
 final int qty;
 final String desc;
 final bool isSupplyPage;

  const itemBuild({Key key, this.name, this.imgPath, this.price, this.qty, this.desc, this.isSupplyPage}) : super(key: key);

  @override
  _itemBuildState createState() => _itemBuildState();
}

class _itemBuildState extends State<itemBuild> with SingleTickerProviderStateMixin{

  //variables:
  String userID;
  AnimationController _addButtonAnimationController;

  //functions:

  //1
  @override
  void initState() {
    _addButtonAnimationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.7
    )..addListener((){
      setState(() {
        //
      });
    });
    getUserID();
    super.initState();
  }

  //2
  Future<void> getUserID() async{
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    userID = user.uid;
  }

  //3
  Future<void> increase_qty() async{
    int updated_qty = 0;

    final DocumentReference qty = Firestore.instance.document('users/${userID}/dailyNeeds/${widget.name}');

    await for(var snapshot in qty.snapshots()){
      updated_qty = snapshot.data['qty']+1;
      break;
    }

    qty.setData({
      'qty' : updated_qty
    }, merge: true);

  }

  //4
  Future<void> decrease_qty() async{
    int updated_qty = 0;

    final DocumentReference qty = Firestore.instance.document('users/${userID}/dailyNeeds/${widget.name}');

    await for(var snapshot in qty.snapshots()){
      updated_qty = snapshot.data['qty']-1;
      break;
    }

    if(updated_qty>=0){
      qty.setData({
        'qty' : updated_qty
      }, merge: true);

    }

  }

  //5
  Future<void> addToDailyNeeds() async{
    final DocumentReference qty = Firestore.instance.document('users/${userID}/dailyNeeds/${widget.name}');

    await qty.setData({
      'desc' : widget.desc,
      'name' : widget.name,
      'img' : widget.imgPath,
       'qty' : 0,
      'price' : widget.price
    }, merge: true);

    _showDialog();
  }

  //6
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
  Widget build(BuildContext context) {
  double scale = _addButtonAnimationController.value + 1;
  return Padding(
        padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
        child: InkWell(
          onTap: () {
            var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
              new itemDetail(imgPath: widget.imgPath, name: widget.name, price: widget.price, desc: widget.desc, addToDailyNeeds: widget.isSupplyPage),
            );
            Navigator.of(context).push(route);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Hero(
                          tag: widget.name,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(0xfff9b294),
                            child: ClipOval(
                              child: SizedBox(
                                  height: 75,
                                  width: 75,
                                  child: Image.network(widget.imgPath,
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        /*RichText(
                          overflow: TextOverflow.fade,
                        strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                            ),
                            text: widget.name,
                          ),
                        ),*/
                        Container(
                          width: 125.00,
                          child: AutoSizeText(
                            widget.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 2,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                        Text(
                            '৳'+widget.price.toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey
                          )
                        ),
                        Text(
                            widget.isSupplyPage? '': 'x ${widget.qty}',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red
                            )
                        )
                      ]
                    )
                  ]
                )
              ),
              Row(
                children: widget.isSupplyPage ? <Widget>[
                    GestureDetector(
                      onTap: () async{
                         await _addButtonAnimationController.forward();
                        _addButtonAnimationController.reverse();
                      },
                      onTapDown: (TapDownDetails details){
                          addToDailyNeeds();
                          _addButtonAnimationController.forward();
                      },
                      onTapUp: (TapUpDetails details){
                         _addButtonAnimationController.reverse();
                      },
                      onTapCancel: (){
                        _addButtonAnimationController.reverse();
                      },
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          child: Icon(
                              Icons.add_box,
                              size: 40,
                              color: Color(0xffdd3572),
                          ),
                        ),
                      ),
                    ),
                ] : <Widget>[
                  IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.black,
                      onPressed: () {
                        increase_qty();
                      }
                  ),
                  IconButton(
                      icon: Icon(Icons.remove),
                      color: Colors.black,
                      onPressed: () {
                        decrease_qty();
                      }
                  )
                ],
              )
            ],
          )
        ));
  }
}