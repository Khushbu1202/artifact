// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../Models/categorys_model.dart';
import '../../../../Models/signinwithgoogle_model.dart';
import '../../../../Provider_Data/dark_mode.dart';
import '../../../../Provider_Data/handle_ai.dart';
import '../../../../Utilities/app_color.dart';
import '../../../../Utilities/common_grid.dart';
import '../../../../Utilities/constants.dart';
import '../../../../Utilities/error_controllers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  String selectedItem = 'No Style';
  CategoryModel? category;

  TextEditingController promptController = TextEditingController();
  dynamic error;

  bool check = true;
  bool isLoading = false;

  List<String> data = [
    '3d Model',
    'Realism',
    'Digital Art',
    'Anime',
    'Fantasy Art',
    'Line Art',
    'Water Color',
    'Lowpoly',
    'Comic'
  ];


  var docdata;
  UserDetails? data3;

  @override
  void initState() {
    checkForUpdate();
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      getUserDetails(user?.email.toString() ?? '');
      print('data show');
    });
  }
  Future<void> getUserDetails(String email) async {
    final DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('users').doc(email);
    print("sdkjcbcbh$userDocRef");
    final DocumentSnapshot documentSnapshot = await userDocRef.get();
    print("bsxhjabs${documentSnapshot}");
    setState(() {
      if (documentSnapshot.exists) {
        docdata = documentSnapshot.data() as Map<String, dynamic>;
        // data2 = UserDetails.fromJson(data!);
        data3 = UserDetails.fromJson(docdata ?? {});

        // count = data3!.count!;
        print('here is count ${data3!.count!}');
      }
    });
  }

  // bool site = false;
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final themProvider = Provider.of<AppStateNotifier>(context);
    return WillPopScope(
      onWillPop: () => onBackButtonTap(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: themProvider.isDarkModeOn
              ? ColorX.blackX
              : Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(9.h),
            child: Container(
              decoration: BoxDecoration(
                color:
                themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,
                border:  Border(
                  top: BorderSide(width: 10, color: themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,),
                  bottom: BorderSide(width: 10, color: themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,),
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
            child: Consumer<HandleAi>(builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Enter Prompt",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: themProvider.isDarkModeOn
                                ? ColorX.whiteX
                                : ColorX.blackX,
                            height: 3,
                          )),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : const Color.fromRGBO(0, 0, 0, 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: themProvider.isDarkModeOn
                                ? ColorX.whiteX
                                : const Color.fromRGBO(0, 0, 0, 2),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            controller: promptController,
                            cursorColor: Colors.pinkAccent,
                            maxLines: 10,
                            onChanged: (value) {
                              setState(() {
                                error = value;
                              });
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 3.w, top: 1.h),
                                // enabled: true,
                                // filled: true,
                                counterText: "",
                                border: InputBorder.none,
                                hintText: "Enter Prompt !!",
                                hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: themProvider.isDarkModeOn
                                      ? ColorX.whiteX
                                      : ColorX.blackX,
                                )),
                          ),
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (error == "")
                      Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: const ErrorControllers(
                          error: "Please enter prompt",
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Select Style",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: themProvider.isDarkModeOn
                              ? ColorX.whiteX
                              : const Color.fromRGBO(0, 0, 0, 1),
                          height: 3,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showAlert(context, themProvider);
                      },
                      child: Container(
                        height: 6.5.h,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        decoration: BoxDecoration(
                            color: themProvider.isDarkModeOn
                                ? ColorX.blackX
                                : const Color.fromRGBO(0, 0, 0, 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:  themProvider.isDarkModeOn
                                ? ColorX.whiteX
                                : const Color.fromRGBO(0, 0, 0, 2), width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(selectedItem.toString()),
                            ),
                            Image.asset(
                              'image/downarrow.png',
                              height: 1.4.h,
                              width: 12.w,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    if (check == false)
                      Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: const ErrorControllers(
                            error: "Please select category"),
                      ),
                    SizedBox(
                      height: 5.h,
                    ),
                    InkWell(
                      onTap: () async {
                        FirebaseAuth.instance
                            .authStateChanges()
                            .listen((User? user) {
                          getUserDetails(user?.email.toString() ?? '');

                          print('data show');

                          if (promptController.text.isEmpty ||
                              check == false) {
                            setState(() {
                              error = promptController.text;
                              check = false;
                              print(
                                  'a boy reading a book and using a laptop ,Line Art');
                            });
                          } else {
                            print('api');
                            print(
                                'obj${promptController.text + selectedItem.toString()}');
                            // model.type = "";
                            // model.getImagePost(promptController.text, selectedItem.toString(), context);
                            // FirebaseAuth.instance.authStateChanges().listen((User? user){
                            //   getUserDetails(user?.email.toString() ?? '');
                            //   print('data show');
                            // });
                            Timer(const Duration(milliseconds: 1000), () {
                              int limit = data3!.plan=="nothing"?3 :data3!.plan=="Bronze"?100:data3!.plan=="Silver"?220:500;
                              if (data3!.count! < limit) {
                                setState(() {
                                  model.getImagePost(
                                    promptController.text,
                                    selectedItem.toString(),
                                    context,
                                    data3!.count!,
                                  );
                                });
                                if (kDebugMode) {
                                  print("sdncxkabsj${data3!.count}");
                                }
                              }else{
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Your free quota has been completed, Please upgrade your plan.',
                                    ),
                                    backgroundColor: ColorX.pinkX,
                                  ),
                                );
                              }
                            });
                          }

                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 17),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromRGBO(234, 72, 220, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1.8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 11,
                                child: model.isLoading
                                    ? const Center(
                                    child: CircularProgressIndicator(
                                      color: ColorX.whiteX,
                                    ))
                                    : Text(
                                  'Generate',
                                  textAlign: TextAlign.center,
                                  style: stylePoppins(
                                      themProvider.isDarkModeOn
                                          ? ColorX.whiteX
                                          : ColorX.whiteX),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  // width: double.infinity,
                                  child: Image.asset(
                                    'image/Star 7.png',
                                    height: 3.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 17, vertical: 2.h),
                      child: Text(
                        "Ideas!",
                        style: stylePoppins(themProvider.isDarkModeOn
                            ? ColorX.whiteX
                            : ColorX.blackX),                      ),
                    ),
                    OnBoardingGridView(
                        screenWidth: MediaQuery.of(context).size.width),
                    SizedBox(
                      height: 2.h,
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  showAlert(BuildContext context, AppStateNotifier them) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 55.h,
            width: 150.w,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        data[index].toString(),
                        style: GoogleFonts.lexendDeca(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                      leading: Radio(
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => const Color.fromRGBO(234, 72, 220, 1)),
                        focusColor: MaterialStateColor.resolveWith(
                                (states) => const Color.fromRGBO(234, 72, 220, 1)),
                        value: "Radio",
                        groupValue: '',
                        onChanged: (String? value) {
                          setState(() {
                            selectedItem = data[index].toString();
                            if (kDebugMode) {
                              print('category$selectedItem');
                            }
                            if (selectedItem == data[index]) {
                              check = true;
                            }
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    print("object");
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        update(_updateInfo!);
      });
    }).catchError((e) {
      print("app update error: $e");
    });
  }

  void update(AppUpdateInfo updateInfo) {
    print(
        "${updateInfo.updateAvailability} == ${UpdateAvailability.updateAvailable}");
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      print("yessssss");
      InAppUpdate.performImmediateUpdate();
    }
  }
}
