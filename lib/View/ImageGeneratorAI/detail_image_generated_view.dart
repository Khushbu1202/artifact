import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:progress_border/progress_border.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Provider_Data/dark_mode.dart';
import '../../Utilities/app_color.dart';

class DetailImageGeneratedScreen extends StatefulWidget {
  final String? image;
  final String? savedImagePath;
  // final String? selectedImage;
  final String? type;
  const DetailImageGeneratedScreen(
      {super.key, this.image, this.type, this.savedImagePath});

  @override
  State<DetailImageGeneratedScreen> createState() =>
      _DetailImageGeneratedScreenState();
}

class _DetailImageGeneratedScreenState
    extends State<DetailImageGeneratedScreen> {

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("image----->> ${widget.image}");
    }
    if (kDebugMode) {
      print("image------>> ${widget.savedImagePath}");
    }
    final themProvider = Provider.of<AppStateNotifier>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    final InAppReview inAppReview = InAppReview.instance;

    return SafeArea(
      child: Scaffold(
        backgroundColor: themProvider.isDarkModeOn
            ? ColorX.blackX
            : const Color.fromRGBO(225, 225, 225, 1),
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Result",
                  style: GoogleFonts.lexendDeca(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(
                  height: 1.h,
                ),

                Container(
                  decoration: BoxDecoration(
                      color: themProvider.isDarkModeOn
                          ? ColorX.blackX
                          : ColorX.whiteX,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: themProvider.isDarkModeOn
                              ? ColorX.whiteX
                              : ColorX.whiteX)),
                  child:
                  widget.type == "ASSETS"
                      ? Container(
                    decoration: BoxDecoration(
                      color: themProvider.isDarkModeOn
                          ? ColorX.blackX
                          : ColorX.whiteX,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: Image.asset(
                        widget.savedImagePath.toString(),
                        fit: BoxFit.fill,
                        height: 2 * (screenWidth / 2.5),
                        width: screenWidth,
                      ),
                    ),
                  )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(3.w),
                      child: CachedNetworkImage(
                        imageUrl: widget.image.toString(),
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
                      )),
                ),

                SizedBox(height: 3.h),
                InkWell(
                  onTap: () async {
                    inAppReview.openStoreListing(
                        appStoreId: '...',
                        microsoftStoreId: 'com.logoitechbiz.artifect');
                  },
                  child: Container(
                      height: 6.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(234, 72, 220, 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 0,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Center(
                              child: Text(
                                "Share Your Feedback!",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 2.h),
                InkWell(
                  onTap: () {


                    Navigator.of(context).pop();
                    // Navigator.of(context).pushReplacementNamed(RootsName.bottomBar);

                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const BottomBar()));
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   RootsName.bottomBar,
                    //       (route) => false, // remove all previous routes
                    // );
                    // Navigator.of(context).pushNamed(RootsName.bottomBar);

                    // Navigator.of(context).pushNamed("/bottomBar");
                  },
                  child: Container(
                    height: 6.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themProvider.isDarkModeOn
                          ? ColorX.whiteX
                          : ColorX.blackX,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Close",
                          style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: themProvider.isDarkModeOn
                                  ? ColorX.blackX
                                  : ColorX.whiteX),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
