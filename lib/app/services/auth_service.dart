// lib/app/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../data/models/models.dart';
import 'firestore_service.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    debugPrint('[AUTH] AuthService.onInit — binding auth state stream');
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthStateChange);
  }

  void _handleAuthStateChange(User? user) async {
    if (user != null) {
      debugPrint('[AUTH] Auth state changed — user logged in: ${user.uid} (${user.email})');
      final userData = await _firestoreService.getUser(user.uid);
      currentUser.value = userData;
      debugPrint('[AUTH] Firestore user loaded: ${userData?.name ?? 'null'}');
    } else {
      debugPrint('[AUTH] Auth state changed — user logged out');
      currentUser.value = null;
    }
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<UserModel?> signInWithGoogle() async {
    try {
      debugPrint('[AUTH] signInWithGoogle — step 1: launching Google picker');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('[AUTH] signInWithGoogle — user cancelled picker, returning null');
        return null;
      }
      debugPrint('[AUTH] signInWithGoogle — step 2: got Google account: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      debugPrint('[AUTH] signInWithGoogle — step 3: got tokens. accessToken=${googleAuth.accessToken != null}, idToken=${googleAuth.idToken != null}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('[AUTH] signInWithGoogle — step 4: signing in with Firebase credential');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;
      debugPrint('[AUTH] signInWithGoogle — step 5: Firebase sign-in success. uid=${user.uid}');

      debugPrint('[AUTH] signInWithGoogle — step 6: checking Firestore for existing user');
      final existingUser = await _firestoreService.getUser(user.uid);

      if (existingUser == null) {
        debugPrint('[AUTH] signInWithGoogle — step 7: new user, creating Firestore document');
        final newUser = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'Student',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          coins: 5,
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(newUser);
        currentUser.value = newUser;
        debugPrint('[AUTH] signInWithGoogle — step 8: new user created successfully');
        return newUser;
      } else {
        currentUser.value = existingUser;
        debugPrint('[AUTH] signInWithGoogle — step 7: existing user loaded: ${existingUser.name}');
        return existingUser;
      }
    } catch (e, stackTrace) {
      debugPrint('[AUTH] signInWithGoogle — ERROR: $e');
      debugPrint('[AUTH] StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<void> signOut() async {
    debugPrint('[AUTH] signOut called');
    await _googleSignIn.signOut();
    await _auth.signOut();
    currentUser.value = null;
    debugPrint('[AUTH] signOut complete');
  }

  Future<void> refreshUser() async {
    if (firebaseUser.value != null) {
      final userData = await _firestoreService.getUser(firebaseUser.value!.uid);
      currentUser.value = userData;
    }
  }
}
