import 'dart:async';
import 'dart:math';

import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:sharedor/export_common.dart';

class Circle {
  double size;
  Color color;
  Size position;
  double opacity = 1;
  Circle(this.size, this.color, this.position, this.opacity);
  void set setOpacity(value) => opacity = value;
}

class SplashScreen extends StatefulWidget {
  SplashScreen({
    Key? key,
  }) : super(key: key);
  List<Circle> circleList = [];

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Widget> widList = [];
  double opacityState = 0;
  double get getOpacity => opacityState;
  bool disposed = false;
  @override
  void initState() {
    super.initState();
    if (widList.length == 0) widList = createChildren();
    int i = 0;
    Timer.periodic(Duration(milliseconds: (400)), (timer) async {
      if (mounted) {
        context.read(opacityStateChanged).setOpacity(i);
        if (i == widList.length - 1 || disposed == true) timer.cancel();
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    disposed = true;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Stack(fit: StackFit.expand, children: widList));
  }

  List<Widget> createChildren() {
    List<Widget> list = [];

    for (var i = 0; i < 10; i++) {
      Circle circle = getCircle();
      widget.circleList.add(circle);
      list.add(getElement(circle, i));
    }
    return list;
  }

  Widget getElement(Circle circle, int i) {
    return Positioned(
      top: circle.position.height,
      left: circle.position.width,
      child: Consumer(builder: (consumercontext, WidgetRef ref, child) {
        double opacity = ref.watch(opacityStateChanged).getOpacity(i);
        return Opacity(
          opacity: opacity,
          child: Text("creeate splash screen"),
        );
      }),
    );
  }

  double randomHight(int cirSize) {
    return (20 +
            Random().nextInt(GlobalParametersFM().screenSize.height.truncate() -
                20 -
                cirSize))
        .toDouble();
  }

  int randomCircleSize() {
    return (4 + Random().nextInt(21)) * 10;
  }

  double randomWidth(int cirSize) {
    return 20 +
        Random()
            .nextInt(
                GlobalParametersFM().screenSize.width.truncate() - 20 - cirSize)
            .toDouble();
  }

  Circle getCircle() {
    List<Color> colors = [
      // BeStyle.main,
      // BeStyle.main2,
      // BeStyle.main3,
      // BeStyle.main4
    ];
    int cirSize = randomCircleSize();
    Circle circle = Circle(cirSize.toDouble(), colors[Random().nextInt(4)],
        Size(randomWidth(cirSize), randomHight(cirSize)), 0);
    return circle;
  }
}

final opacityStateChanged = ChangeNotifierProvider.autoDispose<OpacityState>(
    (ref) => new OpacityState());

class OpacityState extends ChangeNotifier {
  List<double> opacityList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  void setOpacity(i) {
    opacityList[i] = 1;
    notifyListeners();
  }

  double getOpacity(i) {
    return opacityList[i];
  }
}
