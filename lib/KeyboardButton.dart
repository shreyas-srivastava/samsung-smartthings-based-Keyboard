import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final List<List<String>> keyLayout;
  final Function(String) onPressButton;
  final Set<String> pressedKeys;

  Keyboard({required this.keyLayout, required this.onPressButton, required this.pressedKeys});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,

        ),
        itemCount: keyLayout.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> rowKeys = keyLayout[index];
          return Expanded(
              child :Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowKeys.map((String key) {
              bool isPressed = pressedKeys.contains(key);
              return Expanded(
                child: InkWell(
                  onTap: () => onPressButton(key),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                      child: RaisedButton(
              color: isPressed ? Colors.blue : Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
              key,
              style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              ),
              ),
              onPressed: () =>onPressButton(key),
                  ),
                ),
              ),
              );

            }).toList(),
          ),);
        },
      ),
    );
  }
}
