import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ControlApp());
}

class ControlApp extends StatelessWidget {
  Map<String, Map<String, String>> mappedFunctions = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOT Keyboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ControlScreen(),
      },
    );
  }
}

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Screen'),
      ),
      body: Container(
        // Add your UI widgets here
      ),
    );
  }
}


class _ControlScreenState extends State<ControlScreen> {
List<List<String>> keyLayout=
  [
  ['A', 'B', 'C', 'D', 'E'],
  ['F', 'G', 'H', 'I', 'J'],
  ['K', 'L', 'M', 'N', 'O'],
  ['P', 'Q', 'R', 'S', 'T'],
  ['U', 'V', 'W', 'X', 'Y'],
  ['Z', '0', '1', '2', '3'],
  ['4', '5', '6', '7', '8'],
  ['9', '@', '#', '_', '-'],
  ];
  List<List<String>> devices = [
    ['Device1','dev1'],
    ['Device1','dev2'],
    ['Device1','dev1'],
    // Add more devices as needed
  ];

  List<String> functions = [
    'Power',
    'Function 2',
    'Function 3',
    // Add more functions as needed
  ];
Set<String> pressed = Set<String>();

// Adding strings to the set
//   pressed.add("A");


  @override
  void initState() {
    super.initState();
    fetchDevices(); // Fetch devices when the screen initializes
  }

  Future<void> fetchDevices() async {
    try {
      var headers = {
        'Authorization': 'Bearer 4208a9b1-1347-4b1c-9226-96af47ac80af'
      };
      var request = http.Request('GET', Uri.parse('https://api.smartthings.com/v1/devices'));
      var res;
      List<String> dev=[];
      List <List<String>> devs=[];
      request.headers.addAll(headers);

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        res = await response.stream.bytesToString();
        var data = json.decode(res)["items"];
        print(data[0]["name"]);
        for (int i = 0; i < data.length; i++) {
          dev=[];
          // Do something with the JSON object
          dev.add(data[i]["name"]);
          dev.add(data[i]["deviceId"]);
          devs.add(dev);
        }
        print(devs);
        devices = devs;
      }
      else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      // Handle error
      print('Failed to fetch devices. Error: $e');
    }
  }





  String selectedDevice = '';
  String selectedFunction = '';
  String selectedKey = '';
  Map<String, Map<String, String>> mappedFunctions = {};



  void handleMapButtonPress() {
    if (selectedDevice.isNotEmpty &&
        selectedFunction.isNotEmpty &&
        selectedKey.isNotEmpty) {
      print(mappedFunctions);
      setState(() {
        mappedFunctions[selectedKey] = {
          'device': selectedDevice,
          'function': selectedFunction
        };
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Function mapped successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select device, function, and key before mapping.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

void handleSelectKeyButtonPress() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keyboard'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: keyLayout.map((row) {
              return Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((key) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          color: (key==selectedKey) ? Colors.blue : Colors.white,
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
                          onPressed: () => handleSelectKeyPress(key),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
        child: Text('Map'),
        onPressed: handleMapButtonPress),
          ],
        );
      },
    );

}

