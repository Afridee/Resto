import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:project_resto/Screens/Reciept.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

class RecordDataTable extends StatefulWidget {
  @override
  _RecordDataTableState createState() => _RecordDataTableState();
}

class _RecordDataTableState extends State<RecordDataTable> {
  //variables:
  String userID = '';
  DateTime from = DateTime.parse("2020-01-01 20:18:04");
  DateTime to = DateTime.now();
  ScrollController _scrollController = new ScrollController();

  //functions:

  //function 1:
  Future<void> getUserID() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userID = user.uid;
    });
  }
  //function 2:
  bool fromTo(Timestamp t, DateTime frm, DateTime to) {
    return t.toDate().isAfter(frm) && t.toDate().isBefore(to);
  }

  @override
  void initState() {
    getUserID();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    //this little code down here turns off auto rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffffffff), Color(0xffffffff)])),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.grey,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
           color: Colors.white
        ),
        child: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            SizedBox(height: 30.0),
            Container(
              child: Image.asset(
                'assets/images/recordIcon.png',
                height: 200,
                width: 200,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
                child: Text(
              'From:',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'comfortaa',
                  color: Color(0xffdd3572),
                  fontWeight: FontWeight.bold),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 28.0),
                Text('${from.year}-${from.month}-${from.day}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    )),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showRoundedDatePicker(
                            context: context,
                            initialDate: from == null ? DateTime.now() : from,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2021),
                            theme: ThemeData(primarySwatch: Colors.pink))
                        .then((date) {
                      setState(() {
                        if (date.year != null) {
                          setState(() {
                            from = date;
                          });
                        }
                      });
                    });
                  },
                  iconSize: 35,
                  color: Color(0xff7d2c43),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Center(
                child: Text(
              'To:',
              style: TextStyle(
                fontFamily: 'comfortaa',
                  fontSize: 30,
                  color: Color(0xffdd3572),
                  fontWeight: FontWeight.bold),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 28.0),
                Text('${to.year}-${to.month}-${to.day}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    )),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showRoundedDatePicker(
                            context: context,
                            initialDate: from == null ? DateTime.now() : from,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2021),
                            theme: ThemeData(primarySwatch: Colors.pink))
                        .then((date) {
                      setState(() {
                        if (date.year != null) {
                          setState(() {
                            to = date;
                            _scrollController.animateTo(
                              500,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 500),
                            );
                          });
                        }
                      });
                    });
                  },
                  iconSize: 35,
                  color: Color(0xff7d2c43),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              height: MediaQuery.of(context).size.height - 290.0,
              decoration: BoxDecoration(
                color:Color(0xfff29c81),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users/' + userID + '/records')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            if (fromTo(snapshot.data.documents[index]['time'],
                                from, to)) {
                              return RecordItemBuild(
                                timestamp: snapshot.data.documents[index]
                                    ['time'],
                                OrderStatus: snapshot.data.documents[index]
                                ['status'],
                                totalCost: snapshot.data.documents[index]
                                ['totalCost'],
                                Note: snapshot.data.documents[index]
                                ['Notes'],
                                list: snapshot.data.documents[index]
                                ['items'],
                              );
                            }
                            return Container(
                              height: 0.0,
                              width: 0.0,
                            );
                          });
                    }
                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


//separateWidget=> RecordItemBuild:

class RecordItemBuild extends StatefulWidget {
  final Timestamp timestamp;
  final String OrderStatus;
  final List list;
  final int totalCost;
  final String Note;

  const RecordItemBuild({
    Key key,
    this.timestamp, this.OrderStatus, this.list, this.totalCost, this.Note
  }) : super(key: key);

  @override
  _RecordItemBuildState createState() => _RecordItemBuildState();
}

class _RecordItemBuildState extends State<RecordItemBuild> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new recieptPage(OrderStatus: widget.OrderStatus, list: widget.list, Note: widget.Note, totalCost: widget.totalCost,),
        );
        Navigator.of(context).push(route);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, top: 5),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xfff9b294),
              Color(0xfff9b294),
            ]),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
          ),
          child: ListTile(
            leading: Icon(Icons.description, size: 40, color: Color(0xffdd3572),),
            title: Container(
                child: AutoSizeText(
              '${widget.timestamp.toDate().toString()}' ,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff7d2c43),
                  fontWeight: FontWeight.bold),
            )),
            isThreeLine: true,
            subtitle: Text(timeago
                .format(DateTime.tryParse(widget.timestamp.toDate().toString()))
                .toString()+', Order Status: ${widget.OrderStatus}'),
            trailing: Icon(Icons.arrow_forward_ios, color: Color(0xffdd3572), size: 30,),
          ),
        ),
      ),
    );
  }
}
