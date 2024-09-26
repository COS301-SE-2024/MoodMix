import 'package:flutter/material.dart';

class FlashingScrollbarWidget extends StatefulWidget {
  final Widget child;

  const FlashingScrollbarWidget({super.key, required this.child});

  @override
  _FlashingScrollbarWidgetState createState() => _FlashingScrollbarWidgetState();
}

class _FlashingScrollbarWidgetState extends State<FlashingScrollbarWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _flashScrollbar();
  }

  Future<void> _flashScrollbar() async {
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.jumpTo(10); // Scroll down by 10 pixels
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.jumpTo(0);  // Scroll back to the top
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}