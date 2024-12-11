import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_librarians/animation.dart';
import 'package:the_librarians/return.dart';
import 'package:the_librarians/text_field.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // initialRoute: "/",
        routes: {
          //   '/': (context) => MyApp(),
          '/ReturnBook': (context) => ReturnBook(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define your app's theme properties here
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Readex Pro',
              color: Colors.white70,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        home: book_return());
  }
}

class book_return extends StatefulWidget {
  const book_return({super.key});

  @override
  State<book_return> createState() => _book_returnState();
}

class _book_returnState extends State<book_return>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation _tween;
  late Animation _tweening;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  var count = 0;
  Color? clrValue = Colors.white;
  void clearallcontrollers() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
    controller6.clear();
  }

  @override
  void initState() {
    super.initState();
    set_sort().then((value) => db_list = value);
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    // _controller2 =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // _tween = new Tween<double>(begin: 0, end: 100).animate(_controller);
    // _tweening = new Tween<double>(begin: 0, end: 100).animate(_controller2);
  }

  void updatedateonui_onpressed() {
    setState(() {
      var datetime = DateTime.now();
      controller5.text =
          "${datetime.hour}:${datetime.minute}:${datetime.second}".toString();
      controller6.text = datetime.minute < 59
          ? "${datetime.hour}:${datetime.minute + 1}:${datetime.second}"
          : "${datetime.hour + 1}:${datetime.minute - 59}:${datetime.second}";
    });
  }

  Future<void> UpdateDateAndBool_OnPressed() async {
    Map<String, dynamic> map = {
      "BookId": int.parse(controller2.text),
      "IssuedTime": controller5.text.toString(),
      "ExpiryTime": controller6.text.toString(),
    };
    print("update date and bool");
    print(controller5.text.toString());
    print(controller6.text.toString());

    var data = json.encode(map);
    print("bhitra chai aaiyo aaba exe herr. \n\n\n");

    var res = await http.post(Uri.parse("http://localhost:8080/posttime"),
        body: data);
  }

  Future<void> postfunction(String bookname) async {
    var data = json.encode(bookname);
    Map<String, dynamic>? decodedmap;

    var response = await http.post(Uri.parse("http://localhost:8080/getother"),
        body: data);

    if (response.statusCode == 200) {
      decodedmap = json.decode(response.body);
      setState(() {
        controller4.text = controller1.text;
        controller3.text = decodedmap!["BookAuthor"] ?? "";
        controller2.text = decodedmap["BookId"].toString();
      });
    } else {
      print(
          "nonononononononononnononnnnoon"); //! i dont care here to check if paramter is equal to reknowned book or not as hoina bhane there wont be any such book name in db and wont returnn status 200
    }
  }

  List<String> sorted = [" "];
  List<String> db_list = ["data not found"];

  Future<List<String>> set_sort() async {
//List fetchedlist= await fetchBook();
    print("======================\n\n");
    List<String> x = await fetchBook();

    return x;
  }
  // db_list=value;

  void setstate_check(String value) async {
    setState(() {
      //fetchBook();
      controller1.text;

      sorted = db_list
          .where((element) =>
              element.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
      if (value == "") {
        count = 0;
        sorted = [" "];
      } else {
        count = 1;
      }
      if (sorted.isEmpty) {
        count = 0;
        sorted = [""];
      }
    });
  }

  Widget list(int index) {
    if (sorted.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text("${sorted[index]}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF256EBA),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReturnBook()));
                //Navigator.pushNamed(context, '/ReturnBook');
              },
              icon: Icon(Icons.arrow_forward))
        ],
        actionsIconTheme: IconThemeData(
          color: const Color.fromARGB(
              255, 245, 245, 245), // Change the color of the icons
          size: 30, // Change the size of the icons
          opacity: 0.8, // Change the opacity of the icons
        ),
        title: Text(
          'The Librarian',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                // You can override specific properties here
                // For example:
                fontSize: 24,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimationAppBar("Lend Book", null, currentTab: true),
                    SizedBox(
                      width: 20,
                      child: VerticalDivider(
                        thickness: 0.4,
                        color: Colors.white,
                      ),
                    ),
                    AnimationAppBar("Return Book", "/ReturnBook",
                        currentTab: false),
                  ],
                ),
              ),
              textfield(
                  text: "Search by book name",
                  controllers: controller1,
                  hinttext: "book's name",
                  icon: true,
                  readonly: true,
                  setstates: setstate_check,
                  postfunction: postfunction,
                  updatedateonui: updatedateonui_onpressed),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: clrValue,
                ),
                height: count == 0 ? 0 : 60,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    if (count == 1) {
                      return MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            clrValue = Colors.grey[300];
                          });
                        },
                        onExit: (e) {
                          setState(() {
                            clrValue = Colors.white;
                          });
                        },
                        child: InkWell(
                          onTap: () {
                            controller1.text = ("${sorted[index]}");
                          },
                          borderRadius: BorderRadius.circular(
                              10), // Matches card's border radius
                          child: ListTile(
                            title: Text(
                              "${sorted[index]}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey), // Adds a trailing arrow
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              textfield(
                  text: "Code number",
                  controllers: controller2,
                  hinttext: "book's code number",
                  icon: false,
                  readonly: false),
              textfield(
                  text: "Author's name",
                  controllers: controller3,
                  hinttext: "book's author's name",
                  icon: false,
                  readonly: false),
              textfield(
                  text: "book name",
                  controllers: controller4,
                  hinttext: "book's name",
                  icon: false,
                  readonly: false),
              textfield(
                  text: "issued date",
                  controllers: controller5,
                  hinttext: "issued date",
                  icon: false,
                  readonly: false),
              textfield(
                  text: "Expiry date",
                  controllers: controller6,
                  hinttext: " expiry date",
                  icon: false,
                  readonly: false),
              const SizedBox(
                height: 40,
              ),
              Container(
                  // padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromRGBO(37, 110, 186, 1),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await UpdateDateAndBool_OnPressed();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text("Done!"),
                            ),
                            content: SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Icon(
                                  Icons.check_circle_outline,
                                  size: 100,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      //clearallcontrollers();
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(3.0),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          // Check if the button is pressed
                          if (states.contains(MaterialState.pressed)) {
                            // Return the color for pressed state
                            return Color.fromRGBO(37, 110, 186, 1);
                          }
                          // Return the default color
                          return Color.fromRGBO(37, 110, 186, 0);
                        },
                      ),
                    ),
                    child: Text(
                      'ok',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
