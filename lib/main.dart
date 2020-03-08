import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:edge_detection/edge_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:bill_detector/Pages/final.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dio/adapter.dart';
//import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:bill_detector/Pages/api.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


void main() => runApp(MaterialApp(
  routes: {
    '/home': (context) => Home(),
    '/final': (context) => Final(),
  },
  home: Home(),
  debugShowCheckedModeBanner: false,
));


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url;
  File __selectedFile;
  //Future<File> imageFile;
  File imageFile;
  File cropped;
  var result;
  //String data='';
  var data = new List<String>();


  pickImageFromGallery(ImageSource source) async{
    /*setState(() {
      imageFile= ImagePicker.pickImage(source: source);
    });*/
    imageFile= await ImagePicker.pickImage(source: source,);

    /*result=await FlutterImageCompress.compressAndGetFile(
        imageFile.path, imageFile.path,

    );*/

    if(imageFile!=null){
      cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        /*aspectRatio: CropAspectRatio(
            ratioX:2,ratioY:1),*/

        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: 'cropper',
          backgroundColor: Colors.white,
          lockAspectRatio: false,
        ),
      );
      print(cropped.path);
      Upload_img instance = Upload_img();
      await instance.Upload(cropped);
      url = instance.returnurl;
      print('back');
      print(url);
      print(imageFile.path);
      print(cropped.path);
      this.setState(() {
        __selectedFile=cropped;
      });
    }
  }



  Future readText() async{
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(__selectedFile);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    /*for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }*/
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {

        data.add(line.text);

        //print(line.text);

      }
    }
    Navigator.pushReplacementNamed(context, '/final',arguments: {'result':data,'file':__selectedFile} );
    //print(data);
  }


  Widget showImage() {
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
      return Image.network(
        url,
        //width: width*0.5,
        //height: height*0.4,
        fit: BoxFit.cover,
      );
    } else{
      return Container(
        padding: EdgeInsets.fromLTRB(0, height*0.2, 0, 0),
        child: const Text(
          'No Image selected',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, width: 392, height: 816, allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Detector',textAlign:TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children :<Widget>[
            Container(
              height: height*0.5,
              width: width*0.8,
              child: ListView(
                shrinkWrap: true,
                children : <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(width*0.03,0,width*0.03,height*0.01),
                    child: showImage(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height*0.03,
            ),
            /*Container(
              height: height*0.6,
              child: ClipPath(
                child: Image.network('https://templates.invoicehome.com/invoice-template-us-neat-750px.png'),
                clipper: new MyClipper(),
              ),
            ),*/
            RaisedButton(
              color: Colors.blue[400],
              padding: EdgeInsets.fromLTRB(width*0.18, height*0.02, width*0.18, height*0.02),
              onPressed: (){
                pickImageFromGallery(ImageSource.gallery );
                //Navigator.pushNamed(context, '/final');
                /*String imagePath = await EdgeDetection.detectEdge;
                print(imagePath);*/

              },
              child: Text('Select Image',
                style: TextStyle(
                  fontSize: height*0.04,
                ),
              ),
            ),
            //SizedBox(height: height*0.05,),
            /*Container(
              //padding: EdgeInsets.fromLTRB(width*0.02, 0, width*0.02, height*0.04),
              width: width*0.9,
              child: SliderButton(
                action: () {
                  pickImageFromGallery(ImageSource.gallery);
                },
                label: Text(
                  "Slide to select image",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                icon: Icon(
                  Icons.add_a_photo,
                  size: width*0.07,
                ),
                backgroundColor: Colors.blue,
                buttonColor: Colors.yellow,
                alignLabel: Alignment.center,
              ),
            ),*/
            SizedBox(
              height: height*0.03,
            ),
            /*Container(
              //padding: EdgeInsets.fromLTRB(width*0.02, 0, width*0.02, height*0.04),
              width: width*0.9,
              child: SliderButton(
                action: () {
                  readText();
                },
                label: Text(
                  "Slide to extract text",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                icon: Icon(
                  Icons.text_fields,
                  size: width*0.07,
                ),
                backgroundColor: Colors.blue,
                buttonColor: Colors.yellow,
                alignLabel: Alignment.center,
              ),
            ),*/
            RaisedButton(
              color: Colors.blue[400],
              padding: EdgeInsets.fromLTRB(width*0.2, height*0.02, width*0.2, height*0.02),
              onPressed: (){
                readText();
                //Navigator.pushNamed(context, '/final');
                /*String imagePath = await EdgeDetection.detectEdge;
                print(imagePath);*/

              },
              child: Text('Extract Text',
                style: TextStyle(
                  fontSize: height*0.04,),
              ),
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(width*0.02, 0, width*0.02, height*0.04),
        child: SliderButton(
          action: () {
            ///Do something here
            pickImageFromGallery(ImageSource.gallery);
            Navigator.pop(context);
          },
          label: Text(
            "Slide to select image",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17),
          ),
          icon: Icon(
            Icons.add_a_photo,
            size: width*0.07,
          ),
          backgroundColor: Colors.blue,
          buttonColor: Colors.yellow,
          alignLabel: Alignment.center,
        ),
      ),*/
    );
  }
}

/*class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path=new Path();
    path.lineTo(size.width*0.2, 0);
    path.lineTo(size.width*0.2, size.height);
    path.lineTo(size.width*0.8, size.height);
    path.lineTo(size.width*0.8, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}*/