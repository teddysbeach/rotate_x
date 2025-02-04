import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rotate_x/rotate_x.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RotateX Example',
      home: RotateXExample(),
    );
  }
}

class RotateXExample extends StatefulWidget {
  const RotateXExample({super.key});

  @override
  State<RotateXExample> createState() => _RotateXExampleState();
}

class _RotateXExampleState extends State<RotateXExample> {
  double sliderValue = 0.5;
  RotateXController controller = RotateXController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RotateX Example'),
      ),
      body: Column(
        children: [
          RotateX(
            image: Image.network(
              'https://picsum.photos/300/500',
            ),
            controller: controller,
            scaleFollowsRotation: true,
          ),
          Slider(
            value: sliderValue,
            onChanged: (value) {
              // setState(() {
              controller.angle = (value * 0.5 * pi) - (pi / 4);
              setState(() => sliderValue = value);
              // sliderValue = value;
              // });
            },
          ),
          TextButton(
            onPressed: () {
              controller.angle = 0;
              setState(() => sliderValue = 0.5);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: controller.save,
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
