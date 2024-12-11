import 'dart:convert';

import 'package:flutter/material.dart';
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
    // TextEditingController controller1 = TextEditingController();

    return MaterialApp(
        // initialRoute: "/",
        routes: {
          //'/': (context) => MyApp(),
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

class _book_returnState extends State<book_return> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  void clearallcontrollers() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
    controller6.clear();
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
    print("💦\n\n\n");

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

  void initState() {
    super.initState();

    set_sort().then((value) => db_list = value);
  }

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
      if (value == "") sorted = [" "];
      if (sorted.isEmpty) sorted = ["Book not found"];
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
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(mainAxisSize: MainAxisSize.max, children: [
                      Text(
                        'Lend Book',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          letterSpacing: 0,
                        ),
                      ),
                      AnimatedContainer(
                        width: 70,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        child: Divider(
                          thickness: 3,
                          color: Color(0xFF256EBA),
                        ),
                      ),
                    ]),
                    SizedBox(
                      width: 20,
                      child: VerticalDivider(
                        thickness: 0.4,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Return Book',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                          ),
                        ),
                        AnimatedContainer(
                          width: 70,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          child: Divider(
                            thickness: 3,
                            color: Color(0xFF256EBA),
                          ),
                        ),
                      ],
                    ),
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
              SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: list(index),
                      onTap: () {
                        controller1.text = ("${sorted[index]}");
                      },
                    );
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
              // Generated code for this Button Widget...
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
