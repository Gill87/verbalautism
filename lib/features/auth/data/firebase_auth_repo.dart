import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verbalautism/features/auth/domain/entities/app_user.dart';
import 'package:verbalautism/features/auth/domain/repo/auth_repo.dart';
import 'package:verbalautism/services/auth_google.dart';

class FirebaseAuthRepo implements AuthRepo{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {

      // Sign in attempt
      UserCredential userCred = await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Get User Doc from Firebase Firestore
      DocumentSnapshot userDoc = await firebaseFirestore.collection("users").doc(userCred.user!.uid).get();

      // Record User
      AppUser user = AppUser(
        uid: userCred.user!.uid, 
        email: email, 
        name: userDoc['name']
      );

      // Return user
      return user;

    } catch(e){
      if(e.toString().contains("invalid-email")){
        throw Exception("Login failed due to invalid email");
      } else if(e.toString().contains("invalid-credential")){
        throw Exception("Login failed due to invalid credentials");
      } else {
        throw Exception("Login Failed: $e");
      }
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) async {
    try{
      
      // Create User
      UserCredential userCred = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );

      // Create App User
      AppUser user = AppUser(
        uid: userCred.user!.uid, 
        email: email, 
        name: name,
      );

      // Save User to Cloud Firestore
      await firebaseFirestore.collection("users").doc(user.uid).set(user.toJson());

      // Return user
      return user;

    } catch(e){
      if(e.toString().contains("invalid-email")){
        throw Exception("Registration failed due to invalid email");
      } else if(e.toString().contains("invalid-credential")){
        throw Exception("Registration failed due to invalid credentials");
      } else {
        throw Exception("Registration Failed: $e");
      }    }
  }

  @override
  Future<void> logout() async {
    try {
      // Logout
      await firebaseAuth.signOut();
    } catch(e){
      throw Exception("Logout Failed: $e");
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    // Check for null
    if(firebaseUser == null){
      return null;
    }

    // Fetch user document from firestore
    DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();

    return AppUser(
      uid: firebaseUser.uid, 
      email: firebaseUser.email!, 
      name: userDoc['name'],
    );

  }

  @override
  Future<AppUser?> googleSignIn() async {
    try {
      // Use your AuthService for Google Sign In
      final UserCredential? userCred = await AuthService().signInWithGoogle();
      
      if (userCred?.user == null) {
        return null;
      }
      
      final firebaseUser = userCred!.user!;
      
      // Check if user document exists in Firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      
      AppUser user;
      
      if (!userDoc.exists) {
        // Create new user document if it doesn't exist
        user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: firebaseUser.displayName ?? 'User',
        );
        
        // Save to Firestore
        await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .set(user.toJson());
      } else {
        // User exists, create AppUser from existing data
        user = AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: userDoc['name'] ?? firebaseUser.displayName ?? 'User',
        );
      }
      
      return user;
    } catch (e) {
      throw Exception("Google Sign In Failed");
    }
  }
  
}