import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:edge_detection/edge_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart';
import 'package:bill_detector/Pages/final.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/home': (context) => Home(),
    '/final': (context) => Final(),
  },
  home: Home(),
));


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  File __selectedFile;
  //Future<File> imageFile;
  File imageFile;
  File cropped;
  pickImageFromGallery(ImageSource source) async{
    /*setState(() {
      imageFile= ImagePicker.pickImage(source: source);
    });*/
    imageFile= await ImagePicker.pickImage(source: source);

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

          print(line.text);

      }
    }
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
      return Image.file(
        __selectedFile,
        width: width*0.5,
        height: height*0.4,
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
            showImage(),
            RaisedButton(
              onPressed: (){
                pickImageFromGallery(ImageSource.gallery );
                //Navigator.pushNamed(context, '/final');
                /*String imagePath = await EdgeDetection.detectEdge;
                print(imagePath);*/

              },
              child: Text('Select Image'),
            ),
            SizedBox(height: height*0.05,),
            RaisedButton(
              onPressed: (){
                readText();
                //Navigator.pushNamed(context, '/final');
                /*String imagePath = await EdgeDetection.detectEdge;
                print(imagePath);*/

              },
              child: Text('Extract Text'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }
}

