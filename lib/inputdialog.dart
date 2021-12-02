import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'manger.dart';

class AlertDialogScreen extends StatefulWidget {
  const AlertDialogScreen({Key? key}) : super(key: key);

  @override
  _AlertDialogScreenState createState() => _AlertDialogScreenState();
}

class _AlertDialogScreenState extends State<AlertDialogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: const Text('Login Now'),
          onTap: () => _displayTextInputDialog(context),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String id = '';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter ID login'),
            content: TextField(
              onChanged: (value) {
                setState(() async {
                  print("value value value $value");
                  id = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "ID number"),
            ),
            actions: <Widget>[
              Container(
                color: Colors.green,
                child: TextButton(
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    // setState(() async {
                    await AppRepo.getInstance().setId(int.parse(id));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(id: int.parse(id))));
                    // codeDialog = valueText;
                    // Navigator.pop(context);
                    // });
                  },
                ),
              ),
              Container(
                color: Colors.red,
                child: TextButton(
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            ],
          );
        });
  }
}
