import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utilities/app_color.dart';
import '../View/ImageGeneratorAI/image_generated_view.dart';

class HandleAi extends ChangeNotifier{
  bool isLoading = false;
  bool isLoadingEdit = false;
  // var apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjRjYWJkMzIzN2U0M2U1ZDFkODEzMjYxOTg2Y2NlY2VjIiwiY3JlYXRlZF9hdCI6IjIwMjMtMTEtMjJUMTE6MDU6MTcuNTI3NTA0In0.MLUr-ygN4ucnHA_lIab_GgiiKwIMjIUj7GKbP6cbMSY";
  // var apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjRjYWJkMzIzN2U0M2U1ZDFkODEzMjYxOTg2Y2NlY2VjIiwiY3JlYXRlZF9hdCI6IjIwMjMtMTEtMjJUMTE6MDU6MTcuNTI3NTA0In0.MLUr-ygN4ucnHA_lIab_GgiiKwIMjIUj7GKbP6cbMSY";
  var apiKey ="";
  // var apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjRjYWJkMzIzN2U0M2U1ZDFkODEzMjYxOTg2Y2NlY2VjIiwiY3JlYXRlZF9hdCI6IjIwMjMtMTAtMThUMDk6MzA6MzUuMzk0MzE0In0.wsYmRuJ9WyX7vNxRLciv6ZRldHoeommxwqug1VvDR7g";
  // var apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IjFlYTgyODFhYjk4YzZjMDMxYzY0Y2QxNTQ0YjkyZTk4IiwiY3JlYXRlZF9hdCI6IjIwMjMtMTAtMTNUMDU6Mzk6NDYuODI1Mzg5In0.zTRtxk9zLX4-rSGYeojYtECaVp-CAa-elzXEkYKfnAQ";
  bool checkEdit = false;
  final List _variationList = [];
  List get  variationList  => _variationList;
  final List _editImage = [];
  List get  editImage  => _editImage;
  String? type;

  // int count = 0;


  getVariation(value){
    variationList.add(value);
    notifyListeners();
  }

  getEditImage(value){

    editImage.add(value.toString());
    print('length is0 ${editImage.length}');
    if(editImage.length > 3){
      print('length is1 ${editImage.length}');
      checkEdit = true;
      notifyListeners();
    }else{
      editImage.add(value);
      checkEdit = true;
      print('length is2 ${editImage.length}');
      notifyListeners();
    }
  }

  getType(String value){
    type = value.toString();
    notifyListeners();
  }


  Future<void> getImagePost(String text,String category,BuildContext context, int count) async{
    type =="EDIT"? isLoadingEdit = true :isLoading = true;
    notifyListeners();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      print('here is coming from genrate more');
      const String apiUrl =
          "https://api.stability.ai/v1/generation/stable-diffusion-v1-5/text-to-image";
          // 'https://monsterapi.ai/backend/v2playground/generate/processId';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };
      Map<String, dynamic> requestData = {
        "model": "sdxl-base",
        "data": {
          "prompt":"${text.toString()},${category.toString()}",
          // "negprompt": category,
          "samples": 1,
          // "steps": 50,
          // "aspect_ratio": "square",
          // "guidance_scale": 12.5,
          // "seed": 2321,
        },
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // print('url is ${jsonData['data']}');
        var uri = jsonData['data']['status_url'].toString();
        print("new count: $count");
        await monsterApiGet(uri, text, category, context,count);
      }
    }catch (e){
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Billing exceed"),
          backgroundColor: ColorX.pinkX,
        ),
      );
      print(e);
    }finally{
      // isLoading = false;
      type =="EDIT"?isLoadingEdit = false : isLoading = false;
      notifyListeners();
    }
  }

  Future<void> monsterApiGet(String url,String promptController, String category, BuildContext context, int count)async{
    // final scaffoldMessenger = ScaffoldMessenger.of(context);

    print("new count next: $count");

    try {
      while (type =="EDIT"? isLoadingEdit : isLoading){
        var uri = Uri.parse(url);
        Map<String, dynamic> headers = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $apiKey',
        };
        var response = await Dio().get(uri.toString(), options: Options(headers: headers));
        log(response.toString());
        if (response.data['status'].toString() == "IN_PROGRESS") {
          // Continue polling
        }else if (response.data['status'].toString() == "COMPLETED") {

          updateUserCount(count);

          var image = response.data['result']['output'][0];

          // var image;
          // if(count <= 3){
          //   image = response.data['result']['output'][0];
          //   count+1;
          // }else{
          //   scaffoldMessenger.showSnackBar(
          //     const SnackBar(
          //       content: Text('User has not access to regenerate the Image'),
          //       backgroundColor: ColorX.pinkX,
          //     ),
          //   );
          // }

          if(kDebugMode){
            print("ddfkbwcbck=====${image.toString()}");
          }

          type == "VARIATION" ? getVariation(image.toString()) : Container();
          type == "EDIT" ? getEditImage(image.toString()) : Container();
          // type == "EDIT"? :Container();
          if (context.mounted){
            type == "VARIATION" || type == "EDIT" ? Container(): Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) => ImageGeneratorScreen(
                  prompt: promptController,
                  category: category,
                  imgUrl: image.toString(),
                  type: "GENERATE",
                ),
              ),

            );
          }
          break; // Exit the loop
        }else{
          // scaffoldMessenger.showSnackBar(const SnackBar(
          //   content: Text("Failed to get the image, please try again"),
          //   backgroundColor: ColorX.pinkX,
          // ));
          break; // Exit the loop
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    }catch (e){
      if (kDebugMode){
        print(e);
      }
    }finally {
      type =="EDIT" ? isLoadingEdit = false :isLoading = false;
      notifyListeners();
    }
  }


  Future<void> updateUserCount(count) async{
    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(user?.email);
      int c = count + 1;
      await userDocRef.update({'count': c,});
    });
    notifyListeners();
  }

}
