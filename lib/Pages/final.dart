import 'package:flutter/material.dart';
import 'package:bill_detector/main.dart';


class Final extends StatefulWidget {
  @override
  _FinalState createState() => _FinalState();
}
Map data={};
class _FinalState extends State<Final> {


  Widget showImage(__selectedFile) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /*return FutureBuilder(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot){
        if(snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null){
          return Image.file(
            snapshot.data,
            width: width*0.5,
            height: height*0.4,
          );
        } else if(snapshot.error != null){
          return const Text(
            'Error picking Image',
            textAlign: TextAlign.center,
          );
        } else{
          return const Text(
            'No Image selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );*/
    if(__selectedFile != null){
      return Image.file(
        __selectedFile,
        //width: width*0.5,
        //height: height*0.4,
        fit: BoxFit.cover,

      );
    } else{
      return const Text(
        'No Image selected',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    data=ModalRoute.of(context).settings.arguments;
    print(data);
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
        child: ListView(
          shrinkWrap: true,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(width*0.03,0,0,0),
                child: Text('Edited Image :',
                  style: TextStyle(
                    fontSize: height*0.05,
                    fontStyle: FontStyle.italic,
                  ),)
            ),
            Container(
              height: height*0.5,
              width: width*0.8,
              child: ListView(
                shrinkWrap: true,
                children : <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(width*0.03,height*0.01,width*0.03,height*0.01),
                    child: showImage(data['file']),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width*0.03,0,0,0),
              child: Text('Text Detected :',
              style: TextStyle(
                fontSize: height*0.05,
                fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(width*0.03,0,width*0.03,height*0.05),
              child: Container(
                height: height*0.4,
                width:width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.white, Colors.grey[500]]),
                ),
                child: ListView.builder(
                  //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemExtent: height*0.05,
                  itemCount: data['result'].length,
                  itemBuilder: (context,index){
                    var mylist = data['result'];
                    return ListTile(
                      title: Text(
                        mylist[index],
                        style: TextStyle(
                          fontSize: height*0.022,
                        ),
                      ),
                    );
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
