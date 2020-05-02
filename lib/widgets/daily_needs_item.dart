import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class dailyNeedsItem extends StatefulWidget {

 final String name;
 final String imgPath;
 final int price;

  const dailyNeedsItem({Key key, this.name, this.imgPath, this.price}) : super(key: key);

  @override
  _dailyNeedsItemState createState() => _dailyNeedsItemState();
}

class _dailyNeedsItemState extends State<dailyNeedsItem> {
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
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold
                            ),
                            text: widget.name,
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
                            'x2',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.0,
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
                }
              ),
              IconButton(
                  icon: Icon(Icons.remove),
                  color: Colors.black,
                  onPressed: () {}
              )
            ],
          )
        ));
  }
}