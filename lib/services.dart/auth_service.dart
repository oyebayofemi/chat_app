import 'package:chat_app/model/userModel.dart';
import 'package:chat_app/shared/snackbar.dart';
import 'package:chat_app/shared/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? userData;

  UserModel? _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      email: user.email,
      id: user.uid,
      name: user.displayName,
      pictureModel: user.photoURL,
    );
  }

  Stream<UserModel?> get onAuthStateChanged {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
  }

  Future<UserModel?> signUp(String email, String password, String username,
      BuildContext context) async {
    try {
      String pictureModel = 'https://i.stack.imgur.com/l60Hf.png';
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = authResult.user;

      userData = UserModel(
        email: email,
        id: user!.uid,
        name: username,
        pictureModel: pictureModel,
      );

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set(userData!.toJson());

      showToast('Registration Successful');
      notifyListeners();
      Navigator.popUntil(context, (route) => route.isFirst);

      return _userFromFirebase(user);

      // return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        //showSnackBar(context, "The password provided is too weak.");
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        // showSnackBar(context, "An account already exists for that email.");
        showToast("An account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
        //showSnackBar(context, "Invalid email.");
        showToast("Invalid email.");
      }
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<UserModel?> signin(
      String email, String password, BuildContext context) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      showSnackBar(context, 'Signed In Successful!!!');
      // notifyListeners();
      // Navigator.popUntil(context, (route) => route.isFirst);

      return _userFromFirebase(user!);
      // return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        // showSnackBar(context, "No user found for that email.");
        showToast("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        // showSnackBar(context, "Wrong password provided for that user.");
        showToast("Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        print('Invalid email.');
        // showSnackBar(context, "Invalid email.");
        showToast("Invalid email.");
      } else if (e.code == 'user-disabled') {
        print('This user has been disabled.');
        // showSnackBar(context, "This user has been disabled");
        showToast("This user has been disabled");
      } else if (e.code == 'too-many-requests') {
        print('Too Many requests.');
        // showSnackBar(context, "Too Many requests");
        showToast("Too Many requests");
      } else if (e.code == 'operation-not-allowed') {
        print('This operation isnt allowed.');
        //showSnackBar(context, "This operation isnt allowed");
        showToast("This operation isnt allowed");
      }
      notifyListeners();

      // since we are not actually continuing after displaying errors
      // the false value will not be returned
      // hence we don't have to check the valur returned in from the signin function
      // whenever we call it anywhere
      return Future.value(null);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final authResult = await _auth.signInWithCredential(credential);

      // userModel = UserModel(
      //     email: googleUser.email,
      //     id: googleUser.id,
      //     pictureModel: googleUser.photoUrl,
      //     name: googleUser.displayName);

      User? user = authResult.user;

      return _userFromFirebase(user!);

      //notifyListeners();
    } else {
      return null;
    }
  }

  Future<UserModel?> currentUser() async {
    final user = await _auth.currentUser;
    return _userFromFirebase(user!);
  }

  resetPasswordLink(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future signout() async {
    //userModel = null;

    _auth.signOut();

    // nbvawait GoogleSignIn.signOut();
    GoogleSignIn().signOut();
    //userModel = null;

    final user = await _auth.currentUser;
    User users = user!;
    print(users.providerData[1].providerId);
    if (users.providerData[1].providerId == 'google.com') {
      await GoogleSignIn().signOut();
    }
    await _auth.signOut();
    notifyListeners();
  }
}
