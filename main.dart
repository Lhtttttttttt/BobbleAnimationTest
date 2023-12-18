//Reference:https://www.bilibili.com/video/BV1Nt4y1v7mc/?spm_id_from=333.337.search-card.all.click//

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: TestPage(),
    ),
  );
}

class TestPage extends StatefulWidget{
  @override
  _TestPageState createState() => _TestPageState();
}

Color getRandomColor(Random random){
  int a = random.nextInt(200);
  return Color.fromARGB(a, 255, 255, 255);
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin{
  List<BobbleBean> _list = [];

  Random _random = new Random(DateTime.now().microsecondsSinceEpoch);

  double _maxSpeed = 1.0;
  double _maxRadius = 100;
  double _maxTheta = 2*pi;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    for(int i = 0; i < 50; i++){
      BobbleBean bean = new BobbleBean();
      bean.color = getRandomColor(_random);
      bean.position = Offset(-1, -1);

      bean.speed = _random.nextDouble() *_maxSpeed;
      bean.radius = _random.nextDouble() *_maxRadius;
      bean.theta = _random.nextDouble() *_maxTheta;

      _list.add(bean);

      _animationController = new AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
      _animationController.addListener(() {
        setState(() {

        });
      });
      _animationController.repeat();
    }

 }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            buildBackground(),
            buildBobbleWidget(context),
          ],
        ),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightBlueAccent.withOpacity(0.3),
                Colors.lightBlue.withOpacity(0.4),
                Colors.blue.withOpacity(0.3),
              ]),
      ),
    );
  }

  buildBobbleWidget(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: CustomMyPainter(list:_list,random:_random),
    );
  }
}

class CustomMyPainter extends CustomPainter{

  List<BobbleBean> list;
  Random random;

  CustomMyPainter({required this.list, required this.random});

  Paint _paint = new Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {
    //calculate position of each point before paint
    list.forEach((element) {
      Offset newCenterOffset = calculateXY(element.speed,element.theta);

      double dx = newCenterOffset.dx + element.position.dx;
      double dy = newCenterOffset.dy + element.position.dy;

      if(dx < 0 || dx > size.width){
        dx = random.nextDouble()*size.width;
      }
      if(dx < 0 || dx > size.height){
        dx = random.nextDouble()*size.height;
      }
      element.position = Offset(dx, dy);
    });

    list.forEach((element) {
      _paint.color = element.color;
      canvas.drawCircle(element.position, element.radius, _paint);
    });

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Offset calculateXY(double speed, double theta) {
    return Offset(speed*cos(theta), speed*sin(theta));
  }

}

class BobbleBean{
  late Offset position;
  late Color color;
  late double speed;
  late double theta;
  late double radius;
}