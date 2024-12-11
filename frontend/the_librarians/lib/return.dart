import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_librarians/animation.dart';
import 'text_field.dart';
import 'package:http/http.dart' as http;

class ReturnBook extends StatefulWidget {
  @override
  State<ReturnBook> createState() => _ReturnBookState();
}

class _ReturnBookState extends State<ReturnBook> {
  TextEditingController bookcode1 = TextEditingController();
  TextEditingController fine2 = TextEditingController();
  TextEditingController bookauthor3 = TextEditingController();
  TextEditingController bookname4 = TextEditingController();
  TextEditingController dateissued5 = TextEditingController();
  TextEditingController dateexpired6 = TextEditingController();

  void clearallcontrollers() {
    bookcode1.clear();
    fine2.clear();
    bookauthor3.clear();
    bookname4.clear();
    dateissued5.clear();
    dateexpired6.clear();
  }

  Map<String, dynamic>? resstring;
  Future<void> postfunction_forreturn(String val) async {
    Map<String, dynamic> map = {
      "BookId": int.parse(bookcode1.text),
    };

    var data = json.encode(map);
    print("bhitra chai aaiyo aaba exe herr. \n\n\n");

    var res = await http.post(Uri.parse("http://localhost:8080/postbookid"),
        body: data);
    resstring = json.decode(res.body);
    print("yoyoyo");
    print(resstring != null ? resstring : "no keys");
    print("\n");
  }

  void updateonui_forreturn() {
    //   TextEditingController bookcode1 = TextEditingController();
    // TextEditingController fine2 = TextEditingController();
    // TextEditingController bookauthor3 = TextEditingController();
    // TextEditingController bookname4 = TextEditingController();
    // TextEditingController dateissued5 = TextEditingController();
    // TextEditingController dateexpired6
    setState(() {
      // print(resstring!["fine"]);
      print("thaguwa thaguwa thaguwa");
      print(resstring);
      fine2.text = resstring!["fine"].toString();
      bookauthor3.text = resstring!["book_author"].toString();
      bookname4.text = resstring!["book_name"].toString();
      dateissued5.text = resstring!["issued_time"].toString();
      dateexpired6.text = resstring!["expiry_time"].toString();
    });
  }

  // db_list=value;

  // void setstate_checkforreturn(String value) async {
  //   setState(() {
  //     //fetchBook();
  //     bookcode1.text;
  //     sorted = db_list_forreturn
  //         .where((element) =>
  //             element.toString().toLowerCase().contains(value.toLowerCase()))
  //         .toList();
  //     if (value == "") sorted = [" "];
  //     if (sorted.isEmpty) sorted = ["Book not found"];
  //   });
  // }

  // Widget list(int index) {
  //   if (sorted.isEmpty) {
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   } else {
  //     return Text("${sorted[index]}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TextEditingController bookcode1 = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF256EBA),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward))
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
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimationAppBar("Lend Book", null),
                    SizedBox(
                      width: 20,
                      child: VerticalDivider(
                        thickness: 0.4,
                        color: Colors.white,
                      ),
                    ),
                    AnimationAppBar("Return Book", "/ReturnBook",
                        currentTab: true)
                  ],
                ),
              ),
              textfield(
                  text: "Search by book ID",
                  controllers: bookcode1,
                  hinttext: "book's ID",
                  icon: true,
                  readonly: true,
                  // setstates: setstate_check,
                  postfunction: postfunction_forreturn,
                  updatedateonui: updateonui_forreturn),
              Divider(
                color: Colors.grey[300],
                thickness: 3,
              ),
              SizedBox(height: 25),

              textfield(
                  text: "Fine(if any)",
                  controllers: fine2,
                  hinttext: "book's code number",
                  icon: false,
                  readonly: false),
              textfield(
                text: "Author's name",
                controllers: bookauthor3,
                hinttext: "book's author's name",
                icon: false,
                readonly: false,
              ),
              textfield(
                text: "book name",
                controllers: bookname4,
                hinttext: "book's name",
                icon: false,
                readonly: false,
              ),
              textfield(
                text: "issued date",
                controllers: dateissued5,
                hinttext: "issued date",
                icon: false,
                readonly: false,
              ),
              textfield(
                text: "Expiry date",
                controllers: dateexpired6,
                hinttext: " expiry date",
                icon: false,
                readonly: false,
              ),
              // Generated code for this Button Widget...
            ],
          ),
        ),
      ),
    );
  }
}
