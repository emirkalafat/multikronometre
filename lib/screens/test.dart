import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ParentWidget()));
}

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  /// The item of the list to display
  ///
  /// This will be changed randomly by clicking the button
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: ChildWidget(
                selectedIndex: selectedIndex,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () =>
                  setState(() => selectedIndex = Random().nextInt(100)),
              child: const Center(
                child: Text('Press my to move the list'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  /// The item of the list to display
  ///
  /// Changed randomly by the parent
  final int selectedIndex;

  const ChildWidget({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  /// The colors of the items in the list
  final _itemsColors = List.generate(
    100,
    (index) => getRandomColor(),
  );

  static Color getRandomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  final _controller = PageController();

  void functionOfChildWidget() {
    _controller.animateToPage(
      widget.selectedIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  /// Here is the important part: When data is set from the parent,
  /// move this widget
  @override
  void didUpdateWidget(covariant ChildWidget oldWidget) {
    // If you want to react only to changes you could check
    // oldWidget.selectedIndex != widget.selectedIndex
    functionOfChildWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _controller,
        padEnds: false,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(50),
            color: _itemsColors[index],
            width: 100,
          );
        },
        itemCount: _itemsColors.length,
      ),
    );
  }
}
