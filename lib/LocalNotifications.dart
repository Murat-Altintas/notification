import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LinearProgressIndicatorDemo(),
    );
  }
}

class LinearProgressIndicatorDemo extends StatefulWidget {
  @override
  State createState() {
    return LinearProgressIndicatorDemoState();
  }
}

class LinearProgressIndicatorDemoState extends State<LinearProgressIndicatorDemo> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  int integer = 1;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Center(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: 50,
              height: 5,
              child: LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                value: animation.value,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: 50,
              height: 5,
              child: LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                value: animation.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
