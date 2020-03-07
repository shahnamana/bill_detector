import 'package:flutter/material.dart';
import 'package:bill_detector/main.dart';


class Final extends StatefulWidget {
  @override
  _FinalState createState() => _FinalState();
}

class _FinalState extends State<Final> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
           Navigator.pushNamed(context, '/home');
          },
        ),
        title: Text(
          'Final Output'
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
