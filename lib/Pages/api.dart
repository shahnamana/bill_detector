import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'dart:io';

class Upload_img{
  String returnurl;
  Future<void> Upload(File imageFile) async {
    //print("Inside ");
    String url;
    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('http://172.16.100.96:8000/images/getimage/');

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send().then((response) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        Map data=json.decode(value);
        returnurl=data['url'];
        print(returnurl);
        image.img=returnurl;
        //returnurl =url;
      }
      );
    });
    //print(response.statusCode);

    //return url;
  }
}

class image{
  static var img;
}