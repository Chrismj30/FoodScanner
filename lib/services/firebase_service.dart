import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/food_consumption.dart';

class FirebaseService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // User getters
  User? get currentUser => _auth.currentUser;
  bool get isUserLoggedIn => currentUser != null;
  String get userId => currentUser?.uid ?? '';

  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: kIsWeb 
            ? const FirebaseOptions(
                apiKey: "AIzaSyCDeTYoqPpvBkcFgIq_m0WXOO3xyohCaNA",
                authDomain: "foodeye-1030a.firebaseapp.com",
                projectId: "foodeye-1030a",
                storageBucket: "foodeye-1030a.firebasestorage.app",
                messagingSenderId: "1018454074805",
                appId: "1:1018454074805:web:4e4d900ba0baeb2b0da5fc",
                measurementId: "G-7BKPG05GJT",
              )
            : null, // For mobile, Firebase will use google-services.json/GoogleService-Info.plist
      );
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
    }
  }

  // Authentication methods
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error signing in with email and password: $e');
      return null;
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error creating user with email and password: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // Password reset method
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email');
    } catch (e) {
      debugPrint('Error sending password reset email: $e');
      throw e; // Rethrow to handle in UI
    }
  }

  // Food history methods
  Future<void> saveFoodHistory(List<FoodConsumption> foodHistory) async {
    if (!isUserLoggedIn) return;
    
    try {
      final historyJson = foodHistory.map((item) => item.toJson()).toList();
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('food_history')
          .doc('history')
          .set({'items': historyJson});
      
      debugPrint('Food history saved to Firestore');
    } catch (e) {
      debugPrint('Error saving food history to Firestore: $e');
    }
  }

  Future<List<FoodConsumption>> loadFoodHistory() async {
    if (!isUserLoggedIn) return [];
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('food_history')
          .doc('history')
          .get();
      
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data.containsKey('items')) {
          final List<dynamic> items = data['items'];
          return items.map((item) => FoodConsumption.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error loading food history from Firestore: $e');
      return [];
    }
  }

  // Daily intake methods
  Future<void> saveDailyIntake(DateTime date, Map<String, double> intake) async {
    if (!isUserLoggedIn) return;
    
    try {
      final dateStr = '${date.year}-${date.month}-${date.day}';
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_intake')
          .doc(dateStr)
          .set(intake);
      
      debugPrint('Daily intake saved to Firestore for date: $dateStr');
    } catch (e) {
      debugPrint('Error saving daily intake to Firestore: $e');
    }
  }

  Future<Map<String, double>> loadDailyIntake(DateTime date) async {
    if (!isUserLoggedIn) return {};
    
    try {
      final dateStr = '${date.year}-${date.month}-${date.day}';
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_intake')
          .doc(dateStr)
          .get();
      
      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic> data = snapshot.data()!;
        final Map<String, double> intake = {};
        
        data.forEach((key, value) {
          intake[key] = (value as num).toDouble();
        });
        
        return intake;
      }
      return {};
    } catch (e) {
      debugPrint('Error loading daily intake from Firestore: $e');
      return {};
    }
  }

  // Image storage methods
  Future<String> uploadImage(dynamic imageFile, String folder) async {
    if (!isUserLoggedIn) return '';
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = '$folder/${userId}_$timestamp';
      final ref = _storage.ref().child(path);
      
      UploadTask uploadTask;
      
      if (kIsWeb) {
        // Handle web image upload
        if (imageFile is XFile) {
          final bytes = await imageFile.readAsBytes();
          uploadTask = ref.putData(bytes);
        } else {
          return '';
        }
      } else {
        // Handle mobile image upload
        uploadTask = ref.putFile(imageFile as File);
      }
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      debugPrint('Image uploaded to Firebase Storage: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }
} 