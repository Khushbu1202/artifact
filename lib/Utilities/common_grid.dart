import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../Provider_Data/dark_mode.dart';
import '../Provider_Data/handle_ai.dart';
import '../View/ImageGeneratorAI/image_generated_view.dart';
import 'app_color.dart';

class OnBoardingGridView extends StatefulWidget {
  final double screenWidth;
  const OnBoardingGridView({super.key, required this.screenWidth});

  @override
  State<OnBoardingGridView> createState() => _OnBoardingGridViewState();
}

class _OnBoardingGridViewState extends State<OnBoardingGridView> {

  List<TryModel> tryIdeas = [
    TryModel(image:"image/Rectangle 2 (2).png",
        description:"a Dog wearing a red beanie wearing sunglasses, eating a burger",
        category: "Realism"),
    TryModel(image:"image/Rectangle 3.png",
        description:"a colourful bright donuts",
        category: "Realism"),
    TryModel(image:"image/Rectangle 5.png",
        description:"batman running in the jungle",
        category: "Anime"),
    TryModel(image:"image/Rectangle 6.png",
        description:"3D render bright orange baby bird, adorable big eyes, in a garden with butterflies, lush greenery, whims",
        category: "3d- Model"),
    TryModel(image:"image/Rectangle 7.png",
        description:"batman running in the jungle",
        category: "Anime"),
    TryModel(image:"image/Rectangle 9.png",
        description:"3D render bright orange baby bird, adorable big eyes, in a garden with butterflies, lush greenery, whims",
        category: "3d- Model"),
    TryModel(
        image:"image/Rectangle 1.png",
        description:"Lorem Ipsum is dummy content",
        category: "3D Model"
    ),
    TryModel(
        image:"image/Rectangle 4.png",
        description:"The mouse is in the gym and holding dumbbells",
        category: "Digital Art "),
  ];

  @override
  void initState() {
    super.initState();
    startAutoShuffle();
  }


  void startAutoShuffle() {
    const shuffleDuration = Duration(seconds: 45); // Adjust the shuffle interval as needed
    Timer.periodic(shuffleDuration, (Timer timer) {
      shuffleTryIdeas(tryIdeas);
      setState(() {});
    });
  }

  void shuffleTryIdeas(List<TryModel> tryIdeas) {
    final random = Random();

    for (int i = tryIdeas.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = tryIdeas[i];
      tryIdeas[i] = tryIdeas[j];
      tryIdeas[j] = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themProvider = Provider.of<AppStateNotifier>(context);
    return ChangeNotifierProvider(
      create: (context) => HandleAi(),
      child: Consumer<HandleAi>(
        builder: (context, model, child) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[0].image,
                              prompt: tryIdeas[0].description,
                              category: tryIdeas[0].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[0].image.toString(),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right:0 ,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                imgUrl: tryIdeas[0].image,
                                prompt: tryIdeas[0].description,
                                category: tryIdeas[0].category,
                                type:  "TRY",
                              )));
                            },
                            child: Container(
                                height: 3.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 40, 125, 1),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Center(
                                  child: Text(
                                    "Try it",
                                    style: GoogleFonts.lexendDeca(
                                      color: Colors.white,
                                    ),
                                    // stylePoppinsReg(
                                    // ColorX.blackX.withOpacity(0.9)
                                    // ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[1].image,
                              prompt: tryIdeas[1].description,
                              category: tryIdeas[1].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[1].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right:0 ,
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                imgUrl: tryIdeas[1].image,
                                prompt: tryIdeas[1].description,
                                category: tryIdeas[1].category,
                                type:  "TRY",
                              )));
                            },
                            child: Container(
                                height: 3.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(255, 40, 125, 1),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Center(
                                  child: Text(
                                    "Try it",
                                    style: GoogleFonts.lexendDeca(
                                      color: Colors.white,
                                    ),
                                    // stylePoppinsReg(
                                    // ColorX.blackX.withOpacity(0.9)
                                    // ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[2].image,
                              prompt: tryIdeas[2].description,
                              category: tryIdeas[2].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[2].image.toString(),
                                fit: BoxFit.fitWidth,

                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[2].image,
                                  prompt: tryIdeas[2].description,
                                  category: tryIdeas[2].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[3].image,
                              prompt: tryIdeas[3].description,
                              category: tryIdeas[3].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[3].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[3].image,
                                  prompt: tryIdeas[3].description,
                                  category: tryIdeas[3].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[4].image,
                              prompt: tryIdeas[4].description,
                              category: tryIdeas[4].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[4].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[4].image,
                                  prompt: tryIdeas[4].description,
                                  category: tryIdeas[4].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[5].image,
                              prompt: tryIdeas[5].description,
                              category: tryIdeas[5].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[5].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[5].image,
                                  prompt: tryIdeas[5].description,
                                  category: tryIdeas[5].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[6].image,
                              prompt: tryIdeas[6].description,
                              category: tryIdeas[6].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[6].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[6].image,
                                  prompt: tryIdeas[6].description,
                                  category: tryIdeas[6].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                              imgUrl: tryIdeas[7].image,
                              prompt: tryIdeas[7].description,
                              category: tryIdeas[7].category,
                              type:  "TRY",
                            )));
                          },
                          child: Container(
                            height: widget.screenWidth / 2.5,
                            width: widget.screenWidth / 2.3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color:themProvider.isDarkModeOn ?ColorX.whiteX:ColorX.whiteX )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.w),
                              child: Image.asset(
                                tryIdeas[7].image.toString(),
                                fit: BoxFit.fitWidth,
                                height: widget.screenWidth / 2.5,
                                width: widget.screenWidth / 2.3,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right:0 ,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageGeneratorScreen(
                                  imgUrl: tryIdeas[7].image,
                                  prompt: tryIdeas[7].description,
                                  category: tryIdeas[7].category,
                                  type:  "TRY",
                                )));
                              },
                              child: Container(
                                  height: 3.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 40, 125, 1),
                                    borderRadius: BorderRadius.circular(10.w),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  child: Center(
                                    child: Text(
                                      "Try it",
                                      style: GoogleFonts.lexendDeca(
                                        color: Colors.white,
                                      ),
                                      // stylePoppinsReg(
                                      // ColorX.blackX.withOpacity(0.9)
                                      // ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );

        },
      ),
    );
  }
}

class TryModel{
  final String image;
  final String description;
  final String category;
  TryModel({required this.image, required this.description ,required this.category});
}
