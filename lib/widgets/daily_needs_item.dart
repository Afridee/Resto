import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

class dailyNeedsItem extends StatefulWidget {

 final String name;
 final String imgPath;
 final int price;
 final int qty;

  const dailyNeedsItem({Key key, this.name, this.imgPath, this.price, this.qty}) : super(key: key);

  @override
  _dailyNeedsItemState createState() => _dailyNeedsItemState();
}

class _dailyNeedsItemState extends State<dailyNeedsItem> {

  //variables:
  String userID;

  //functions:

  //1
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
  return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
            print('tapped');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Hero(
                      tag: widget.name,
                      child: Image(
                        image: NetworkImage(widget.imgPath),
                        fit: BoxFit.cover,
                        height: 75.0,
                        width: 75.0
                      )
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
                          width: 114.00,
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
                          widget.price.toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey
                          )
                        ),
                        Text(
                            'x ${widget.qty}',
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
        ));
  }
}