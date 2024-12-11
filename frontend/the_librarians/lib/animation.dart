import 'dart:ui';

import 'package:flutter/material.dart';

class AnimationAppBar extends StatefulWidget {
  String text;
  String? route;
  bool currentTab;

  AnimationAppBar(this.text, this.route, {this.currentTab = false});

  @override
  State<AnimationAppBar> createState() => _AnimationAppBarState();
}

class _AnimationAppBarState extends State<AnimationAppBar>
    with SingleTickerProviderStateMixin {
  // AnimationAppBar({
  late Animation<double> _tween;

  late AnimationController _controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller2 =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);

    _tween = Tween<double>(begin: 0, end: 90).animate(_controller2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _tween,
        builder: (context, child) {
          return Column(
            children: [
              MouseRegion(
                onEnter: (e) {
                  _controller2.forward();
                },
                onExit: (e) {
                  _controller2.reverse();
                },
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, widget.route ?? "/");
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: widget.currentTab ? Colors.grey[300] : Colors.white,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: widget.currentTab ? 90 : _tween.value,
                color: Color(0xFF256EBA),
              ),
            ],
          );
        });
  }
}
