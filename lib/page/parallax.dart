import 'package:flutter/material.dart';

class Parallax extends StatefulWidget {
  const Parallax({Key key}) : super(key: key);

  @override
  _ParallaxState createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> {
  double topZero = 0;
  double topOne = 0;
  double topTwo = 0;
  double topThree = 0;
  double topFour = 0;
  double topFive = 0;
  double topSix = 0;
  double topSeven = 0;
  double topEight = 90;

  String asset;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (v) {
        if (v is ScrollUpdateNotification) {
          setState(() {
            topEight = topEight - v.scrollDelta;
            topSeven = topSeven - v.scrollDelta / 1.5;
            topSix = topSix - v.scrollDelta / 2;
            topFive = topFive - v.scrollDelta / 2.5;
            topFour = topFour - v.scrollDelta / 3;
            topThree = topThree - v.scrollDelta / 3.5;
            topTwo = topTwo - v.scrollDelta / 4;
            topOne = topOne - v.scrollDelta / 4.5;
          });
          return true;
        }
        return false;
      },
      child: Stack(
        children: <Widget>[
          ParallaxWidget(top: topZero, asset: "parallax0"),
          ParallaxWidget(top: topOne, asset: "parallax1"),
          ParallaxWidget(top: topTwo, asset: "parallax2"),
          ParallaxWidget(top: topThree, asset: "parallax3"),
          ParallaxWidget(top: topFour, asset: "parallax4"),
          ParallaxWidget(top: topFive, asset: "parallax5"),
          ParallaxWidget(top: topSix, asset: "parallax6"),
          ParallaxWidget(top: topSeven, asset: "parallax7"),
          ParallaxWidget(top: topEight, asset: "parallax8"),
          ListView(
            children: <Widget>[
              Container(
                height: 600,
                color: Colors.transparent,
              ),
              Container(
                color: Color(0xff210002),
                width: double.infinity,
                padding: EdgeInsets.only(top: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Parallax In",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: "MontSerrat-ExtraLight",
                          letterSpacing: 1.8,
                          color: Color(0xffffaf00)),
                    ),
                    Text(
                      "Flutter",
                      style: TextStyle(
                          fontSize: 51,
                          fontFamily: "MontSerrat-Regular",
                          letterSpacing: 1.8,
                          color: Color(0xffffaf00)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 190,
                      child: Divider(
                        height: 1,
                        color: Color(0xffffaf00),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Made By",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Montserrat-Extralight",
                        letterSpacing: 1.3,
                        color: Color(0xffffaf00),
                      ),
                    ),
                    Text(
                      "The CS Guy",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Montserrat-Regular",
                        letterSpacing: 1.8,
                        color: Color(0xffffaf00),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ParallaxWidget extends StatelessWidget {
  const ParallaxWidget({
    Key key,
    @required this.top,
    @required this.asset,
  }) : super(key: key);

  final double top;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -45,
      top: top,
      child: Container(
        height: 550,
        width: 900,
        child: Image.asset("assets/$asset.png", fit: BoxFit.cover),
      ),
    );
  }
}
