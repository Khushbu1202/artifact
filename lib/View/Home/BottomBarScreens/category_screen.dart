import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Models/signinwithgoogle_model.dart';
import '../../../../Provider_Data/dark_mode.dart';
import '../../../../Provider_Data/user_provider_count.dart';
import '../../../../Utilities/app_color.dart';
import '../../../../Utilities/constants.dart';
import '../../Splash/splash_view.dart';

class CategoryScreen extends StatefulWidget {
  final User? user;

  const CategoryScreen({super.key, this.user});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool value = false;
  bool _switchValue3 = true;
  bool _switchValue4 = true;

  final Uri instaUrl = Uri.parse(
      'https://www.instagram.com/kindlebit_solutions?igshid=OGQ5ZDc2ODk2ZA==');
  // final Uri twitterUrl = Uri.parse('www.kindlebit.com');
  final Uri fbUrl =
  Uri.parse('https://www.facebook.com/profile.php?id=100094372151854');
  final Uri youtubeUrl = Uri.parse(
      'https://www.youtube.com/@khushbudhatwalia');
  final Uri linkedInUrl = Uri.parse('http://www.kindlebit.com/');

  late StreamSubscription<List<PurchaseDetails>>? _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  var email;
  Map<String, dynamic>? data;
  var data2;
  var updatecount;
  String plan = "";
  var day_limit;
  var expiry;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      getUserDetails(user?.email.toString() ?? '');
      print('data show');
    });
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>?;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        userProvider.getUserDetails(user.email.toString());
      }
    });
  }

  String? selectedDirectory;

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
        print("purchase pending......!!");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
          // checkSubscription();
          print("purchase failed......!!");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // postSubscription();
          // updatePlan(purchaseDetails.productID);

          print("purchase success......!!${purchaseDetails.productID}");
          if (purchaseDetails.productID == "subscription_bronze") {
            updatePlan("Bronze");
          }
          if (purchaseDetails.productID == "silver") {
            updatePlan("Silver");
          }
          if (purchaseDetails.productID == "gold") {
            updatePlan("Gold");
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> loadProductsForSale(
      BuildContext context, String productId) async {
    if (await isAppPurchaseAvailable(context)) {
      // const Set<String> _kIds = {"gold", "silver", "subscription_bronze"};
      Set<String> _kIds = {productId};
      final ProductDetailsResponse response =
      await InAppPurchase.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint(
            '#PurchaseService.loadProductsForSale() notFoundIDs: ${response.notFoundIDs}');
      }
      if (response.error != null) {
        debugPrint(
            '#PurchaseService.loadProductsForSale() error: ${response.error!.code + ' - ' + response.error!.message}');
      }
      buySubscription(response.productDetails.first);
      List<ProductDetails> products = response.productDetails;
      print(products.first.price);
    } else {
      debugPrint('#PurchaseService.loadProductsForSale() store not available');
    }
  }

  buySubscription(ProductDetails productDetails) async {
    ///Step: 3
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = PurchaseParam(productDetails: productDetails);

      print(purchaseParam.productDetails.description);
    } else {
      ///IOS handling
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }

    ///buying Subscription
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<bool> isAppPurchaseAvailable(BuildContext context) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    // final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!available) {
      if (kDebugMode) {
        print("yes");
      }
    } else {
      if (kDebugMode) {
        print("No");
      }
    }
    return available;
  }

  Future<void> getUserDetails(String email) async {
    final DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('users').doc(email);
    final DocumentSnapshot documentSnapshot = await userDocRef.get();
    if (documentSnapshot.exists) {
      data = documentSnapshot.data() as Map<String, dynamic>;
      data2 = UserDetails.fromJson(data ?? {});

      setState(() {
        updatecount = plan == "nothing"
            ? 3 - data2.count
            : plan == "Bronze"
            ? 100 - data2.count
            : plan == "Silver"
            ? 220 - data2.count
            : 500 - data2.count;
        plan = data2.plan;
        day_limit = data2.day_limit;
        expiry = data2.expiry;
        if (kDebugMode) {
          print("snakmxxn======${data2.count}");
        }
        if (kDebugMode) {
          print("last count=======${updatecount.toString()}");
        }
      });
    }
  }

  Future<void> updatePlan(plan) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user?.email);
      await userDocRef.update({'plan': plan});
      await userDocRef.update({'count': 0});
      getUserDetails(user!.email.toString());
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SplashScreen()));
    } catch (error) {
      if (kDebugMode) {
        print('Error signing out: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userdetails = userProvider.userDetails;
    // final count = userProvider.updatecount;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      getUserDetails(user?.email.toString() ?? '');
    });

    final themProvider = Provider.of<AppStateNotifier>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor:
        themProvider.isDarkModeOn ? ColorX.blackX : Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: themProvider.isDarkModeOn
                      ? Image.asset(
                    'image/Group 37079.png',
                    height: 4.h,
                  )
                      : Image.asset(
                    'image/Group 37081.png',
                    height: 4.h,
                  ),
                ),
                themProvider.isDarkModeOn
                    ? IconButton(
                  onPressed: () {
                    logout();
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                )
                    : IconButton(
                  onPressed: () {
                    logout();
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: CircleAvatar(
                          radius: 40,
                          child: Image.network(
                            userdetails?.photoURL.toString() ?? "",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              // print(data2?.displayName);
                            },
                            child: Text(
                              // widget.user!.displayName.toString(),
                              userdetails?.displayName ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                              // style: const TextStyle(
                              //   fontSize: 15,
                              // ),
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                            child: InkWell(
                              onTap: () {
                                print("price--->> ${userdetails?.email ?? ""}");
                              },
                              child: Text(
                                userdetails?.email ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Select Theme',
                    style: stylePoppins(
                      themProvider.isDarkModeOn ? ColorX.whiteX : ColorX.blackX,
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0.w),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _switchValue3 = true;
                            themProvider.updateTheme(false);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: _switchValue3 == true
                                    ? const Color.fromRGBO(234, 72, 220, 1)
                                    : const Color.fromRGBO(234, 72, 220, 1),
                                width: 0.3.w),
                            color: themProvider.isDarkModeOn
                                ? ColorX.blackX
                                : ColorX.greyX.withOpacity(0.2),
                          ),
                          child: _switchValue3 == true
                              ? Icon(
                            Icons.circle,
                            color: themProvider.isDarkModeOn
                                ? ColorX.blackX
                                : const Color.fromRGBO(234, 72, 220, 1),
                            size: 1.5.h,
                          )
                              : null,
                        ),
                      ),
                    ),
                    title: Text(
                      'Light Theme',
                      style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: themProvider.isDarkModeOn
                            ? ColorX.whiteX
                            : ColorX.blackX,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(left: 0.w),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _switchValue3 = false;
                            _switchValue4 = true;
                            themProvider.updateTheme(_switchValue4);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: _switchValue4 == true
                                    ? const Color.fromRGBO(234, 72, 220, 1)
                                    : const Color.fromRGBO(234, 72, 220, 1),
                                width: 0.3.w),
                            color: themProvider.isDarkModeOn
                                ? ColorX.blackX
                                : ColorX.greyX.withOpacity(0.2),
                          ),
                          child: _switchValue4
                              ? Icon(
                            Icons.circle,
                            color: themProvider.isDarkModeOn
                                ? const Color.fromRGBO(234, 72, 220, 1)
                                : Colors.transparent,
                            size: 1.5.h,
                          )
                              : null,
                        ),
                      ),
                    ),
                    title: Text(
                      'Dark Theme',
                      style: GoogleFonts.lexendDeca(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: themProvider.isDarkModeOn
                            ? ColorX.whiteX
                            : ColorX.blackX,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Plan:",
                    style: stylePoppins(
                      themProvider.isDarkModeOn ? ColorX.whiteX : ColorX.blackX,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themProvider.isDarkModeOn
                            ? ColorX.whiteX
                            : ColorX.whiteX,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: themProvider.isDarkModeOn
                          ? ColorX.blackX
                          : ColorX.whiteX,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Text(
                        plan == "nothing" ? 'Free' : plan,
                        style: stylePoppins1(
                          themProvider.isDarkModeOn
                              ? ColorX.whiteX
                              : ColorX.blackX,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 145,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themProvider.isDarkModeOn
                                ? ColorX.whiteX
                                : ColorX.whiteX,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Images",
                              style: stylePoppins2(
                                themProvider.isDarkModeOn
                                    ? ColorX.whiteX
                                    : ColorX.blackX,
                              ),
                            ),
                            Text(
                              plan == "nothing"
                                  ? "3"
                                  : plan == "Bronze"
                                  ? "100"
                                  : plan == "Silver"
                                  ? "220"
                                  : "500",
                              style: stylePoppins3(
                                themProvider.isDarkModeOn
                                    ? ColorX.whiteX
                                    : ColorX.blackX,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Container(
                        height: 100,
                        width: 145,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: themProvider.isDarkModeOn
                                ? ColorX.whiteX
                                : ColorX.whiteX,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: themProvider.isDarkModeOn
                              ? ColorX.blackX
                              : ColorX.whiteX,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Remaining Images",
                              style: stylePoppins2(
                                themProvider.isDarkModeOn
                                    ? ColorX.whiteX
                                    : ColorX.blackX,
                              ),
                            ),
                            Text(
                              updatecount.toString(),
                              style: stylePoppins3(
                                themProvider.isDarkModeOn
                                    ? ColorX.whiteX
                                    : ColorX.blackX,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _showModalSheet();
                    },
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themProvider.isDarkModeOn
                              ? ColorX.whiteX
                              : ColorX.whiteX,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: themProvider.isDarkModeOn
                            ? ColorX.blackX
                            : ColorX.whiteX,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Center(
                          child: Text(
                            "Upgrade Plan",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: themProvider.isDarkModeOn
                                  ? ColorX.whiteX
                                  : ColorX.blackX,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Follow Us On:",
                    style: stylePoppins(
                      themProvider.isDarkModeOn ? ColorX.whiteX : ColorX.blackX,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(
                                () async {
                              if (!await launchUrl(instaUrl)) {
                                throw Exception('Could not launch $instaUrl');
                              }
                            },
                          );
                        },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themProvider.isDarkModeOn
                                  ? ColorX.whiteX
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(1.5.w),
                            image: const DecorationImage(
                              image: AssetImage(
                                'image/Vector (1).png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      GestureDetector(
                        // onTap: () async {
                        //   if (!await launchUrl(twitterUrl)) {
                        //     throw Exception('Could not launch $twitterUrl');
                        //   }
                        // },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themProvider.isDarkModeOn
                                      ? ColorX.whiteX
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(1.10.w),
                              image: const DecorationImage(
                                  image: AssetImage('image/Vector.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!await launchUrl(fbUrl)) {
                            throw Exception('Could not launch $fbUrl');
                          }
                        },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themProvider.isDarkModeOn
                                      ? ColorX.whiteX
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(1.5.w),
                              image: const DecorationImage(
                                  image: AssetImage('image/Group 18694.png'),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!await launchUrl(youtubeUrl)) {
                            throw Exception('Could not launch $youtubeUrl');
                          }
                        },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themProvider.isDarkModeOn
                                      ? ColorX.whiteX
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(1.5.w),
                              image: const DecorationImage(
                                  image: AssetImage('image/Group 18693.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!await launchUrl(linkedInUrl)) {
                            throw Exception('Could not launch $linkedInUrl');
                          }
                        },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: themProvider.isDarkModeOn
                                      ? ColorX.whiteX
                                      : Colors.transparent),
                              borderRadius: BorderRadius.circular(1.5.w),
                              image: const DecorationImage(
                                  image: AssetImage('image/Vector (2).png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Do you want to logout?',
            style: GoogleFonts.lexend(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'This will log out of the app.',
                  style: GoogleFonts.lexend(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SignOut'),
              onPressed: () {
                _handleSignOut();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.w),
            topRight: Radius.circular(4.w),
          ),
        ),
        builder: (BuildContext context) {
          final themProvider = Provider.of<AppStateNotifier>(context);
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: themProvider.isDarkModeOn
                                          ? ColorX.whiteX
                                          : ColorX.blackX,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: themProvider.isDarkModeOn
                                            ? ColorX.whiteX
                                            : ColorX.blackX,
                                      ),
                                      child: Image.asset(
                                        "image/11.png",
                                        color: themProvider.isDarkModeOn
                                            ? ColorX.blackX
                                            : ColorX.whiteX,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Please select your",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorX.blackX,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        "monthly plan!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorX.blackX,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  loadProductsForSale(context, "subscription_bronze");
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFD3217D),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Bronze Plan:",
                                              style: TextStyle(
                                                color: ColorX.whiteX,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            Container(
                                              height: 24,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(05),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "\$5",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.sp,
                                                    color: const Color(0xFFD3217D),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Craft up to 100 AI-based images monthly,with\na daily limit of 10.Dive into the world od digital\nart for just \$5 USD a month.",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lexendDeca(
                                                // fontWeight: FontWeight.w300,
                                                fontSize: 12.5,
                                                color: themProvider.isDarkModeOn
                                                    ? ColorX.whiteX
                                                    : ColorX.whiteX,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 05,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loadProductsForSale(context, "silver");
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF792B89),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Silver Plan:",
                                              style: GoogleFonts.lexend(
                                                color: ColorX.whiteX,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            Container(
                                              height: 24,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(05),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "\$10",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF792B89),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10, right: 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Expand your creative horizons! Generate 220 images per month,allowing 20 images per day,all for an affordable \$10 USD a monthly investment.",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lexendDeca(
                                                // fontWeight: FontWeight.w300,
                                                fontSize: 12.5,
                                                color: themProvider.isDarkModeOn
                                                    ? ColorX.whiteX
                                                    : ColorX.whiteX,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 05,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loadProductsForSale(context, "gold");
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFFF7800),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Gold Plan:",
                                              style: GoogleFonts.lexend(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.sp),
                                            ),
                                            Container(
                                              height: 24,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(05),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "\$20",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFFFF7800),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Unleash unlimited creativity with 500 images\nper month and a daily allowance of 30.Elevate\nyour artistic endeavors for just \$20 USD a month.",
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.lexendDeca(
                                                // fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: themProvider.isDarkModeOn
                                                    ? ColorX.whiteX
                                                    : ColorX.whiteX,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  "Each plan is valid for 30 days only",
                                  style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w400,
                                    color: themProvider.isDarkModeOn
                                        ? ColorX.whiteX
                                        : ColorX.blackX,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                );
              });
        });
  }
}
