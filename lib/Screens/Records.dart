import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  ScrollController _scrollController = new ScrollController();
  //functions:

  //1
  Future<void> getUserID() async {
    final auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      userID = user.uid;
    });
  }

  @override
  void initState() {
    getUserID();
    // TODO: implement initState
    super.initState();
  }

  bool fromTo(Timestamp t, DateTime frm, DateTime to) {
    return t.toDate().isAfter(frm) && t.toDate().isBefore(to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffdd3572), Color(0xffdd3572)])),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffdd3572),
          Color(0xffdd3572),
        ])),
        child: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            SizedBox(height: 30.0),
            Container(
              child: Image.asset(
                'assets/images/record_Icon.png',
                height: 120,
                width: 120,
              ),
            ),
            SizedBox(height: 20.0),
            Center(
                child: Text(
              'From:',
              style: TextStyle(
                  fontSize: 30,
                  color: Color(0xfff9b294),
                  fontWeight: FontWeight.bold),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 28.0),
                Text('${from.year}-${from.month}-${from.day}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
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
                  fontSize: 30,
                  color: Color(0xfff9b294),
                  fontWeight: FontWeight.bold),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 28.0),
                Text('${to.year}-${to.month}-${to.day}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
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
            SizedBox(height: 100.0),
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                color: Colors.white,
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

class RecordItemBuild extends StatefulWidget {
  final Timestamp timestamp;

  const RecordItemBuild({
    Key key,
    this.timestamp,
  }) : super(key: key);

  @override
  _RecordItemBuildState createState() => _RecordItemBuildState();
}

class _RecordItemBuildState extends State<RecordItemBuild> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
          dense: true,
          leading: Icon(Icons.description),
          title: Container(
              child: AutoSizeText(
            widget.timestamp.toDate().toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 20,
                color: Color(0xff7d2c43),
                fontWeight: FontWeight.bold),
          )),
          subtitle: Text(timeago
              .format(DateTime.tryParse(widget.timestamp.toDate().toString()))
              .toString()),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
