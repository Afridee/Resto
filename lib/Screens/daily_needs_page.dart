import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_resto/Screens/Cart.dart';
import 'package:project_resto/widgets/itemBuild.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:project_resto/Screens/Supplies_page.dart';
import 'package:project_resto/widgets/Main_drawer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';

class dailyNeedsPage extends StatefulWidget{
  @override
  _dailyNeedsPageState createState() => _dailyNeedsPageState();
}

class _dailyNeedsPageState extends State<dailyNeedsPage> {

  //variables:
  Icon custom_Icon = Icon(Icons.search);
  Widget search_text = Text('');
  String userID = '';
  int pageIndex = 1;
  PageController pageController;
  String searchQuery;

  //functions:

  //function 1
  void seacrchIconState(){
    setState(() {
      if (this.custom_Icon.icon == Icons.search) {
        this.custom_Icon = Icon(Icons.cancel);
        this.search_text = TextField(
          onChanged: (value){
             setState(() {
               searchQuery = value;
             });
          },
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
    setState(() {
      userID = user.uid;
    });
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
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }
  //function 5
  bool searchFunctionality(String query, String item){
    return item.toLowerCase().trim().contains(query.toLowerCase().trim());
  }
  //function 6
  passedSearchQuery(){
    return searchQuery;
  }

 @override
  void initState() {
    pageController = PageController(initialPage: 1);
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
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
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
          child: mainDrawer(),
        ),
        body:  PageView(
          children: <Widget>[
            suppliesPage(SQ: passedSearchQuery),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
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
                        Text('Daily',
                            style: TextStyle(
                                fontFamily: 'comfortaa',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0)),
                        SizedBox(width: 10.0),
                        Text('Needs',
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
                                      .collection('users/'+userID+'/dailyNeeds')
                                      .snapshots(),
                                  builder: (context, snapshot){
                                      if(!snapshot.hasData){
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
                                      else if(snapshot.hasData){
                                        return ListView.builder(
                                            itemCount: snapshot.data.documents.length,
                                            itemBuilder: (context, index){
                                              if(!snapshot.hasData){
                                                return Text('Loading..');
                                              }
                                              else if(snapshot.hasData && snapshot.data!=null){
                                                if(searchQuery=='' || searchQuery==null){
                                                  return Dismissible(
                                                    direction: DismissDirection.endToStart,
                                                    key: ValueKey(snapshot.data.documents[index]['name']),
                                                    background: Container(
                                                        decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  Color(0xffc72c41),
                                                                  Color(0xffc72c41),
                                                                ]
                                                            )
                                                        ),
                                                        child: Row(
                                                          children: <Widget>[
                                                            SizedBox(width: 260,),
                                                            Icon(Icons.delete, color: Colors.white,)
                                                          ],
                                                        )
                                                    ),
                                                    onDismissed: (direction){
                                                      Firestore.instance.document('users/${userID}/dailyNeeds/${snapshot.data.documents[index]['name']}').delete();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                      child: itemBuild(imgPath: snapshot.data.documents[index]['img'],
                                                          name: snapshot.data.documents[index]['name'],
                                                          price: snapshot.data.documents[index]['price'],
                                                          qty: snapshot.data.documents[index]['qty'],
                                                          desc: snapshot.data.documents[index]['desc'],
                                                          isSupplyPage: false),
                                                    ),
                                                  );
                                                }
                                                else if(searchQuery!='' || searchQuery!=null){
                                                  if(searchFunctionality(searchQuery, snapshot.data.documents[index]['name'])){
                                                    return Padding(
                                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                      child: itemBuild(imgPath: snapshot.data.documents[index]['img'],
                                                          name: snapshot.data.documents[index]['name'],
                                                          price: snapshot.data.documents[index]['price'],
                                                          qty: snapshot.data.documents[index]['qty'],
                                                          desc: snapshot.data.documents[index]['desc'],
                                                          isSupplyPage: false),
                                                    );
                                                  }
                                                }
                                              }
                                              return Container(height: 0.0,width: 0.0);
                                            }
                                        );
                                      }
                                      return Container(width: 0,height: 0,);
                                  },
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Cart()
          ],
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: NeverScrollableScrollPhysics()
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: 1,
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
      );
  }
}