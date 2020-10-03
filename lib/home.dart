import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superpedia/show.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "images/bg.gif",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff268a82),
            child: Icon(Icons.refresh),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageTransition(
                  type: PageTransitionType.fadeIn,
                  child: Home(),
                  duration: Duration(milliseconds: 800),
                ),
              );
            },
          ),
          backgroundColor: Colors.transparent,
          body: new Center(
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.6,
              child: new TinderSwapCard(
                swipeUp: true,
                swipeDown: true,
                orientation: AmassOrientation.BOTTOM,
                totalNum: welcomeImages.length,
                stackNum: 3,
                swipeEdge: 1.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 1.2,
                minWidth: MediaQuery.of(context).size.width * 0.89,
                minHeight: MediaQuery.of(context).size.width * 1.19,
                cardBuilder: (context, index) => welcomeImages[index],
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  /// Get swiping card's alignment
                  if (align.x < 0) {
                    //Card is LEFT swiping
                  } else if (align.x > 0) {
                    //Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                  /// Get orientation & index of swiped card!
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SuperHero extends StatelessWidget {
  String pub, intel, strength, speed, durability, power, combat, url;
  Future getImages(String data) async {
    String requestURL =
        "https://www.superheroapi.com/api.php/3262921770495550/search/$data";
    http.Response response = await http.get(requestURL);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      pub = decodedData["results"][0]["biography"]["publisher"];
      intel = decodedData["results"][0]["powerstats"]["intelligence"];
      strength = decodedData["results"][0]["powerstats"]["strength"];
      speed = decodedData["results"][0]["powerstats"]["speed"];
      durability = decodedData["results"][0]["powerstats"]["durability"];
      power = decodedData["results"][0]["powerstats"]["power"];
      combat = decodedData["results"][0]["powerstats"]["combat"];
      url = decodedData["results"][0]["image"]["url"];
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }

  final String name;
  final int index;

  SuperHero({this.name, this.index});
  @override
  Widget build(BuildContext context) {
    void _onLoading() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    return GestureDetector(
      onTap: () async {
        _onLoading();
        await getImages(name);
        Navigator.pop(context);
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.slideInLeft,
            duration: Duration(seconds: 1),
            child: Help(
              name: name,
              index: index,
              intel: intel,
              combat: combat,
              durability: durability,
              power: power,
              pub: pub,
              speed: speed,
              strength: strength,
              url: url,
            ),
          ),
        );
      },
      child: Card(
        color: colors[index],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        elevation: 10.0,
        shadowColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: name,
              child: Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white70,
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(-1, 10), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage("images/$name.jpg")),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              name,
              style: GoogleFonts.sansita(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
