import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_librarians/main.dart';

Widget textfield({
  required text,
  required TextEditingController controllers,
  required String hinttext,
  required bool icon,
  required readonly,
  Function? setstates,
  Function? postfunction,
  Function? updatedateonui,
}) {
  // if (icon == true &&
  //     (postfunction != null || updatedateonui_onpressed != null)) {
  //   throw Exception(
  //       "can't have icon without postfunction inside textfield function initialization");
  // }
  return Column(
    children: [
      Align(
        alignment: AlignmentDirectional(-1, -1),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
        child: TextFormField(
          readOnly: !readonly,
          controller: controllers,

          onChanged: (value) {
            fetchBook();
            setstates != null ? setstates(value) : print("helo");
          },

          // autofocus: true,
          ///obscureText: false,
          decoration: InputDecoration(
            //hintText: 'book\'s code number',
            hintText: hinttext,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            // errorBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.red,
            //     width: 2,
            //   ),
            //   borderRadius: BorderRadius.circular(8),
            // ),
            // focusedErrorBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.red,
            //     width: 2,
            //   ),
            //   borderRadius: BorderRadius.circular(8),
            // ),
            suffixIcon: icon
                ? IconButton(
                    onPressed: () async {
                      await postfunction!(controllers.text);
                      updatedateonui!(); //check if text is valid or wrong
                    },
                    icon: Icon(
                      Icons.check_circle_outline_sharp,
                      size: 35,
                    ),
                  )
                : null,
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            letterSpacing: 0,
          ),
          //validator: _model.textController2Validator.asValidator(context),
        ),
      ),
    ],
  );
}

Future<List<String>> fetchBook() async {
  print("inside fetchbook");
  final response = await http.get(Uri.parse("http://localhost:8080/get"));

  if (response.statusCode == 200) {
    print("hello dev");
  } else {
    print("123312231232");
  }
  List<dynamic> dartobj = jsonDecode(response.body);
  List<String> stringdartobj = [];
  for (int i = 0; i < dartobj.length; i++) {
    stringdartobj.add(dartobj[i].toString());
  }

  return stringdartobj;
}
