import 'package:flutter/material.dart';

class MyNavBar extends StatefulWidget {
  int navIndex = 0;
  List<IconData> menuIcons =
      List<IconData>.unmodifiable([Icons.time_to_leave, Icons.hot_tub]);
  MyNavBar({Key key}) : super(key: key);

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> with TickerProviderStateMixin {
  double bubleRadius = 0;
  double iconScale = 1;
  double minIconScale = 1;
  AnimationController _controller;
  final double maxIconScale = 1.5;
  final double maxBubleRadius = 50;
  static const int animationDuration = 500;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(MyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('${oldWidget.navIndex}, ${widget.navIndex}');
    if (oldWidget.navIndex != widget.navIndex) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.reset();

    // Animacion del circulo
    var _curve = CurvedAnimation(parent: _controller, curve: Curves.linear);
    Tween<double>(begin: 0, end: 1).animate(_curve)
      ..addListener(() {
        setState(() {
          bubleRadius = maxBubleRadius * _curve.value;
          if (_curve.value < 0.5) {
            iconScale = 1 + _curve.value;
          } else {
            iconScale = 2 - _curve.value;
          }
        });
      });

    // var scaleUp = CurvedAnimation(
    //   parent: _controller,
    //   curve: Interval(
    //     0.0,
    //     animationDuration * .5,
    //     curve: Curves.ease,
    //   ),
    // );

    // Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(scaleUp)
    //   ..addListener(() {
    //     setState(() {
    //       bubleRadius = maxBubleRadius * scaleUp.value;
    //     });
    //   });

    // var scaleDown = CurvedAnimation(
    //   parent: _controller,
    //   curve: Interval(
    //     animationDuration * .5,
    //     animationDuration * 1.0,
    //     curve: Curves.ease,
    //   ),
    // );

    // Tween<double>(
    //   begin: 50.0,
    //   end: 150.0,
    // ).animate(scaleDown)
    //   ..addListener(() {
    //     setState(() {
    //       bubleRadius = maxBubleRadius * scaleDown.value;
    //     });
    //   });

    // Animacion scale de icono
    // Animation<double> _starAnimSequence = TweenSequence([
    //   TweenSequenceItem<double>(
    //     tween: Tween<double>(begin: 1, end: maxIconScale)
    //         .chain(CurveTween(curve: Curves.easeOut)),
    //     weight: 20.0,
    //   ),
    //   TweenSequenceItem<double>(
    //     tween: Tween<double>(begin: maxIconScale, end: 1)
    //         .chain(CurveTween(curve: Curves.easeOut)),
    //     weight: 30.0,
    //   ),
    // ]).animate(_starAnimSequence)
    //   ..addListener(() {
    //     setState(() {
    //       iconScale = maxIconScale * _curve.value;
    //     });
    //   });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < widget.menuIcons.length; i++)
            GestureDetector(
              child: CustomPaint(
                painter: BeaconPainter(
                  beaconColor: Colors.purple,
                  beaconRadius: bubleRadius,
                  maxBeaconRadius: maxBubleRadius,
                  isActive: i == widget.navIndex,
                ),
                child: Transform.scale(
                  scale: i == widget.navIndex ? iconScale : 1,
                  child: Icon(
                    widget.menuIcons[i],
                    color:
                        i == widget.navIndex ? Colors.redAccent : Colors.white,
                    size: 50,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  widget.navIndex = i;
                  _startAnimation();
                });
              },
            )
        ],
      ),
    );
  }
}

class BeaconPainter extends CustomPainter {
  final Color endColor;
  final Color beaconColor;

  final bool isActive;
  final double beaconRadius;
  final double maxBeaconRadius;

  BeaconPainter({
    @required this.beaconColor,
    @required this.isActive,
    @required this.beaconRadius,
    @required this.maxBeaconRadius,
  }) : endColor = Color.lerp(beaconColor, Colors.white, .8);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive || beaconRadius == maxBeaconRadius) return;

    double strokeWidth = beaconRadius < (maxBeaconRadius * .5)
        ? beaconRadius
        : maxBeaconRadius - beaconRadius;
    final paint = Paint()
      ..color =
          Color.lerp(beaconColor, endColor, beaconRadius / maxBeaconRadius)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(25, 25), beaconRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
