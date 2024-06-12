import 'dart:convert';
import 'dart:math';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService{

  signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'notificationToken': token});
  }

  signInWithApple() async{ 

    final rawNonce = generateNonce();

    final nonce = sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      rawNonce: rawNonce,
    );

    await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'notificationToken': token});
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
  }

  String sha256ofString(String input){
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


}