// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_border/progress_border.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Models/signinwithgoogle_model.dart';
import '../../Provider_Data/dark_mode.dart';
import '../../Provider_Data/handle_ai.dart';
import '../../Utilities/app_color.dart';
import '../../Utilities/constants.dart';
import 'detail_image_generated_view.dart';

class ImageGeneratorScreen extends StatefulWidget {
  final String imgUrl;
  String prompt;
  String category;
  String? type;

  ImageGeneratorScreen(
      {super.key,
        required this.imgUrl,
        required this.prompt,
        required this.category,
        this.type});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  TextEditingController promptController = TextEditingController();

  bool load = false;

  String checkVariation = "";
  String checkEdit = "";

  String? selectedImage;

  void switchImage(newImage) {
    setState(() {
      selectedImage = newImage;
    });
  }

  var docdata;
  UserDetails? data3;

  @override
  void initState() {
    promptController.text = widget.prompt;
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user){
      getUserDetails(user?.email.toString() ?? '');
      print('data show');
    });
  }
  Future<void> getUserDetails(String email) async{
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(email);
    print("cwwhwsds$userDocRef");
    final DocumentSnapshot documentSnapshot = await userDocRef.get();
    print("bsxhjabs$documentSnapshot");
    if (documentSnapshot.exists) {
      docdata = documentSnapshot.data() as Map<String, dynamic>;
      // data2 = UserDetails.fromJson(data!);
      data3 = UserDetails.fromJson(docdata ?? {});
      // count = data3!.count!;
      // print('here is updated count ${count}');
      setState(() {});
    }
  }

  Future<void> downloadAssets(String assetPath) async {
    setState(() {
      load = true;
    });
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final result =
      await ImageGallerySaverPlus.saveImage(Uint8List.fromList(bytes));

      if (result != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Image saved'),
            backgroundColor: ColorX.pinkX,
          ),
        );
        setState(() {
          load = false;
        });
        print("image-->${assetPath.toString()}");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailImageGeneratedScreen(
              // image: result,
              // selectedImage: selectedImage,
              type: 'ASSETS',
              savedImagePath: assetPath,
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Failed to save the image to the gallery.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      setState(() {
        load = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final themProvider = Provider.of<AppStateNotifier>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
        themProvider.isDarkModeOn ? ColorX.blackX : const Color(0xffebebeb),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(9.h),
          child: Container(
            decoration: BoxDecoration(
              color: themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,
              border: Border(
                top: BorderSide(
                  width: 10,
                  color:
                  themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,
                ),
                bottom: BorderSide(
                  width: 10,
                  color:
                  themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 5.w,
                ),
                themProvider.isDarkModeOn
                    ? Image.asset(
                  'image/Group 37079.png',
                  height: 4.h,
                )
                    : Image.asset(
                  'image/Group 37081.png',
                  height: 4.h,
                ),
              ],
            ),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => HandleAi(),
          child: Consumer<HandleAi>(
            builder: (context, model, child) {
              // if(model.type =="EDIT"){
              //   model.variationList.add(model.editImage[0]);
              // }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Result",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: themProvider.isDarkModeOn
                                    ? ColorX.whiteX
                                    : ColorX.blackX),
                          ),
                          checkVariation == "variation"
                              ? InkWell(
                            onTap: () {
                              // setState(() {
                              //   load = true;
                              // });
                              if (kDebugMode) {
                                print('hit variation');
                              }
                              downloadImage(selectedImage.toString());
                              print("kd--->>>${selectedImage.toString()}");
                            },
                            child: Container(
                              height: 41,
                              width: 144,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themProvider.isDarkModeOn
                                    ? const Color.fromRGBO(234, 72, 220, 1,)
                                    : const Color.fromRGBO(234, 72, 220, 1,),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: load == true
                                  ? SizedBox(
                                height: 1.h,
                                width: 2.w,
                                child: const Center(
                                  child:
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Center(
                                          child:  Text(
                                            "Download",
                                            style: GoogleFonts
                                                .lexendDeca(
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 15,
                                              color: themProvider
                                                  .isDarkModeOn
                                                  ? Colors.white
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .file_download_outlined,
                                          color: themProvider
                                              .isDarkModeOn
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : checkEdit == "Edit"
                              ? InkWell(
                            onTap: () {
                              print('hit edit');
                              downloadImage(model.editImage[0].toString());
                            },
                            child: Container(
                              height: 41,
                              width: 144,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themProvider.isDarkModeOn
                                    ? const Color.fromRGBO(234, 72, 220, 1,)
                                    : const Color.fromRGBO(234, 72, 220, 1,),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: load == true
                                  ? SizedBox(
                                height: 1.h,
                                width: 2.w,
                                child: const Center(
                                  child:
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Download",
                                          style: GoogleFonts
                                              .lexendDeca(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 15,
                                            color: themProvider
                                                .isDarkModeOn
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .file_download_outlined,
                                          color: themProvider
                                              .isDarkModeOn
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : InkWell(
                            onTap: () {
                              if (kDebugMode) {
                                print('hit imgurl');
                              }
                              widget.type == "TRY"
                                  ? downloadAssets(widget.imgUrl)
                                  : downloadImage(widget.imgUrl);
                            },
                            child: Container(
                              height: 41,
                              width: 144,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themProvider.isDarkModeOn
                                    ? const Color.fromRGBO(234, 72, 220, 1,)
                                    : const Color.fromRGBO(234, 72, 220, 1,),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: load == true
                                  ?
                              SizedBox(
                                  height: 1.h,
                                  width: 2.w,
                                  child:const Center(
                                    child:
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Download",
                                          style: GoogleFonts
                                              .lexendDeca(
                                            fontWeight:
                                            FontWeight.w600,
                                            fontSize: 15,
                                            color: themProvider
                                                .isDarkModeOn
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .file_download_outlined,
                                          color: themProvider
                                              .isDarkModeOn
                                              ? Colors.white
                                              : Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // :Container()
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      checkVariation == "variation"
                          ? selectedImage == null
                          ? const Text('')
                          : Container(
                        decoration: BoxDecoration(
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3.w),
                          child: CachedNetworkImage(
                            imageUrl: selectedImage.toString(),
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                Container(
                                  decoration: BoxDecoration(
                                    border: ProgressBorder.all(
                                      color: ColorX.pinkX,
                                      width: 4,
                                      progress: downloadProgress.progress,
                                    ),
                                  ),
                                ),
                            height: 2 * (screenWidth / 2.5),
                            width: screenWidth,
                          ),
                        ),
                      )
                          : model.type == 'EDIT' || checkEdit == "Edit"
                          ? model.editImage.isEmpty
                          ? Container(
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: ColorX.blackX),
                          borderRadius:
                          BorderRadius.circular(3.w),
                        ),
                        height: 2 * (screenWidth / 2.5),
                        width: screenWidth,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ColorX.pinkX,
                          ),
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(3.w),
                          child: CachedNetworkImage(
                            imageUrl:
                            model.editImage[0].toString(),
                            fit: BoxFit.fill,
                            progressIndicatorBuilder: (context,
                                url, downloadProgress) =>
                                Container(
                                  decoration: BoxDecoration(
                                    border: ProgressBorder.all(
                                      color: ColorX.pinkX,
                                      width: 4,
                                      progress:
                                      downloadProgress.progress,
                                    ),
                                  ),
                                ),
                            height: 2 * (screenWidth / 2.5),
                            width: screenWidth,
                          ),
                        ),
                      )
                          : widget.type == "TRY"
                          ? Container(
                        decoration: BoxDecoration(
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(3.w),
                          child: Image.asset(widget.imgUrl),
                        ),
                      )
                          : widget.type == "GENERATE"
                          ? Container(
                        decoration: BoxDecoration(
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(3.w),
                          child: CachedNetworkImage(
                            imageUrl:
                            widget.imgUrl.toString(),
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url,
                                downloadProgress) =>
                                Container(
                                  decoration: BoxDecoration(
                                    border: ProgressBorder.all(
                                      color: ColorX.whiteX,
                                      width: 4,
                                      progress: downloadProgress
                                          .progress,
                                    ),
                                  ),
                                ),
                            height: 2 * (screenWidth / 2.5),
                            width: screenWidth,
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(
                        height: 1.h,
                      ),
                      model.variationList.isEmpty
                          ? const Text('')
                          : SizedBox(
                        height: 10.h,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: model.variationList.length,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.type == "";
                                          // handleEdit = false;
                                          // checkEdit = "";
                                          checkVariation = "variation";
                                          switchImage(model
                                              .variationList[index]
                                              .toString());
                                        });
                                        print('object');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        child: Container(
                                          height: 10.h,
                                          width: 22.w,
                                          decoration: BoxDecoration(
                                              color: themProvider.isDarkModeOn
                                                  ? ColorX.blackX
                                                  : ColorX.whiteX,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: themProvider.isDarkModeOn
                                                      ? ColorX.whiteX
                                                      : ColorX.blackX)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: model.variationList[index],
                                              fit: BoxFit.fill,
                                              progressIndicatorBuilder:
                                                  (context, url, downloadProgress) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: ProgressBorder.all(
                                                        color: ColorX.pinkX,
                                                        width: 4,
                                                        progress: downloadProgress.progress,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      checkEdit = "";
                                      checkVariation = "variation";
                                      switchImage(model
                                          .variationList[index]
                                          .toString());
                                    });
                                    print('object');
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.w),
                                    child: Container(
                                      height: 9.2.h,
                                      width: 22.w,
                                      decoration: BoxDecoration(
                                        color: themProvider.isDarkModeOn
                                            ? ColorX.blackX
                                            : ColorX.whiteX,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(3.w),
                                          child: CachedNetworkImage(
                                            imageUrl: model
                                                .variationList[index],
                                            fit: BoxFit.fill,
                                            progressIndicatorBuilder:
                                                (context, url,
                                                downloadProgress) =>
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border:
                                                    ProgressBorder.all(
                                                      color: ColorX.pinkX,
                                                      width: 4,
                                                      progress:
                                                      downloadProgress
                                                          .progress,
                                                    ),
                                                  ),
                                                ),
                                          )),
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 0,
                            child: InkWell(
                              onTap: () async {
                                if (model.variationList.length == 2) {
                                  onVariationTap(
                                      context,
                                      'In the beta version ,only 2 \nvariation is allowed!',
                                      themProvider
                                  );
                                } else {
                                  model.type = "VARIATION";
                                  Timer(
                                      const Duration(milliseconds: 500), () {
                                    int limit = data3!.plan=="nothing"?3 :data3!.plan=="Bronze"?100:data3!.plan=="Silver"?220:500;

                                    if(data3!.count! < limit){
                                      model.getImagePost("${promptController.text} ${model.variationList.isEmpty ? "modern" :"New modern"},", widget.category, context, data3!.count! );
                                    }else{
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text('User has not access to regenerate the Image, Please upgrade your plan'),
                                          backgroundColor: ColorX.pinkX,
                                        ),
                                      );
                                    }
                                  });
                                  // model.getImagePost(
                                  //     "${promptController.text} ${model.variationList.isEmpty ? "modern" : "New modern"},",
                                  //     widget.category,context);
                                }
                              },
                              child: Container(
                                height: 7.h,
                                width: 145,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                    const Color.fromRGBO(234, 72, 220, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(50.w),
                                ),
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      model.isLoading
                                          ? SizedBox(
                                        height: 4.h,
                                        width: 8.w,
                                        child:
                                        const CircularProgressIndicator(
                                          color: ColorX.pinkX,
                                        ),
                                      )
                                          : Image.asset(
                                        "image/refresh.png",
                                        height: 5.h,
                                        width: 5.w,
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        "Variations",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromRGBO(234, 72, 220, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                FirebaseAuth.instance.authStateChanges().listen((User? user){
                                  getUserDetails(user?.email.toString() ?? '');
                                });
                                // print('length is --->>${model.checkEdit}');
                                // print('length is --->>${model.editImage.length}');
                                // if(){
                                //   onVariationTap(context);
                                // }else{
                                setState(() {
                                  model.checkEdit == true ? Container() : checkEdit = "Edit";
                                  model.checkEdit == true ? Container() : checkVariation = "";
                                  // variationList.clear();
                                });
                                model.checkEdit == true ? Container() : model.type = "EDIT";
                                // model.checkEdit == true ? Container():
                                // ? onVariationTap(
                                //     context,
                                //     'In the beta version ,only 1 \n generate option is allowed!',
                                //     themProvider)
                                // :
                                // model.getImagePost("${promptController.text} modern", widget.category, context);
                                // model.checkEdit == true
                                //     ? Container()
                                //     : model.variationList.clear();

                                Timer(const Duration(milliseconds: 100), () {
                                  int limit = data3!.plan=="nothing"?3 :data3!.plan=="Bronze"?100:data3!.plan=="Silver"?220:500;

                                  data3!.count! < limit
                                      ?
                                  model.getImagePost(
                                      "${promptController.text}modern",
                                      widget.category, context, data3!.count!)
                                      : scaffoldMessenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Your free quota has been completed, Please upgrade your plan.',
                                      ),
                                      backgroundColor: ColorX.pinkX,
                                    ),
                                  );
                                  print("latest count:===${data3!.count!}");
                                });

                                model.checkEdit == true ? Container(): model.variationList.clear();

                              },
                              child: Container(
                                height: 7.h,
                                width: 186,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(234, 72, 220, 1),
                                  borderRadius: BorderRadius.circular(50.w),
                                ),
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      model.isLoadingEdit
                                          ? SizedBox(
                                        height: 4.h,
                                        width: 8.w,
                                        child:
                                        const Center(
                                          child: CircularProgressIndicator(
                                            color: ColorX.whiteX,
                                          ),
                                        ),
                                      )
                                          :Row(
                                        children: [
                                          const Icon(
                                            Icons.add,
                                            color: ColorX.whiteX,
                                          ),
                                          SizedBox(
                                            width: 1.w,
                                          ),
                                          Text(
                                            "Generate More",
                                            style: stylePoppins4(
                                                ColorX.whiteX
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: themProvider.isDarkModeOn
                                            ? ColorX.whiteX
                                            : ColorX.blackX,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  child: Icon(
                                    color: themProvider.isDarkModeOn
                                        ? ColorX.whiteX
                                        : ColorX.blackX,
                                    Icons.edit_outlined,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Edit Idea",
                              style: stylePoppins(themProvider.isDarkModeOn
                                  ? ColorX.whiteX
                                  : ColorX.blackX),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                          height: 14.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: themProvider.isDarkModeOn
                                ? const Color.fromRGBO(238, 238, 238, 0.4)
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: themProvider.isDarkModeOn
                                    ? const Color.fromRGBO(255, 255, 255, 0.2)
                                    : const Color.fromRGBO(0, 0, 0, 0.2)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              controller: promptController,
                              cursorColor: Colors.pinkAccent,
                              maxLines: 10,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.only(left: 4.w, top: 1.h),
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText:
                                  "Lorem ipsum dolor sit amet, consecteturadipiscing elite, sed do eiusmod tempor inc-did labore et dolore magna aliqua. Ut enimad",
                                  hintStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: ColorX.greyX)),
                              onChanged: (val) {},
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadImage(String imageUrl) async {
    setState(() {
      load = true;
    });
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _requestPermission(Permission.storage);
      final tempDirectory = await getTemporaryDirectory();
      const fileName = 'artifect.jpg';
      final filePath = '${tempDirectory.path}/$fileName';
      await Dio().download(imageUrl, filePath);
      // final savedFile = await GallerySaver.saveImage(filePath);
      final appDir = await getApplicationDocumentsDirectory();
      final gallerySubdirectory = Directory('${appDir.path}/Artifect');
      print('sun directory is $gallerySubdirectory');
      gallerySubdirectory.createSync(recursive: true);
      final newFilePath = '${gallerySubdirectory.path}/$fileName';
      print('newFilePath directory is $newFilePath');
      File(filePath).copySync(newFilePath);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Image saved'),
          backgroundColor: ColorX.pinkX,
        ),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailImageGeneratedScreen(
          image: imageUrl,
        ),
      ));
      setState(() {
        load = false;
      });
    } catch (e) {
      setState(() {
        load = false;
      });
      print('Error: $e');
    }
  }

//   Future<void> downloadImage(imageUrl) async {
//     setState(() {
//       load = true;
//     });
//     http.Response response = await http.get(Uri.parse(imageUrl));
//     final scaffoldMessenger = ScaffoldMessenger.of(context);
// try {
//   if (response.statusCode == 200) {
//     Unit8List bytes = response.bodyBytes;
//     final result = await ImageGallerySaver.saveImage(bytes);
//     print(result);
//     scaffoldMessenger.showSnackBar(
//       const SnackBar(
//         content: Text('Image saved'),
//         backgroundColor: ColorX.pinkX,
//       ),
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             DetailImageGeneratedScreen(
//               imageUrl: imageUrl,
//               // selectedImage: selectedImage,
//             ),
//       ),
//     );
//     print("object-->...---->>$imageUrl");
//
//     setState(() {
//       load = false;
//     });
//   } else {
//     setState(() {
//       load = false;
//     });
//   }
// }catch (e) {
//   setState(() {
//     load = false;
//   });
//   print('Error: $e');
//
//     }
//   }


}
