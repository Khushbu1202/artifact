import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider_Data/dark_mode.dart';
import 'category_screen.dart';
import 'home_screen.dart';

class BottomBar extends StatefulWidget {
  // final User? user;
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final themProvider = Provider.of<AppStateNotifier>(context);
    // final bottomBarProvider = Provider.of<BottomBarProvider>(context);
    // final List<Widget> views = [
    //   const HomeScreen(),
    //   const CategoryScreen()
    // ];
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: themProvider.isDarkModeOn ? Color.fromRGBO(255, 255, 255, 0.2):Colors.white,
        activeColor: themProvider.isDarkModeOn ? Colors.white : Colors.white,
        inactiveColor: themProvider.isDarkModeOn ? Colors.white : Colors.black,
        iconSize: 25,
        items: <BottomNavigationBarItem>[
          _bottomNavigationBarItem(Icons.home, context),
          _bottomNavigationBarItem(Icons.window_rounded, context),
        ],
      ),

      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child:HomeScreen(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return  CupertinoPageScaffold(
                  child:CategoryScreen()
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child:BottomBar(),
              );
            });
        }
      },
    );
  }
}

BottomNavigationBarItem _bottomNavigationBarItem(
    IconData icon, BuildContext context) {
  return BottomNavigationBarItem(
    activeIcon: Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(234, 72, 220, 1),
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        children: [
          Expanded(
            child: Icon(icon, color: Colors.black),
          ),
        ],
      ),
    ),
    icon: Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Column(
        children: [
          Expanded(
            child: Icon(icon),
          ),
        ],
      ),
    ),
  );
}

//     Scaffold(
//     body: IndexedStack(
//       index: bottomBarProvider.currentIndex,
//       children: views,
//     ),
//     bottomNavigationBar: Container(
//       decoration: BoxDecoration(
//         color: themProvider.isDarkModeOn ? ColorX.blackX : ColorX.whiteX,
//         border: const Border(
//           top: BorderSide(width: 1, color:  ColorX.whiteX),
//         ),
//       ),
//       height: 8.h,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               bottomBarProvider.updateIndex(0);
//             },
//             child: Container(
//               height: 5.h,
//               width: 50,
//               // color: Colors.pink,
//               margin: const EdgeInsets.symmetric(horizontal: 60),
//               padding: EdgeInsets.all(2.w),
//               child: Center(
//                 child: Image.asset(
//                   bottomBarProvider.currentIndex == 0 ? themProvider.isDarkModeOn ? "image/homegr.png": "image/homegr.png":"image/6.png",
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 2.w,
//           ),
//           GestureDetector(
//             onTap: () {
//               bottomBarProvider.updateIndex(1);
//             },
//             child: Container(
//               height: 5.h,
//               width: 50,
//               margin: const EdgeInsets.symmetric(horizontal: 60),
//               padding: EdgeInsets.all(2.w),
//               child: Image.asset(
//                 bottomBarProvider.currentIndex == 1 ? themProvider.isDarkModeOn ? "image/homecat.png": "image/homecat.png":"image/7.png",
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }




// Future<void> downloadImage(String customDirectory) async {
//   final url = 'https://example.com/your_image_url.jpg'; // Replace with the image URL you want to download.
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final Directory customDir = Directory(customDirectory);
//     if (!(await customDir.exists())) {
//       await customDir.create(recursive: true);
//     }
//
//     final String filePath = '${customDir.path}/downloaded_image.jpg';
//
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     // Now, 'file' contains the downloaded image at the custom directory path.
//     print('Image downloaded to: $filePath');
//   } else {
//     // Handle error, such as network issues or invalid URL.
//     print('Failed to download image: ${response.statusCode}');
//   }
// }
// }

