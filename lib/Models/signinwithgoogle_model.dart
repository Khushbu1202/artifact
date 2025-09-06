
class UserDetails {
  String? email;
  String? displayName;
  String? photoURL;
  String? plan;
  String? expiry;
  int? count;
  int? day_limit;
  UserDetails({
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.count,
    required this.plan,
    required this.day_limit,
    required this.expiry,
  });
  UserDetails.fromJson(Map<String, dynamic> json){
    email = json['email'];
    displayName = json['displayName'];
    photoURL = json['photoURL'];
    count = json['count'];
    plan = json['plan'];
    day_limit = json['day_limit'];
    expiry = json['expiry'];
  }
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['photoURL'] = photoURL;
    data['displayName'] = displayName;
    data['count'] = count;
    data['plan'] = plan;
    data['day_limit'] = day_limit;
    data['expiry'] = expiry;
    return data;
  }

}