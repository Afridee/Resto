import 'package:flutter/material.dart';

class itemDetail extends StatelessWidget {
  final String imgPath;
  final int price;
  final String name;
  final String desc;
  final bool addToDailyNeeds;

  itemDetail({this.imgPath, this.price, this.name, this.desc, this.addToDailyNeeds});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
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
                      fontSize: 42.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffdd3572))
              ),
            ),
            SizedBox(height: 15.0),
            Hero(
                tag: name,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xfff9b294),
                  child: ClipOval(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                       child: Image.network(imgPath,
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                )
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text('৳'+price.toString(),
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffdd3572))),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(name,
                  style: TextStyle(
                      color: Color(0xFF575E67),
                      fontFamily: 'Varela',
                      fontSize: 24.0)),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50.0,
                child: Text(desc,
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
                child: addToDailyNeeds? Container(
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
                ) : Container(
                  height: 0.0,
                  width: 0.0,
                )
            )
          ]
      ),
    );
  }
}