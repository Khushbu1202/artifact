import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../Provider_Data/dark_mode.dart';
import 'app_color.dart';



TextStyle stylePoppins(Color color) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: color,
  );
}

TextStyle stylePoppins1(Color color) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: color,
  );
}

TextStyle stylePoppins4(Color color) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: color,
  );
}

TextStyle stylePoppins2(Color color) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: color,
  );
}

TextStyle stylePoppins3(Color color) {
  return GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 23,
    color: color,
  );
}


TextStyle stylePoppinsReg(Color color) {
  return GoogleFonts.poppins(
      fontWeight: FontWeight.normal, fontSize: 12, color: color);
}

Future<bool> onBackButtonTap(BuildContext context) async{
  bool exit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:ColorX.whiteX,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
          title: const Text(
            "Confirmation",
            style: TextStyle(color: ColorX.pinkX),
          ),
          content: const Text(
              "Do you want to Exit an App?",
              style: TextStyle(color: ColorX.purpleX)),
          actions: <Widget>[
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
                child: const Text("No", style: TextStyle(color: ColorX.pinkX))),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("Yes", style: TextStyle(color: ColorX.pinkX))),
          ],
        );
      });
  return exit;
}
onVariationTap(BuildContext context,String text,AppStateNotifier them) async{
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
            backgroundColor:ColorX.whiteX,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.w),
            ),
            content: SizedBox(
              height: 20.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: stylePoppins1(
                      ColorX.blackX,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 5.h,
                      margin: const EdgeInsets.symmetric(horizontal: 17),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:ColorX.blackX,
                      ),
                      child: Center(
                        child: Text(
                          'Close',
                          style: stylePoppins1(
                              ColorX.whiteX
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
      });
}