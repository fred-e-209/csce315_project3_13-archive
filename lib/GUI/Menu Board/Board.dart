import 'dart:async';
import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  final List<String> items;
  final double width;
  final double height;
  final Color color;
  final String title;
  final List<String> orginal_names;
  final List<String> translated_names;

  const Board({Key? key,
    required this.orginal_names,
    required this.translated_names,
    required this.title,
    required this.items,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);


  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  int _startIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _startIndex = (_startIndex + ((widget.height / 17).floor())) % (widget.items.length);
      print(_startIndex);
      if (_startIndex < ((widget.height / 17).floor()))
      {
        _startIndex = 0;
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: widget.color,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              width: widget.width,
              margin: EdgeInsets.only(bottom: widget.height / 100),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child:  Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            for (int i = _startIndex;
            i < _startIndex - 2 + (widget.height / 17).floor() && i < widget.items.length;
            i = i + (widget.width/250).floor())
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              for (int j = i; j < i + (widget.width/250).floor() && j < widget.items.length;j++)
                Container(
                  padding: EdgeInsets.symmetric(vertical: widget.height / 70),
                  child: SizedBox(
                    width: 225,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.translated_names[widget.orginal_names.indexOf(widget.items[j] as String)],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                ],
            ),
          ],
        ),
      ),
    );
  }
}
