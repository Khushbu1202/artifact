import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Models/signinwithgoogle_model.dart';

class UserProvider extends ChangeNotifier {

  UserDetails? userDetails;
  int updatecount = 0;

  void getUserDetails(String email) async{
    final DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(email);
    final DocumentSnapshot documentSnapshot = await userDocRef.get();
    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      userDetails = UserDetails.fromJson(data);
      
      updatecount = 3 - userDetails!.count!;

      notifyListeners();
    }
  }

  void updateUserCount(int count) {
    updatecount = count;
    notifyListeners();
  }

}
