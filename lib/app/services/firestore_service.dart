// lib/app/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/models.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) return UserModel.fromFirestore(doc);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // Coin History
  Future<List<CoinHistoryModel>> getCoinHistory(String uid) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('coinHistory')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();
      return snapshot.docs
          .map((doc) => CoinHistoryModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addCoinHistory(
      String uid, Map<String, dynamic> historyData) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('coinHistory')
        .add(historyData);
  }

  // Tests
  Future<List<TestModel>> getTests({
    String? subject,
    String? userClass,
    String? difficulty,
  }) async {
    try {
      Query query = _db.collection('tests');
      if (subject != null) query = query.where('subject', isEqualTo: subject);
      if (userClass != null) query = query.where('class', isEqualTo: userClass);
      if (difficulty != null) {
        query = query.where('difficulty', isEqualTo: difficulty);
      }

      final snapshot = await query.limit(20).get();
      return snapshot.docs
          .map((doc) =>
              TestModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getMockTests();
    }
  }

  Future<void> saveTestResult(
      String uid, Map<String, dynamic> result) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('testHistory')
        .add(result);
  }

  // Leaderboard
  Future<List<LeaderboardModel>> getLeaderboard(String period) async {
    try {
      final snapshot = await _db
          .collection('leaderboard')
          .doc(period)
          .collection('users')
          .orderBy('score', descending: true)
          .limit(100)
          .get();

      return snapshot.docs
          .mapIndexed((index, doc) {
            final model =
                LeaderboardModel.fromMap(doc.id, doc.data());
            model.rank = index + 1;
            return model;
          })
          .toList();
    } catch (e) {
      return _getMockLeaderboard();
    }
  }

  // Study Materials
  Future<List<StudyMaterialModel>> getStudyMaterials({
    String? subject,
    String? userClass,
    String? medium,
  }) async {
    try {
      Query query = _db.collection('studyMaterials');
      if (subject != null) query = query.where('subject', isEqualTo: subject);
      if (userClass != null) query = query.where('class', isEqualTo: userClass);
      if (medium != null) query = query.where('medium', isEqualTo: medium);

      final snapshot = await query.limit(30).get();
      return snapshot.docs
          .map((doc) => StudyMaterialModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getMockMaterials();
    }
  }

  // Mock data for development
  List<TestModel> _getMockTests() {
    final mockQuestions = List.generate(
      10,
      (i) => QuestionModel(
        id: 'q$i',
        question: 'Sample question ${i + 1}: What is the result of 2 × ${i + 1}?',
        options: ['${2 * (i + 1) - 2}', '${2 * (i + 1)}', '${2 * (i + 1) + 2}', '${2 * (i + 1) + 4}'],
        correctIndex: 1,
        explanation: 'The answer is ${2 * (i + 1)} because 2 multiplied by ${i + 1} equals ${2 * (i + 1)}.',
      ),
    );

    return [
      TestModel(
        id: 'test1',
        title: 'Bengali - Prose & Poetry',
        subject: 'Bengali',
        userClass: 'Class 10',
        chapter: 'Prose',
        difficulty: 'Medium',
        coinCost: 20,
        questions: mockQuestions,
        totalMarks: 10,
        duration: 600,
      ),
      TestModel(
        id: 'test2',
        title: 'English - Grammar Essentials',
        subject: 'English',
        userClass: 'Class 10',
        chapter: 'Grammar',
        difficulty: 'Easy',
        coinCost: 10,
        questions: mockQuestions,
        totalMarks: 10,
        duration: 600,
      ),
      TestModel(
        id: 'test3',
        title: 'History - Modern India',
        subject: 'History',
        userClass: 'Class 10',
        chapter: 'Modern India',
        difficulty: 'Medium',
        coinCost: 20,
        questions: mockQuestions,
        totalMarks: 10,
        duration: 750,
      ),
      TestModel(
        id: 'test4',
        title: 'Political Science - Indian Constitution',
        subject: 'Political Science',
        userClass: 'Class 11',
        chapter: 'Constitution',
        difficulty: 'Hard',
        coinCost: 30,
        questions: mockQuestions,
        totalMarks: 10,
        duration: 900,
      ),
    ];
  }

  List<LeaderboardModel> _getMockLeaderboard() {
    final names = [
      'Arjun Kumar', 'Priya Sharma', 'Rahul Singh', 'Ananya Patel',
      'Vikram Nair', 'Sneha Reddy', 'Karthik Iyer', 'Divya Menon',
      'Aditya Gupta', 'Meera Nair', 'Rohan Das', 'Pooja Verma',
      'Sanjay Kumar', 'Kavya Krishnan', 'Nikhil Joshi',
    ];

    return names.asMap().entries.map((entry) {
      return LeaderboardModel(
        uid: 'user${entry.key}',
        name: entry.value,
        photoUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=${entry.key}',
        score: 5000 - (entry.key * 280) + (entry.key % 3 * 50),
        testCount: 30 - entry.key,
        coins: 2000 - (entry.key * 100),
        rank: entry.key + 1,
      );
    }).toList();
  }

  List<StudyMaterialModel> _getMockMaterials() {
    return [
      StudyMaterialModel(
        id: 'mat1',
        title: 'Bengali - Class 10 Complete Guide',
        subject: 'Bengali',
        userClass: 'Class 10',
        chapter: 'All Chapters',
        medium: 'Bengali',
        type: 'pdf',
        fileUrl: 'https://example.com/bengali10.pdf',
        thumbnailUrl: 'https://via.placeholder.com/300x200/6C63FF/FFFFFF?text=Bengali',
        downloads: 1250,
      ),
      StudyMaterialModel(
        id: 'mat2',
        title: 'English Grammar - Complete Reference',
        subject: 'English',
        userClass: 'Class 10',
        chapter: 'Grammar',
        medium: 'English',
        type: 'pdf',
        fileUrl: 'https://example.com/english10.pdf',
        thumbnailUrl: 'https://via.placeholder.com/300x200/00E676/FFFFFF?text=English',
        downloads: 1100,
      ),
      StudyMaterialModel(
        id: 'mat3',
        title: 'History - World Wars Summary',
        subject: 'History',
        userClass: 'Class 10',
        chapter: 'World Wars',
        medium: 'Bengali',
        type: 'pdf',
        fileUrl: 'https://example.com/history10.pdf',
        thumbnailUrl: 'https://via.placeholder.com/300x200/FF6B35/FFFFFF?text=History',
        downloads: 675,
      ),
      StudyMaterialModel(
        id: 'mat4',
        title: 'Geography - Physical Geography Notes',
        subject: 'Geography',
        userClass: 'Class 10',
        chapter: 'Physical Geography',
        medium: 'Bengali',
        type: 'pdf',
        fileUrl: 'https://example.com/geography10.pdf',
        thumbnailUrl: 'https://via.placeholder.com/300x200/FFD700/FFFFFF?text=Geography',
        downloads: 890,
      ),
    ];
  }
}

extension IterableIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((element) => f(index++, element));
  }
}
