import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as hp;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AnimatedSplashScreen(
          splash: Image.asset("assets/gallery.png"),
          nextScreen: MyHomePage(),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: Colors.amber,
          duration: 3,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data = [];
  bool showImage = false;
  List<String> imgUrl = [];
  getData() async {
    hp.Response response = await hp.get(
        "https://api.unsplash.com/photos/?client_id=iSB5JcXyvnyGPbCsNPV-3bINw4iu424vqrvRbAGlCt8");
    data = json.decode(response.body);
    _assign();
    setState(() {
      showImage = true;
    });
  }

  _assign() {
    for (var i = 0; i < data.length; i++) {
      imgUrl.add(data.elementAt(i)["urls"]["regular"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Gallery"),
        ),
        body: Container(
            padding: EdgeInsets.all(15.0),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Container(
                      child: showImage
                          ? GestureDetector(
                              child: Image.network(
                                imgUrl.elementAt(index),
                              ),
                              onTap: () {
                                modalBottomSheet(imgUrl.elementAt(index));
                              })
                          : CircularProgressIndicator());
                })));
  }

  void modalBottomSheet(String img) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.75, //set this as you want
              maxChildSize: 1, //set this as you want
              minChildSize: 0.75,
              expand: true,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Image.network(img,fit:BoxFit.cover),
                );
              });
        });
  }
}
