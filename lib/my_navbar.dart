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
  double maxIconScale = 1.5;
  double maxBubleRadius = 50;
  AnimationController _controller;
  static const int animationDuration = 300;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.navIndex != widget.navIndex) {
    //   _startAnimation();
    // }
  }

  void _startAnimation() {
    _controller = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );

    // Animacion del circulo
    var _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    Tween<double>(begin: 0, end: 1).animate(_curve)
      ..addListener(() {
        setState(() {
          bubleRadius = maxBubleRadius * _curve.value;
        });
      });

    var scaleUp = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        animationDuration * .5,
        curve: Curves.ease,
      ),
    );

    Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(scaleUp)
      ..addListener(() {
        setState(() {
          bubleRadius = maxBubleRadius * scaleUp.value;
        });
      });

    var scaleDown = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        animationDuration * .5,
        animationDuration * 1.0,
        curve: Curves.ease,
      ),
    );

    Tween<double>(
      begin: 50.0,
      end: 150.0,
    ).animate(scaleDown)
      ..addListener(() {
        setState(() {
          bubleRadius = maxBubleRadius * scaleDown.value;
        });
      });

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
                  beaconRadius: bubleRadius,
                  maxBeaconRadius: maxBubleRadius,
                  showAnimationPainter: i == widget.navIndex,
                ),
                child: Transform.scale(
                  scale: iconScale,
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
  final double beaconRadius;
  final double maxBeaconRadius;
  final bool showAnimationPainter;

  BeaconPainter({
    @required this.beaconRadius,
    @required this.maxBeaconRadius,
    @required this.showAnimationPainter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!showAnimationPainter || beaconRadius == maxBeaconRadius) return;

    double strokeWidth = beaconRadius < (maxBeaconRadius * .5)
        ? beaconRadius
        : maxBeaconRadius - beaconRadius;
    final paint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(25, 25), beaconRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
