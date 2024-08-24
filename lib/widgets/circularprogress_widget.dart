import 'package:flutter/material.dart';

class CircularProgressWidget extends StatefulWidget {
  final String text;
  final Color colors;

  const CircularProgressWidget({
    super.key,
    required this.text,
    required this.colors,
  });

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: widget.colors),
          const SizedBox(width: 15),
          Text(
            widget.text,
            style: TextStyle(color: widget.colors, fontFamily: "MB"),
          ),
        ],
      ),
    );
  }
}
