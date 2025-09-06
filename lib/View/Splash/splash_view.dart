import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../Models/signinwithgoogle_model.dart';
import '../../Provider_Data/dark_mode.dart';
import '../../Utilities/app_color.dart';
import '../Home/BottomBarScreens/Bottom_Bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<UserCredential?> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
  //         .signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleAuth = await googleSignInAccount
  //           .authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //       final UserCredential authResult = await _auth.signInWithCredential(
  //           credential);
  //       final User? user = authResult.user;
  //       if (user != null) {
  //         DatabaseReference userRef = FirebaseDatabase.instance.ref()
  //             .child('users')
  //             .child(user.uid);
  //         userRef.set({
  //           'displayName': user.displayName,
  //           'email': user.email,
  //           'photoURL': user.photoURL,
  //           'uid':user.uid,
  //           'phoneNumber': user.phoneNumber,
  //           'tenantId': user.tenantId,
  //           'refreshToken': user.refreshToken,
  //         });
  //
  //         return await _auth.signInWithCredential(credential);
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Login Failed, Please try again:');
  //     }
  //   }
  //   return null;
  // }
  //
  //
  // Future<void> _storeUserData(User? user) async {
  //   if (user != null) {
  //     DocumentReference userRef = _firestore.collection('users').doc(user.uid);
  //     await userRef.set({
  //       'displayName': user.displayName,
  //       'email': user.email,
  //       'photoURL': user.photoURL,
  //       'uid':user.uid,
  //       'phoneNumber': user.phoneNumber,
  //       'tenantId': user.tenantId,
  //       'refreshToken': user.refreshToken,
  //     });
  //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BottomBar()));
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final themProvider = Provider.of<AppStateNotifier>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SafeArea(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Image.asset('image/Group 188.png', fit: BoxFit.fill),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.only(top: 110, left: 150),
              child: Row(
                children: [
                  themProvider.isDarkModeOn
                      ? Image.asset(
                    'image/Group 37074.png',
                    height: 104.37,
                  )
                      : Image.asset(
                    'image/Group 37074.png',
                    height: 104.37,
                  ),
                ],
              ),
            ),
            Container(
              height: 31,
              width: 144,
              margin: const EdgeInsets.only(top: 567, left: 15),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 40, 125, 1),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Center(
                child: Text(
                  "Powered by AI",
                  style: GoogleFonts.lexendDeca(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 619, left: 18),
              child: Text(
                "Turn your Ideas into ART",
                style: GoogleFonts.lexendDeca(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () async {

                signup(context);

                //   UserCredential? userCredential = await _signInWithGoogle();
                // await _storeUserData(userCredential?.user);
                // _handleSignIn(context);
              },
              child: Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 708, left: 17, right: 17),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(234, 72, 220, 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

// Add a flag to prevent multiple sign-in calls
  bool _isSigningIn = false;

  Future<void> signup(BuildContext context) async {
    if (_isSigningIn) return; // prevent concurrent sign-in
    _isSigningIn = true;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential result = await auth.signInWithCredential(authCredential);

        if (result.user != null) {
          getUserDetails(
            result.user!.email.toString(),
            result.user!.displayName.toString(),
            result.user!.photoURL.toString(),
          );
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomBar()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Failed, Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isSigningIn = false; // reset flag
    }
  }

  // final FirebaseAuth auth = FirebaseAuth.instance;

  // Future<void> signup(BuildContext context) async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  //   if (googleSignInAccount != null){
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //     await googleSignInAccount.authentication;
  //     final AuthCredential authCredential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken,
  //     );
  //     UserCredential result = await auth.signInWithCredential(authCredential);
  //     if (result.user != null) {
  //       getUserDetails(
  //           result.user!.email.toString(), result.user!.displayName.toString(),
  //           result.user!.photoURL.toString());
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BottomBar()));
  //
  //     }else{
  //       final scaffoldMessenger = ScaffoldMessenger.of(context);
  //       scaffoldMessenger.showSnackBar(
  //         const SnackBar(
  //           content: Text('Login Failed, Please try again.'),
  //           backgroundColor: ColorX.pinkX,
  //         ),
  //       );
  //     }
  //   }
  // }

  Map<String, dynamic>? data;
  var data2;
  Future<void> getUserDetails(String email, String name, String photo) async {
    // try {
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(email);
    final DocumentSnapshot documentSnapshot = await userDocRef.get();
    print("object------kd ${documentSnapshot.exists}");
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
      data2 = UserDetails.fromJson(data ?? {});
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BottomBar()));
      print("object-email${email}");
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Successfully Login'),
          backgroundColor: ColorX.pinkX,
        ),
      );
    }
    else{
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'email': email,
        'displayName': name,
        'photoURL': photo,
        'count': 0,
        'plan': "nothing",
        'day_limit': 10,
        'expiry': "",
      });
      // Navigator.of(context).push(
      //     MaterialPageRoute(builder: (context) => const BottomBar()));
      print("object-email${email}");
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Successfully Login'),
          backgroundColor: ColorX.pinkX,
        ),
      );
      print("biff${email}");
    }
  }
}
