
import 'package:flutter/material.dart';

class ConfidenceButton extends StatelessWidget {
  final void Function(int) reflect;
  final int confidence;

  const ConfidenceButton(this.reflect, this.confidence, {super.key});

  int pow4(int n) => n * n * n * n;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () => reflect(confidence),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(
                  240 - pow4(confidence) * 15,
                  240 - pow4(2 - confidence) * 15, 0, 0.8),
              minimumSize: const Size.square(40),
              padding: const EdgeInsets.all(10)
          ),
          child: null,
        ),
      ),
    );
  }
}

class ConfidenceRow extends StatelessWidget {
  final void Function(int) reflect;

  const ConfidenceRow(this.reflect, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
            "Are you familiar with this? ",
            style: TextStyle(
                fontSize: 20
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ConfidenceButton(reflect, 0),
            ConfidenceButton(reflect, 1),
            ConfidenceButton(reflect, 2)
          ],
        )
      ],
    );
  }
}
