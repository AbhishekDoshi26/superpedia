import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superpedia/constants.dart';
import 'package:toast/toast.dart';

class Help extends StatelessWidget {
  final String name;
  final int index;
  final String pub, intel, strength, speed, durability, power, combat, url;
  Help(
      {this.name,
      this.index,
      this.pub,
      this.intel,
      this.strength,
      this.speed,
      this.durability,
      this.power,
      this.combat,
      this.url});

  @override
  Widget build(BuildContext context) {
    Future<void> downloadImage() async {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      String path = '/storage/emulated/0/Download/Superpedia/$name.jpg';
      await Dio().download(
        url,
        path,
      );
      Toast.show(
          'Wallpaper Downloaded in Download/Superpedia folder !', context,
          duration: Toast.LENGTH_LONG);
    }

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
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 1.2,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  elevation: 30.0,
                  color: colors[index],
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.file_download,
                              color: Colors.white70,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              _onLoading();
                              await downloadImage();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20.0,
                            ),
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
                                      offset: Offset(
                                          -1, 10), // changes position of shadow
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          new AssetImage("images/$name.jpg")),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              name + " ( $pub )",
                              style: GoogleFonts.sansita(
                                fontSize: 25.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              "Power Stats",
                              style: GoogleFonts.sansita(
                                fontSize: 23.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Detail(
                              heading: "Intelligence",
                              data: intel,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Detail(
                              heading: "Strength",
                              data: strength,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Detail(
                              heading: "Speed",
                              data: speed,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Detail(
                              heading: "Durability",
                              data: durability,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Detail(
                              heading: "Power",
                              data: power,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Detail(
                              heading: "Combat",
                              data: combat,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  final String heading;
  final String data;
  Detail({this.heading, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "$heading: \t\t\t",
          style: GoogleFonts.sansita(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        Text(
          data + "%",
          style: GoogleFonts.sansita(
            fontSize: 20.0,
            color: Colors.lightGreenAccent,
          ),
        ),
      ],
    );
  }
}
