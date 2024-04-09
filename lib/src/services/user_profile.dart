import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  Future<String?> getUserProfileImageUrl() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.photoURL;
      }
    } catch (e) {
      print("Error getting user profile image: $e");
    }
    return null;
  }
}
