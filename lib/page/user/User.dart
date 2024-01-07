import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String? displayName;
  final String? email;
  final GoogleIdentity? googleIdentity; // You need to store GoogleIdentity for the avatar.

  User({this.displayName, this.email, this.googleIdentity});

  // A named constructor to create a User from a GoogleSignInAccount.
  factory User.fromGoogleAccount(GoogleSignInAccount account) {
    return User(
      displayName: account.displayName,
      email: account.email,
      googleIdentity: account, // Store the Google account for access to the GoogleIdentity.
    );
  }
}
