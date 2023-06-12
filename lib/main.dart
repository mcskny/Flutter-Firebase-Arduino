
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart';

/// Flutter code sample for [NavigationBar].

const bg = Color.fromRGBO(5, 16, 58, 1);
const kPrimaryColor = Color(0xFF283663);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
    theme: ThemeData(
      // ignore: deprecated_member_use
      backgroundColor: bg,
      useMaterial3: true,
      colorSchemeSeed: const Color.fromRGBO(11, 20, 51, 1),
      
    ),
  ));
}

DatabaseReference _nightMode =
    FirebaseDatabase.instance.ref().child("nightMode");
DatabaseReference _doorSens = FirebaseDatabase.instance.ref().child("doorSens");
DatabaseReference _slientMode =
    FirebaseDatabase.instance.ref().child("slientMode");
DatabaseReference room1 = FirebaseDatabase.instance.ref().child("light1");
DatabaseReference room2 = FirebaseDatabase.instance.ref().child("light2");
DatabaseReference room3 = FirebaseDatabase.instance.ref().child("light3");
DatabaseReference room4 = FirebaseDatabase.instance.ref().child("light4");
DatabaseReference _temp = FirebaseDatabase.instance.ref().child("temperature");
DatabaseReference _hum = FirebaseDatabase.instance.ref().child("humidity");

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  int currentPageIndex = 0;
  final Future<FirebaseApp> futur = Firebase.initializeApp();
  String nightMode = "Downloading";
  String doorSens = "Downloading";
  String slientMode = "Downloading";
  double temp = 0.0;
  double hum = 0.0;
  bool light1 = false;
  bool light2 = false;
  bool light3 = false;
  bool light4 = false;
  double minValue = 0.0;
  double maxValue = 70.0;
  double minValue2 = 0.0;
  double maxValue2 = 100.0;
  double newMinValue = 0.0;
  double newMaxValue = 1.0;

  int _selectedTag = 0;
  bool colorData = false;
  bool colorData2 = false;
  bool colorData3 = false;
  bool colorData4 = false;

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      
      backgroundColor: bg,
      body: FutureBuilder(
        future: futur,
        builder: (context, snapshot) {
          Center(
            child: Image.asset('assets/logo.png'),
          );
          if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.hasData) {
            return content();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget content() {
    _nightMode.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "1") {
            nightMode = "On";
          } else {
            nightMode = "Off";
          }
        });
      },
    );
    _temp.onValue.listen(
      (event) {
        setState(() {
          temp = double.parse(event.snapshot.value.toString());
        });
      },
    );
    _hum.onValue.listen(
      (event) {
        setState(() {
          hum = double.parse(event.snapshot.value.toString());
        });
      },
    );

    _doorSens.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "1") {
            doorSens = "On";
          } else {
            doorSens = "Off";
          }
        });
      },
    );
    _slientMode.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "1") {
            slientMode = "On";
          } else {
            slientMode = "Off";
          }
        });
      },
    );
    room1.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "true") {
            light1 = true;
          } else {
            light1 = false;
          }
        });
      },
    );
    room2.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "true") {
            light2 = true;
          } else {
            light2 = false;
          }
        });
      },
    );
    room3.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "true") {
            light3 = true;
          } else {
            light3 = false;
          }
        });
      },
    );
    room4.onValue.listen(
      (event) {
        setState(() {
          if (event.snapshot.value.toString() == "true") {
            light4 = true;
          } else {
            light4 = false;
          }
        });
      },
    );
    if (light1 == false) {
      colorData = false;
    }
    if (light1 == true) {
      colorData = true;
    }
    if (light2 == false) {
      colorData2 = false;
    }
    if (light2 == true) {
      colorData2 = true;
    }
    if (light3 == false) {
      colorData3 = false;
    }
    if (light3 == true) {
      colorData3 = true;
    }
    if (light4 == false) {
      colorData4 = false;
    }
    if (light4 == true) {
      colorData4 = true;
    }
    double normalizedValue = (temp - minValue) /
            (maxValue - minValue) *
            (newMaxValue - newMinValue) +
        newMinValue;
    double normalizedValue2 = (hum - minValue2) /
            (maxValue2 - minValue2) *
            (newMaxValue - newMinValue) +
        newMinValue;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(16, 28, 67, 1),
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index; // Seçili olan öğe indeksi güncellenir
          });
        },
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromRGBO(122, 122, 122, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.door_front_door),
            label: 'Door',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Lights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Temp And Humidity',
          ),
        ],
      ),
      body: <Widget>[
        // Figma Flutter Generator Group10Widget - GROUP

        Container(
          color: bg,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: 362,
                    height: 101,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 362,
                              height: 101,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                                color: Color.fromRGBO(16, 28, 67, 1),
                              ))),
                      const Positioned(
                        top: 18,
                        left: 19,
                        child: Text(
                          'Welcome,',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Nunito',
                              fontSize: 24,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      const Positioned(
                        top: 55,
                        left: 19,
                        child: Text(
                          'Muhammed Ali',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Nunito',
                              fontSize: 24,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      Positioned(
                          top: 12,
                          left: 269,
                          child: Container(
                              width: 76,
                              height: 76,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Rectangle15.jpg'),
                                    fit: BoxFit.fitWidth),
                              ))),
                    ])),
              ),
              const SizedBox(
                height: 150,
              ),
              Visibility(
                visible: doorSens == "On" ? false : true,
                child:
                    // Figma Flutter Generator Group6Widget - GROUP
                    SizedBox(
                        width: 329,
                        height: 192,
                        child: Stack(children: <Widget>[
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                  width: 329,
                                  height: 181,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(37),
                                      topRight: Radius.circular(37),
                                      bottomLeft: Radius.circular(37),
                                      bottomRight: Radius.circular(37),
                                    ),
                                    color: Color.fromRGBO(16, 28, 67, 1),
                                  ))),
                          const Positioned(
                              top: 22,
                              left: 23.93600082397461,
                              child: Text(
                                'Door',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Nunito',
                                    fontSize: 72,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                          const Positioned(
                              top: 112,
                              left: 23.93600082397461,
                              child: Text(
                                'Off',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(204, 204, 204, 1),
                                    fontFamily: 'Nunito',
                                    fontSize: 40,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                          Positioned(
                              top: 110,
                              left: 250.58399963378906,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(31),
                                    topRight: Radius.circular(31),
                                    bottomLeft: Radius.circular(31),
                                    bottomRight: Radius.circular(31),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        offset: Offset(6, 6),
                                        blurRadius: 4)
                                  ],
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                ),
                              )),
                        ])),
              ),
              Visibility(
                visible: doorSens == "On" ? true : false,
                child:
                    // Figma Flutter Generator Group6Widget - GROUP
                    SizedBox(
                        width: 329,
                        height: 192,
                        child: Stack(children: <Widget>[
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                  width: 329,
                                  height: 181,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(37),
                                      topRight: Radius.circular(37),
                                      bottomLeft: Radius.circular(37),
                                      bottomRight: Radius.circular(37),
                                    ),
                                    color: Color.fromRGBO(16, 28, 67, 1),
                                  ))),
                          const Positioned(
                              top: 22,
                              left: 23.93600082397461,
                              child: Text(
                                'Door',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: 'Nunito',
                                    fontSize: 72,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                          const Positioned(
                              top: 112,
                              left: 23.93600082397461,
                              child: Text(
                                'On',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color.fromRGBO(204, 204, 204, 1),
                                    fontFamily: 'Nunito',
                                    fontSize: 40,
                                    letterSpacing:
                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.normal,
                                    height: 1),
                              )),
                          Positioned(
                              top: 110,
                              left: 250.58399963378906,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(31),
                                    topRight: Radius.circular(31),
                                    bottomLeft: Radius.circular(31),
                                    bottomRight: Radius.circular(31),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        offset: Offset(6, 6),
                                        blurRadius: 4)
                                  ],
                                  color: Color.fromRGBO(4, 255, 0, 1),
                                ),
                              )),
                        ])),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                child: CustomTabView(
                  index: _selectedTag,
                  changeTab: changeTab,
                ),
              ),
              _selectedTag == 0
                  ? const SlientMode()
                  : (_selectedTag == 1 ? const NightMode() : const SoundOn()),
            ],
          ),
        ),
        Container(
          color: bg,
          alignment: Alignment.topCenter,
          child:
              // Figma Flutter Generator Group11Widget - GROUP
              SizedBox(
                  width: 368,
                  height: 710,
                  child: Stack(children: <Widget>[
                    Stack(
                      children: [
                        Positioned(
                          top: 20,
                          left: 3,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                                width: 362,
                                height: 101,
                                child: Stack(children: <Widget>[
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                          width: 362,
                                          height: 101,
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32),
                                                topRight: Radius.circular(32),
                                                bottomLeft: Radius.circular(32),
                                                bottomRight:
                                                    Radius.circular(32),
                                              ),
                                              color: Color.fromRGBO(
                                                  16, 28, 67, 1)))),
                                  const Positioned(
                                    top: 18,
                                    left: 19,
                                    child: Text(
                                      'Welcome,',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Nunito',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 55,
                                    left: 19,
                                    child: Text(
                                      'Muhammed Ali',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Nunito',
                                          fontSize: 24,
                                          letterSpacing:
                                              0 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.normal,
                                          height: 1),
                                    ),
                                  ),
                                  Positioned(
                                      top: 12,
                                      left: 269,
                                      child: Container(
                                          width: 76,
                                          height: 76,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                              bottomLeft: Radius.circular(50),
                                              bottomRight: Radius.circular(50),
                                            ),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/Rectangle15.jpg'),
                                                fit: BoxFit.fitWidth),
                                          ))),
                                ])),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 163,
                        left: 0,
                        child: SizedBox(
                            width: 174,
                            height: 147,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 174,
                                      height: 147,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData == false
                                            ? const Color.fromRGBO(
                                                16, 28, 67, 1)
                                            : const Color.fromRGBO(
                                                74, 208, 238, 1),
                                      ))),
                              Positioned(
                                  top: 9,
                                  left: 14,
                                  child: Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData == false
                                            ? const Color.fromRGBO(9, 18, 45, 1)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ))),
                              const Positioned(
                                  top: 65,
                                  left: 14,
                                  child: Text(
                                    'Living room',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 107,
                                  left: 14,
                                  child: Text(
                                    colorData == false ? 'Off' : 'On',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                top: 107,
                                left: 104,
                                child: FlutterSwitch(
                                  width: 43.0,
                                  height: 21.0,
                                  toggleSize: 21.0,
                                  value: colorData,
                                  borderRadius: 30.0,
                                  padding: 0.0,
                                  toggleColor:
                                      const Color.fromRGBO(225, 225, 225, 1),
                                  activeColor:
                                      const Color.fromRGBO(146, 227, 245, 1),
                                  inactiveColor: Colors.black38,
                                  onToggle: (val) {
                                    setState(() {
                                      room1.set(val);
                                      colorData = val;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                  top: 14,
                                  left: 19,
                                  child: SizedBox(
                                      width: 46,
                                      height: 36,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 4,
                                          left: 2.5,
                                          child: Icon(
                                            Icons.lightbulb_outlined,
                                            color: colorData == false
                                                ? const Color.fromARGB(
                                                    255, 255, 254, 254)
                                                : const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            size: 30,
                                          ),
                                        ),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 163,
                        left: 189,
                        child: SizedBox(
                            width: 174,
                            height: 147,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 174,
                                      height: 147,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData2 == false
                                            ? const Color.fromRGBO(
                                                16, 28, 67, 1)
                                            : const Color.fromRGBO(
                                                74, 208, 238, 1),
                                      ))),
                              Positioned(
                                  top: 9,
                                  left: 14,
                                  child: Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData2 == false
                                            ? const Color.fromRGBO(9, 18, 45, 1)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ))),
                              const Positioned(
                                  top: 65,
                                  left: 14,
                                  child: Text(
                                    'Kitchen',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 107,
                                  left: 14,
                                  child: Text(
                                    colorData2 == false ? 'Off' : 'On',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                top: 107,
                                left: 104,
                                child: FlutterSwitch(
                                  width: 43.0,
                                  height: 21.0,
                                  toggleSize: 21.0,
                                  value: colorData2,
                                  borderRadius: 30.0,
                                  padding: 0.0,
                                  toggleColor:
                                      const Color.fromRGBO(225, 225, 225, 1),
                                  activeColor:
                                      const Color.fromRGBO(146, 227, 245, 1),
                                  inactiveColor: Colors.black38,
                                  onToggle: (val) {
                                    setState(() {
                                      room2.set(val);
                                      colorData2 = val;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                  top: 14,
                                  left: 19,
                                  child: SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 4,
                                          left: 2.5,
                                          child: Icon(
                                            Icons.lightbulb_outlined,
                                            color: colorData2 == false
                                                ? const Color.fromARGB(
                                                    255, 255, 254, 254)
                                                : const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            size: 30,
                                          ),
                                        ),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 323,
                        left: 0,
                        child: SizedBox(
                            width: 174,
                            height: 147,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 174,
                                      height: 147,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData3 == false
                                            ? const Color.fromRGBO(
                                                16, 28, 67, 1)
                                            : const Color.fromRGBO(
                                                74, 208, 238, 1),
                                      ))),
                              Positioned(
                                  top: 9,
                                  left: 14,
                                  child: Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData3 == false
                                            ? const Color.fromRGBO(9, 18, 45, 1)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ))),
                              const Positioned(
                                  top: 65,
                                  left: 14,
                                  child: Text(
                                    'Bathroom',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 107,
                                  left: 14,
                                  child: Text(
                                    colorData3 == false ? 'Off' : 'On',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                top: 107,
                                left: 104,
                                child: FlutterSwitch(
                                  width: 43.0,
                                  height: 21.0,
                                  toggleSize: 21.0,
                                  value: colorData3,
                                  borderRadius: 30.0,
                                  padding: 0.0,
                                  toggleColor:
                                      const Color.fromRGBO(225, 225, 225, 1),
                                  activeColor:
                                      const Color.fromRGBO(146, 227, 245, 1),
                                  inactiveColor: Colors.black38,
                                  onToggle: (val) {
                                    setState(() {
                                      room3.set(val);
                                      colorData3 = val;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                  top: 14,
                                  left: 19,
                                  child: SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 4,
                                          left: 2.5,
                                          child: Icon(
                                            Icons.lightbulb_outline,
                                            color: colorData3 == false
                                                ? const Color.fromARGB(
                                                    255, 255, 254, 254)
                                                : const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            size: 30,
                                          ),
                                        ),
                                      ]))),
                            ]))),
                    Positioned(
                        top: 323,
                        left: 189,
                        child: SizedBox(
                            width: 174,
                            height: 147,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                      width: 174,
                                      height: 147,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData4 == false
                                            ? const Color.fromRGBO(
                                                16, 28, 67, 1)
                                            : const Color.fromRGBO(
                                                74, 208, 238, 1),
                                      ))),
                              Positioned(
                                  top: 9,
                                  left: 14,
                                  child: Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(26),
                                          topRight: Radius.circular(26),
                                          bottomLeft: Radius.circular(26),
                                          bottomRight: Radius.circular(26),
                                        ),
                                        color: colorData4 == false
                                            ? const Color.fromRGBO(9, 18, 45, 1)
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ))),
                              const Positioned(
                                  top: 65,
                                  left: 14,
                                  child: Text(
                                    "Children's room",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 19,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 107,
                                  left: 14,
                                  child: Text(
                                    colorData4 == false ? 'Off' : 'On',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Nunito',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                top: 107,
                                left: 104,
                                child: FlutterSwitch(
                                  width: 43.0,
                                  height: 21.0,
                                  toggleSize: 21.0,
                                  value: colorData4,
                                  borderRadius: 30.0,
                                  padding: 0.0,
                                  toggleColor:
                                      const Color.fromRGBO(225, 225, 225, 1),
                                  activeColor:
                                      const Color.fromRGBO(146, 227, 245, 1),
                                  inactiveColor: Colors.black38,
                                  onToggle: (val) {
                                    setState(() {
                                      room4.set(val);
                                      colorData4 = val;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                  top: 14,
                                  left: 19,
                                  child: SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                          top: 4,
                                          left: 2.5,
                                          child: Icon(
                                            Icons.lightbulb_outline,
                                            color: colorData4 == false
                                                ? const Color.fromARGB(
                                                    255, 255, 254, 254)
                                                : const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            size: 30,
                                          ),
                                        ),
                                      ]))),
                            ]))),
                            
                  ])),
        ),
        Container(
          color: bg,
          alignment: Alignment.center,
          
          child:
          Column(
            
            children: [
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: 362,
                    height: 101,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 362,
                              height: 101,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                                color: Color.fromRGBO(16, 28, 67, 1),
                              ))),
                      const Positioned(
                        top: 18,
                        left: 19,
                        child: Text(
                          'Welcome,',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Nunito',
                              fontSize: 24,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      const Positioned(
                        top: 55,
                        left: 19,
                        child: Text(
                          'Muhammed Ali',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Nunito',
                              fontSize: 24,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                      Positioned(
                          top: 12,
                          left: 269,
                          child: Container(
                              width: 76,
                              height: 76,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Rectangle15.jpg'),
                                    fit: BoxFit.fitWidth),
                              ))),
                    ])),
              ),
              SizedBox(height: 20,),
           Positioned(
            child: SizedBox(
              height: 300,
              width: 300,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(16, 28, 67, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(500),
                  ),
                ),
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 30.0,
                  percent: normalizedValue,
                  center: Column(
                    children: [
                      SizedBox(
                        height: 65,
                      ),
                      Positioned(
                        top: 200,
                        
                        child: Column(
                    children: [
                      const Text(
                        "Temp",
                        style: TextStyle(
                          color: Color.fromRGBO(122, 122, 122, 1),
                          fontFamily: 'Nunito',
                          fontSize: 28,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      Text(
                        temp.toString(),
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Nunito',
                          fontSize: 58,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      const Text(
                        "Celcius",
                        style: TextStyle(
                          color: Color.fromRGBO(122, 122, 122, 1),
                          fontFamily: 'Nunito',
                          fontSize: 24,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      ],),
                      ),

                    ],
                  ),
                  backgroundColor: Color.fromRGBO(40, 54, 99, 1),
                  progressColor: Color.fromRGBO(74, 208, 238, 1),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
           Positioned(
            child: SizedBox(
              height: 300,
              width: 300,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(16, 28, 67, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(500),
                  ),
                ),
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 30.0,
                  percent: normalizedValue2,
                  center: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Positioned(
                        top: 200,
                        
                        child: Column(
                    children: [
                      const Text(
                        "Humidity",
                        style: TextStyle(
                          color: Color.fromRGBO(122, 122, 122, 1),
                          fontFamily: 'Nunito',
                          fontSize: 28,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      Text(
                        hum.toString(),
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Nunito',
                          fontSize: 58,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      const Text(
                        "%",
                        style: TextStyle(
                          color: Color.fromRGBO(122, 122, 122, 1),
                          fontFamily: 'Nunito',
                          fontSize: 32,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      ],),
                      ),

                    ],
                  ),
                  backgroundColor: Color.fromRGBO(40, 54, 99, 1),
                  progressColor: Color.fromRGBO(74, 208, 238, 1),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
          ),
          
          
          ],),
        ),
      ][currentPageIndex],
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;
  const CustomTabView(
      {super.key, required this.changeTab, required this.index});

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["Slient Mode", "Night Mode", "Alarm Mode"];
  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .016,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: widget.index == index ? kPrimaryColor : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
            fontSize: 16.5,
            fontFamily: 'Nunito',
            color: widget.index != index
                ? const Color.fromRGBO(99, 99, 99, 1)
                : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(16, 28, 67, 1),
      ),
      child: Row(
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
      ),
    );
  }
}

class SlientMode extends StatelessWidget {
  const SlientMode({super.key});

  @override
  Widget build(BuildContext context) {
    _slientMode.set("1");
    _nightMode.set("0");
    return const SizedBox();
  }
}

class NightMode extends StatelessWidget {
  const NightMode({super.key});

  @override
  Widget build(BuildContext context) {
    _nightMode.set("1");
    _slientMode.set("0");

    return const SizedBox();
  }
}

class SoundOn extends StatelessWidget {
  const SoundOn({super.key});

  @override
  Widget build(BuildContext context) {
    _nightMode.set("0");
    _slientMode.set("0");
    return const SizedBox();
  }
}
