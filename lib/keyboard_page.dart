import 'package:flutter/material.dart';
import 'keyboard.dart';

class KeyboardPage extends StatelessWidget {
  final Function(String) onKeyButtonPress;

  KeyboardPage({required this.onKeyButtonPress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keyboard Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Keyboard',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Keyboard(
              keyLayout: [
                ['A', 'B', 'C', 'D', 'E'],
                ['F', 'G', 'H', 'I', 'J'],
                ['K', 'L', 'M', 'N', 'O'],
                ['P', 'Q', 'R', 'S', 'T'],
                ['U', 'V', 'W', 'X', 'Y'],
                ['Z', '0', '1', '2', '3'],
                ['4', '5', '6', '7', '8'],
                ['9', '@', '#', '_', '-'],
              ],
              onPressButton: onKeyButtonPress,
            )
            ,
          ],
        ),
      ),
    );
  }
}
