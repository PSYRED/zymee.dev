class UserModel {
/*
  UserModel;
  Here is where data is set for an initial user with a newly created account.
  The goal here is not to collect as much information as possible from the user,
  but to collect enough information for the application to recognize the new created account,
  with the obligation for a user to first verify themselves upon further data collection.
 */
  String? uid;
  String? fullName;
  String? email;
  String? phoneNumber;


  UserModel(
      {this.uid, this.fullName, this.email, this.phoneNumber});

  //Fetching Data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        fullName: map['fullName'],
        phoneNumber: map['phoneNumber']);
  }

  //Sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber
    };
  }
}

class UserAccount {
  String? uid;
  String? username;
  String? profilePictureUrl;
  String? bio;
  int? meetings;

  UserAccount({
    this.uid,
    this.username,
    this.profilePictureUrl,
    this.bio,
    this.meetings
  });

  //Fetching Data from server
  factory UserAccount.fromMap(map) {
    return UserAccount(
      uid: map['uid'],
      username: map['username'],
      profilePictureUrl: map['profilePictureUrl'],
      bio: map['bio'],
      meetings: map['meetings']
    );
  }

  //Sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'meetings': meetings
    };
  }
}


