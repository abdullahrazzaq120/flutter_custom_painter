/*
 * Created by Abdullah Razzaq on 22/08/2025.
*/
import 'package:flutter/material.dart';
import 'package:flutter_custom_painter/paint/signature_paint.dart';
import 'package:flutter_custom_painter/screens/vehicle_select_screen.dart';

class SignatureScreen extends StatefulWidget {
  static String routeName = 'signature-screen';

  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  List<Offset?> points1 = [];
  List<Offset?> points2 = [];

  double canvasHeight = 0;
  double canvasWidth = 0;

  final GlobalKey _firstItemKey = GlobalKey();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    getCanvasSize();
  }

  void getCanvasSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
      _firstItemKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;

      setState(() {
        canvasHeight = size.height - 10; // -10 to give some padding around canvas
        canvasWidth = size.width - 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  key: _firstItemKey,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: SizedBox(
                    height: canvasHeight,
                    width: canvasWidth,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          points1.add(renderBox.globalToLocal(clampToCanvas(details.localPosition)));
                        });
                      },
                      onPanEnd: (details) {
                        points1.add(null); // break between lines
                      },
                      child: CustomPaint(
                        painter: SignaturePainter(points1),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          points1.clear();
                        });
                      },
                      label: const Text("Clear"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        // Text color
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor:
                        Colors.teal.withOpacity(0.5), // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: SizedBox(
                    height: canvasHeight,
                    width: canvasWidth,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          RenderBox renderBox = context.findRenderObject() as RenderBox;
                          points2.add(renderBox.globalToLocal(clampToCanvas(details.localPosition)));
                        });
                      },
                      onPanEnd: (details) {
                        points2.add(null); // break between lines
                      },
                      child: CustomPaint(
                        painter: SignaturePainter(points2),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          points2.clear();
                        });
                      },
                      label: const Text("Clear"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        // Text color
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor:
                            Colors.teal.withOpacity(0.5), // Shadow color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Offset clampToCanvas(Offset point) {
    return Offset(
      point.dx.clamp(0.0, canvasWidth),
      point.dy.clamp(0.0, canvasHeight),
    );
  }
}
