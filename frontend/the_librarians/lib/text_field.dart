import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        child: ClipRRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(135, 141, 184, 227),
                          Colors.blue.shade100
                        ], // Gradient shades
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: readonly ? Colors.transparent : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  readOnly: !readonly,
                  controller: controllers,

                  onChanged: (value) {
                    fetchBook();
                    setstates != null ? setstates(value) : null;
                  },

                  // autofocus: true,
                  ///obscureText: false,
                  decoration: InputDecoration(
                    //hintText: 'book\'s code number',
                    hintText: hinttext,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(56, 122, 177, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 56, 122, 177),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                  //validator: _model.textController2Validator.asValidator(context),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Future<List<String>> fetchBook() async {
  final response = await http.get(Uri.parse("http://localhost:8080/get"));

  List<dynamic> dartobj = jsonDecode(response.body);
  List<String> stringdartobj = [];
  for (int i = 0; i < dartobj.length; i++) {
    stringdartobj.add(dartobj[i].toString());
  }

  return stringdartobj;
}