void handleSelectKeyPress(String value) async{
  setState(() {
    selectedKey = value;
  });
}

  void handleNextButtonPress() {
    if (mappedFunctions.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select device, function, and key before mapping.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Keyboard'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: keyLayout.map((row) {
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row.map((key) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            color: Colors.white,
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
                            onPressed: () => handleKeyButtonPress(key),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    }
  }

// void handleNextButtonPress() {
//   if (mappedFunctions.isEmpty) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(
//               'Please select device, function, and key before mapping.'),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//             title: Text('Keyboard'),
//         content: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         child: Keyboard(keyLayout:keyLayout,onPressButton:handleKeyButtonPress,pressedKeys: pressed),
//         ),
//         actions: [
//             TextButton(
//               child: Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

  void handleKeyButtonPress(String value) async{
    Map<String, String>? mappedFunction = mappedFunctions[value];

    if (mappedFunction != null) {
      String devid = mappedFunction['device']??"";
      var status="failed";
      print(devid);
      var headers = {
        'Authorization': 'Bearer 4208a9b1-1347-4b1c-9226-96af47ac80af'
      };
      var request = http.Request('GET', Uri.parse('https://api.smartthings.com/v1/devices/'+devid+'/status'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var res = await response.stream.bytesToString();
        var data = json.decode(res);
        status=data["components"]["main"]["switch"]["switch"]["value"];
      }
      else {
        print(response.reasonPhrase);
      }

      if(status!="failed")
        {
      headers = {
        'Content-Type': 'text/plain',
        'Authorization': 'Bearer 4208a9b1-1347-4b1c-9226-96af47ac80af'
      };
      request = http.Request('POST', Uri.parse('https://api.smartthings.com/v1/devices/'+devid+'/commands'));

      if(status=="off")
        {
          request.body =
              '''{\r\n"commands": [\r\n{\r\n"component": "main",\r\n"capability": "switch",\r\n"command": "on"\r\n}\r\n]\r\n}''';
        }
      else
        {
          request.body =
          '''{\r\n"commands": [\r\n{\r\n"component": "main",\r\n"capability": "switch",\r\n"command": "off"\r\n}\r\n]\r\n}''';
        }




      request.headers.addAll(headers);
      print(status);
      print('Sending command');
      response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
      print(
          'Performing function "${mappedFunction['function']}" for device "${mappedFunction['device']}"');
    } else {
      print('No function mapped for key "$value"');
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Device:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedDevice = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return devices.map((device) {
                  return PopupMenuItem<String>(
                    value: device[1],
                    child: Text(device[0]),
                  );
                }).toList();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDevice),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select Function:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedFunction = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return functions.map((function) {
                  return PopupMenuItem<String>(
                    value: function,
                    child: Text(function),
                  );
                }).toList();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedFunction),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Select Key'),
              onPressed: handleSelectKeyButtonPress,
            ),
            // SizedBox(height: 16.0),
            // ElevatedButton(
            //   child: Text('Map'),
            //   onPressed: handleMapButtonPress,
            // ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Test'),
              onPressed: handleNextButtonPress,
            ),
          ],
        ),
      ),
    );
  }
}


class KeyboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keyboard'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Open Keyboard'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Keyboard'),
                  content: GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(9, (index) {
                      return TextButton(
                        child: Text((index + 1).toString()),
                        onPressed: () {
                          // Handle key press
                        },
                      );
                    }),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// class KeyboardScreen extends StatelessWidget {
//   final Map<String, Map<String, String>> mappedFunctions;
//
//   KeyboardScreen({required this.mappedFunctions});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Keyboard'),
//       ),
//       body: Center(
//         child: Keyboard(
//           keyLayout: [
//             ['A', 'B', 'C', 'D', 'E'],
//             ['F', 'G', 'H', 'I', 'J'],
//             ['K', 'L', 'M', 'N', 'O'],
//             ['P', 'Q', 'R', 'S', 'T'],
//             ['U', 'V', 'W', 'X', 'Y'],
//             ['Z', '0', '1', '2', '3'],
//             ['4', '5', '6', '7', '8'],
//             ['9', '@', '#', '_', '-'],
//           ],
//           onPressButton: (value) async{
//
//
//             // Go back to the previous screen
//             // showDialog(
//             //   context: context,
//             //   builder: (BuildContext context) {
//             //     return AlertDialog(
//             //       title: Text('Key Pressed'),
//             //       content: Text('You pressed the key: $value'),
//             //       actions: [
//             //         TextButton(
//             //           child: Text('OK'),
//             //           onPressed: () {
//             //             Navigator.of(context).pop();
//             //           },
//             //         ),
//             //       ],
//             //     );
//             //   },
//             // );
//           },
//         ),
//       ),
//     );
//   }
// }
