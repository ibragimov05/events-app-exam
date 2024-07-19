import 'package:flutter/material.dart';

class IncrementDecrementWidget extends StatefulWidget {
  final void Function(int) getNumber;

  const IncrementDecrementWidget({super.key, required this.getNumber});

  @override
  State<IncrementDecrementWidget> createState() =>
      _IncrementDecrementWidgetState();
}

class _IncrementDecrementWidgetState extends State<IncrementDecrementWidget> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    widget.getNumber(_counter);
    setState(() {});
  }

  void _decrementCounter() {
    if (_counter != 0) {
      _counter--;

      widget.getNumber(_counter);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: _decrementCounter,
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 20),
        Text(
          '$_counter',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          onPressed: _incrementCounter,
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
