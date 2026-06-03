// lib/app/data/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  int coins;
  int rank;
  int streak;
  int level;
  int xp;
  String? userClass;
  List<String> subjects;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.coins = 0,
    this.rank = 0,
    this.streak = 0,
    this.level = 1,
    this.xp = 0,
    this.userClass,
    this.subjects = const [],
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      coins: data['coins'] ?? 0,
      rank: data['rank'] ?? 0,
      streak: data['streak'] ?? 0,
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      userClass: data['class'],
      subjects: List<String>.from(data['subjects'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'coins': coins,
      'rank': rank,
      'streak': streak,
      'level': level,
      'xp': xp,
      'class': userClass,
      'subjects': subjects,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    int? coins,
    int? rank,
    int? streak,
    int? level,
    int? xp,
    String? userClass,
    List<String>? subjects,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      coins: coins ?? this.coins,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      userClass: userClass ?? this.userClass,
      subjects: subjects ?? this.subjects,
      createdAt: createdAt,
    );
  }
}

// lib/app/data/models/test_model.dart

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correctIndex'] ?? 0,
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
    };
  }
}

class TestModel {
  final String id;
  final String title;
  final String subject;
  final String userClass;
  final String chapter;
  final String difficulty;
  final int coinCost;
  final List<QuestionModel> questions;
  final int totalMarks;
  final int duration; // in seconds

  TestModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.userClass,
    required this.chapter,
    required this.difficulty,
    required this.coinCost,
    required this.questions,
    required this.totalMarks,
    required this.duration,
  });

  factory TestModel.fromMap(String id, Map<String, dynamic> map) {
    return TestModel(
      id: id,
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      userClass: map['class'] ?? '',
      chapter: map['chapter'] ?? '',
      difficulty: map['difficulty'] ?? 'Medium',
      coinCost: map['coinCost'] ?? 10,
      questions: (map['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      totalMarks: map['totalMarks'] ?? 20,
      duration: map['duration'] ?? 1200,
    );
  }
}

// lib/app/data/models/coin_history_model.dart

class CoinHistoryModel {
  final String id;
  final int amount;
  final String type;
  final String description;
  final DateTime timestamp;

  CoinHistoryModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory CoinHistoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CoinHistoryModel(
      id: id,
      amount: map['amount'] ?? 0,
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}

// lib/app/data/models/study_material_model.dart

class StudyMaterialModel {
  final String id;
  final String title;
  final String subject;
  final String userClass;
  final String chapter;
  final String medium;
  final String type; // pdf or video
  final String fileUrl;
  final String thumbnailUrl;
  int downloads;
  bool isBookmarked;

  StudyMaterialModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.userClass,
    required this.chapter,
    required this.medium,
    required this.type,
    required this.fileUrl,
    required this.thumbnailUrl,
    this.downloads = 0,
    this.isBookmarked = false,
  });

  factory StudyMaterialModel.fromMap(String id, Map<String, dynamic> map) {
    return StudyMaterialModel(
      id: id,
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      userClass: map['class'] ?? '',
      chapter: map['chapter'] ?? '',
      medium: map['medium'] ?? 'English',
      type: map['type'] ?? 'pdf',
      fileUrl: map['fileUrl'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      downloads: map['downloads'] ?? 0,
    );
  }
}

// lib/app/data/models/leaderboard_model.dart

class LeaderboardModel {
  final String uid;
  final String name;
  final String photoUrl;
  final int score;
  final int testCount;
  final int coins;
  int rank;

  LeaderboardModel({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.score,
    required this.testCount,
    required this.coins,
    this.rank = 0,
  });

  factory LeaderboardModel.fromMap(String uid, Map<String, dynamic> map) {
    return LeaderboardModel(
      uid: uid,
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      score: map['score'] ?? 0,
      testCount: map['testCount'] ?? 0,
      coins: map['coins'] ?? 0,
      rank: map['rank'] ?? 0,
    );
  }
}

// lib/app/data/models/video_model.dart

class VideoModel {
  final String id;
  final String title;
  final String subject;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final int views;
  final String userClass;

  VideoModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.userClass,
  });
}

// lib/app/data/models/test_result_model.dart

class TestResultModel {
  final String testId;
  final String testTitle;
  final int score;
  final int totalMarks;
  final int correctAnswers;
  final int wrongAnswers;
  final int skippedAnswers;
  final int timeTaken;
  final String subject;
  final List<int?> userAnswers;
  final List<QuestionModel> questions;

  TestResultModel({
    required this.testId,
    required this.testTitle,
    required this.score,
    required this.totalMarks,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.skippedAnswers,
    required this.timeTaken,
    required this.subject,
    required this.userAnswers,
    required this.questions,
  });

  double get accuracy => totalMarks > 0 ? (score / totalMarks) * 100 : 0;
  int get coinsEarned => (accuracy / 10).floor() * 2;
}
