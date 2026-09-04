class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatarUrl;
  final bool isOnboarded;
  final String? role;
  final double? walletBalance;
  final List<dynamic>? walletActivity;
  final int? loyaltyPoints;
  final int? trustScore;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.name = '',
    this.phone,
    this.avatarUrl,
    this.isOnboarded = false,
    this.role,
    this.walletBalance,
    this.walletActivity,
    this.loyaltyPoints,
    this.trustScore,
    this.isAnonymous = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      isOnboarded: json['is_onboarded'] ?? false,
      role: json['role']?.toString(),
      walletBalance: (json['wallet_balance'] as num?)?.toDouble(),
      walletActivity: json['wallet_activity'] as List<dynamic>?,
      loyaltyPoints: json['loyalty_points'] as int?,
      trustScore: json['trust_score'] as int?,
      isAnonymous: json['is_anonymous'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_onboarded': isOnboarded,
      'role': role,
      'wallet_balance': walletBalance,
      'wallet_activity': walletActivity,
      'loyalty_points': loyaltyPoints,
      'trust_score': trustScore,
      'is_anonymous': isAnonymous,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatarUrl,
    bool? isOnboarded,
    String? role,
    double? walletBalance,
    List<dynamic>? walletActivity,
    int? loyaltyPoints,
    int? trustScore,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      role: role ?? this.role,
      walletBalance: walletBalance ?? this.walletBalance,
      walletActivity: walletActivity ?? this.walletActivity,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      trustScore: trustScore ?? this.trustScore,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfile {
  final String userId;
  final String? skinType;
  final String? skinConcerns;
  final String? allergies;
  final String? fitnessLevel;
  final String? healthGoals;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? weight;
  final double? height;
  final DateTime updatedAt;

  UserProfile({
    required this.userId,
    this.skinType,
    this.skinConcerns,
    this.allergies,
    this.fitnessLevel,
    this.healthGoals,
    this.dateOfBirth,
    this.gender,
    this.weight,
    this.height,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id']?.toString() ?? '',
      skinType: json['skin_type']?.toString(),
      skinConcerns: json['skin_concerns']?.toString(),
      allergies: json['allergies']?.toString(),
      fitnessLevel: json['fitness_level']?.toString(),
      healthGoals: json['health_goals']?.toString(),
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'].toString())
          : null,
      gender: json['gender']?.toString(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'skin_type': skinType,
      'skin_concerns': skinConcerns,
      'allergies': allergies,
      'fitness_level': fitnessLevel,
      'health_goals': healthGoals,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn = 1800,
    this.tokenType = 'bearer',
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresIn: json['expires_in'] ?? 1800,
      tokenType: json['token_type']?.toString() ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'token_type': tokenType,
    };
  }
}

class AuthResponse {
  final User user;
  final AuthTokens tokens;

  AuthResponse({required this.user, required this.tokens});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    return AuthResponse(
      user: User.fromJson(userJson),
      tokens: AuthTokens.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      ...tokens.toJson(),
    };
  }
}

class OnboardingProgress {
  final String userId;
  final int currentStep;
  final int totalSteps;
  final bool isCompleted;
  final Map<String, dynamic>? stepData;

  OnboardingProgress({
    required this.userId,
    required this.currentStep,
    required this.totalSteps,
    this.isCompleted = false,
    this.stepData,
  });

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) {
    return OnboardingProgress(
      userId: json['user_id']?.toString() ?? '',
      currentStep: json['current_step'] ?? 0,
      totalSteps: json['total_steps'] ?? 6,
      isCompleted: json['is_completed'] ?? false,
      stepData: json['step_data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_step': currentStep,
      'total_steps': totalSteps,
      'is_completed': isCompleted,
      'step_data': stepData,
    };
  }
}

class SoftScan {
  final String? id;
  final String userId;
  final String faceImagePath;
  final Map<String, dynamic>? analysisResult;
  final String? skinType;
  final String? skinConcerns;
  final DateTime createdAt;

  SoftScan({
    this.id,
    required this.userId,
    required this.faceImagePath,
    this.analysisResult,
    this.skinType,
    this.skinConcerns,
    required this.createdAt,
  });

  factory SoftScan.fromJson(Map<String, dynamic> json) {
    return SoftScan(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      faceImagePath: json['face_image_path']?.toString() ?? '',
      analysisResult: json['analysis_result'] as Map<String, dynamic>?,
      skinType: json['skin_type']?.toString(),
      skinConcerns: json['skin_concerns']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'face_image_path': faceImagePath,
      'analysis_result': analysisResult,
      'skin_type': skinType,
      'skin_concerns': skinConcerns,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PrivacyConsent {
  final String userId;
  final bool analyticsConsent;
  final bool marketingConsent;
  final bool thirdPartySharing;
  final bool dataCollection;
  final DateTime updatedAt;

  PrivacyConsent({
    required this.userId,
    this.analyticsConsent = false,
    this.marketingConsent = false,
    this.thirdPartySharing = false,
    this.dataCollection = true,
    required this.updatedAt,
  });

  factory PrivacyConsent.fromJson(Map<String, dynamic> json) {
    return PrivacyConsent(
      userId: json['user_id']?.toString() ?? '',
      analyticsConsent: json['analytics_consent'] ?? false,
      marketingConsent: json['marketing_consent'] ?? false,
      thirdPartySharing: json['third_party_sharing'] ?? false,
      dataCollection: json['data_collection'] ?? true,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'analytics_consent': analyticsConsent,
      'marketing_consent': marketingConsent,
      'third_party_sharing': thirdPartySharing,
      'data_collection': dataCollection,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class DailyCheckin {
  final String? id;
  final String userId;
  final String checkinType;
  final int mood;
  final int energy;
  final int sleep;
  final String? notes;
  final Map<String, dynamic>? symptoms;
  final Map<String, dynamic>? menstrualData;
  final DateTime createdAt;

  DailyCheckin({
    this.id,
    required this.userId,
    required this.checkinType,
    required this.mood,
    required this.energy,
    required this.sleep,
    this.notes,
    this.symptoms,
    this.menstrualData,
    required this.createdAt,
  });

  factory DailyCheckin.fromJson(Map<String, dynamic> json) {
    return DailyCheckin(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      checkinType: json['checkin_type']?.toString() ?? 'am',
      mood: json['mood'] ?? 5,
      energy: json['energy'] ?? 5,
      sleep: json['sleep'] ?? 5,
      notes: json['notes']?.toString(),
      symptoms: json['symptoms'] as Map<String, dynamic>?,
      menstrualData: json['menstrual_data'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'checkin_type': checkinType,
      'mood': mood,
      'energy': energy,
      'sleep': sleep,
      'notes': notes,
      'symptoms': symptoms,
      'menstrual_data': menstrualData,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class HydrationLog {
  final String? id;
  final String userId;
  final double amountMl;
  final DateTime createdAt;

  HydrationLog({
    this.id,
    required this.userId,
    required this.amountMl,
    required this.createdAt,
  });

  factory HydrationLog.fromJson(Map<String, dynamic> json) {
    return HydrationLog(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      amountMl: (json['amount_ml'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount_ml': amountMl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SkinLog {
  final String? id;
  final String userId;
  final String? condition;
  final int? rating;
  final String? notes;
  final List<String>? tags;
  final Map<String, dynamic>? photos;
  final DateTime createdAt;

  SkinLog({
    this.id,
    required this.userId,
    this.condition,
    this.rating,
    this.notes,
    this.tags,
    this.photos,
    required this.createdAt,
  });

  factory SkinLog.fromJson(Map<String, dynamic> json) {
    return SkinLog(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      condition: json['condition']?.toString(),
      rating: json['rating'],
      notes: json['notes']?.toString(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      photos: json['photos'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'condition': condition,
      'rating': rating,
      'notes': notes,
      'tags': tags,
      'photos': photos,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SkinPhoto {
  final String id;
  final String userId;
  final String imageUrl;
  final String? thumbnailUrl;
  final DateTime takenAt;
  final Map<String, dynamic>? metadata;

  SkinPhoto({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.takenAt,
    this.metadata,
  });

  factory SkinPhoto.fromJson(Map<String, dynamic> json) {
    return SkinPhoto(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString(),
      takenAt: DateTime.tryParse(json['taken_at']?.toString() ?? '') ?? DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'taken_at': takenAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class SkinTimelineEntry {
  final DateTime date;
  final SkinLog? log;
  final SkinPhoto? photo;
  final Map<String, dynamic>? analysis;

  SkinTimelineEntry({
    required this.date,
    this.log,
    this.photo,
    this.analysis,
  });

  factory SkinTimelineEntry.fromJson(Map<String, dynamic> json) {
    return SkinTimelineEntry(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      log: json['log'] != null ? SkinLog.fromJson(json['log']) : null,
      photo: json['photo'] != null ? SkinPhoto.fromJson(json['photo']) : null,
      analysis: json['analysis'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'log': log?.toJson(),
      'photo': photo?.toJson(),
      'analysis': analysis,
    };
  }
}

class CycleEvent {
  final String? id;
  final String userId;
  final String eventType;
  final DateTime date;
  final int? flow;
  final String? notes;
  final Map<String, dynamic>? symptoms;

  CycleEvent({
    this.id,
    required this.userId,
    required this.eventType,
    required this.date,
    this.flow,
    this.notes,
    this.symptoms,
  });

  factory CycleEvent.fromJson(Map<String, dynamic> json) {
    return CycleEvent(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      eventType: json['event_type']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      flow: json['flow'],
      notes: json['notes']?.toString(),
      symptoms: json['symptoms'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_type': eventType,
      'date': date.toIso8601String(),
      'flow': flow,
      'notes': notes,
      'symptoms': symptoms,
    };
  }
}

class CycleCalendar {
  final String userId;
  final int averageCycleLength;
  final int averagePeriodLength;
  final DateTime? lastPeriodStart;
  final DateTime? nextPeriodEstimate;
  final DateTime? nextOvulationEstimate;
  final List<CycleEvent> events;
  final List<Map<String, dynamic>> predictions;

  CycleCalendar({
    required this.userId,
    required this.averageCycleLength,
    required this.averagePeriodLength,
    this.lastPeriodStart,
    this.nextPeriodEstimate,
    this.nextOvulationEstimate,
    this.events = const [],
    this.predictions = const [],
  });

  factory CycleCalendar.fromJson(Map<String, dynamic> json) {
    return CycleCalendar(
      userId: json['user_id']?.toString() ?? '',
      averageCycleLength: json['average_cycle_length'] ?? 28,
      averagePeriodLength: json['average_period_length'] ?? 5,
      lastPeriodStart: json['last_period_start'] != null
          ? DateTime.tryParse(json['last_period_start'].toString())
          : null,
      nextPeriodEstimate: json['next_period_estimate'] != null
          ? DateTime.tryParse(json['next_period_estimate'].toString())
          : null,
      nextOvulationEstimate: json['next_ovulation_estimate'] != null
          ? DateTime.tryParse(json['next_ovulation_estimate'].toString())
          : null,
      events: json['events'] != null
          ? (json['events'] as List).map((e) => CycleEvent.fromJson(e)).toList()
          : [],
      predictions: json['predictions'] != null
          ? List<Map<String, dynamic>>.from(json['predictions'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'average_cycle_length': averageCycleLength,
      'average_period_length': averagePeriodLength,
      'last_period_start': lastPeriodStart?.toIso8601String(),
      'next_period_estimate': nextPeriodEstimate?.toIso8601String(),
      'next_ovulation_estimate': nextOvulationEstimate?.toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
      'predictions': predictions,
    };
  }
}

class ShelfItem {
  final String id;
  final String userId;
  final String? productId;
  final String name;
  final String? brand;
  final String? imageUrl;
  final DateTime? openedDate;
  final DateTime? expiryDate;
  final int? estimatedDaysLeft;
  final bool autoSwapEnabled;
  final Product? product;

  ShelfItem({
    required this.id,
    required this.userId,
    this.productId,
    required this.name,
    this.brand,
    this.imageUrl,
    this.openedDate,
    this.expiryDate,
    this.estimatedDaysLeft,
    this.autoSwapEnabled = false,
    this.product,
  });

  factory ShelfItem.fromJson(Map<String, dynamic> json) {
    return ShelfItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      productId: json['product_id']?.toString(),
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString(),
      imageUrl: json['image_url']?.toString(),
      openedDate: json['opened_date'] != null
          ? DateTime.tryParse(json['opened_date'].toString())
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'].toString())
          : null,
      estimatedDaysLeft: json['estimated_days_left'],
      autoSwapEnabled: json['auto_swap_enabled'] ?? false,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'name': name,
      'brand': brand,
      'image_url': imageUrl,
      'opened_date': openedDate?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'estimated_days_left': estimatedDaysLeft,
      'auto_swap_enabled': autoSwapEnabled,
      'product': product?.toJson(),
    };
  }
}

class Product {
  final String id;
  final String name;
  final String? brand;
  final String? description;
  final String? imageUrl;
  final double price;
  final String? currency;
  final String? category;
  final List<String>? ingredients;
  final double? rating;
  final int? reviewCount;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    this.brand,
    this.description,
    this.imageUrl,
    this.price = 0,
    this.currency,
    this.category,
    this.ingredients,
    this.rating,
    this.reviewCount,
    this.inStock = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      brand: json['brand']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString(),
      category: json['category']?.toString(),
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'],
      inStock: json['in_stock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'currency': currency,
      'category': category,
      'ingredients': ingredients,
      'rating': rating,
      'review_count': reviewCount,
      'in_stock': inStock,
    };
  }
}

class Routine {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? timeOfDay;
  final List<RoutineStep> steps;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Routine({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.timeOfDay,
    this.steps = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      timeOfDay: json['time_of_day']?.toString(),
      steps: json['steps'] != null
          ? (json['steps'] as List).map((e) => RoutineStep.fromJson(e)).toList()
          : [],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'time_of_day': timeOfDay,
      'steps': steps.map((e) => e.toJson()).toList(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class RoutineStep {
  final String id;
  final String routineId;
  final String name;
  final String? description;
  final int order;
  final int durationSeconds;
  final String? productId;
  final String? imageUrl;
  final bool isCompleted;

  RoutineStep({
    required this.id,
    required this.routineId,
    required this.name,
    this.description,
    this.order = 0,
    this.durationSeconds = 0,
    this.productId,
    this.imageUrl,
    this.isCompleted = false,
  });

  factory RoutineStep.fromJson(Map<String, dynamic> json) {
    return RoutineStep(
      id: json['id']?.toString() ?? '',
      routineId: json['routine_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      order: json['order'] ?? 0,
      durationSeconds: json['duration_seconds'] ?? 0,
      productId: json['product_id']?.toString(),
      imageUrl: json['image_url']?.toString(),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routine_id': routineId,
      'name': name,
      'description': description,
      'order': order,
      'duration_seconds': durationSeconds,
      'product_id': productId,
      'image_url': imageUrl,
      'is_completed': isCompleted,
    };
  }
}

class RoutineIntervention {
  final String id;
  final String type;
  final String title;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool dismissed;
  final DateTime createdAt;

  RoutineIntervention({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    this.imageUrl,
    this.data,
    this.dismissed = false,
    required this.createdAt,
  });

  factory RoutineIntervention.fromJson(Map<String, dynamic> json) {
    return RoutineIntervention(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      dismissed: json['dismissed'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'data': data,
      'dismissed': dismissed,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Insight {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? summary;
  final Map<String, dynamic>? data;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime createdAt;

  Insight({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.summary,
    this.data,
    required this.periodStart,
    required this.periodEnd,
    required this.createdAt,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      periodStart: DateTime.tryParse(json['period_start']?.toString() ?? '') ?? DateTime.now(),
      periodEnd: DateTime.tryParse(json['period_end']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'summary': summary,
      'data': data,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class BiweeklyInsight extends Insight {
  BiweeklyInsight({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    super.summary,
    super.data,
    required super.periodStart,
    required super.periodEnd,
    required super.createdAt,
  });

  factory BiweeklyInsight.fromJson(Map<String, dynamic> json) {
    return BiweeklyInsight(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'biweekly',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      periodStart: DateTime.tryParse(json['period_start']?.toString() ?? '') ?? DateTime.now(),
      periodEnd: DateTime.tryParse(json['period_end']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class MonthlyInsight extends Insight {
  MonthlyInsight({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    super.summary,
    super.data,
    required super.periodStart,
    required super.periodEnd,
    required super.createdAt,
  });

  factory MonthlyInsight.fromJson(Map<String, dynamic> json) {
    return MonthlyInsight(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'monthly',
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      periodStart: DateTime.tryParse(json['period_start']?.toString() ?? '') ?? DateTime.now(),
      periodEnd: DateTime.tryParse(json['period_end']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class PulseFeedItem {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? body;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final bool read;
  final DateTime createdAt;

  PulseFeedItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.body,
    this.imageUrl,
    this.metadata,
    this.read = false,
    required this.createdAt,
  });

  factory PulseFeedItem.fromJson(Map<String, dynamic> json) {
    return PulseFeedItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      imageUrl: json['image_url']?.toString(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      read: json['read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'metadata': metadata,
      'read': read,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class EnvironmentalData {
  final String id;
  final String userId;
  final double? uvIndex;
  final int? humidity;
  final double? temperature;
  final String? airQuality;
  final String? pollenCount;
  final DateTime recordedAt;

  EnvironmentalData({
    required this.id,
    required this.userId,
    this.uvIndex,
    this.humidity,
    this.temperature,
    this.airQuality,
    this.pollenCount,
    required this.recordedAt,
  });

  factory EnvironmentalData.fromJson(Map<String, dynamic> json) {
    return EnvironmentalData(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      uvIndex: (json['uv_index'] as num?)?.toDouble(),
      humidity: json['humidity'],
      temperature: (json['temperature'] as num?)?.toDouble(),
      airQuality: json['air_quality']?.toString(),
      pollenCount: json['pollen_count']?.toString(),
      recordedAt: DateTime.tryParse(json['recorded_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'uv_index': uvIndex,
      'humidity': humidity,
      'temperature': temperature,
      'air_quality': airQuality,
      'pollen_count': pollenCount,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String? currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    this.items = const [],
    this.totalAmount = 0,
    this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      items: json['items'] != null
          ? (json['items'] as List).map((e) => CartItem.fromJson(e)).toList()
          : [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CartItem {
  final String id;
  final String cartId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Product? product;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    this.quantity = 1,
    this.unitPrice = 0,
    this.totalPrice = 0,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      cartId: json['cart_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product': product?.toJson(),
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String status;
  final double totalAmount;
  final String? currency;
  final String? shippingAddress;
  final List<OrderItem> items;
  final Payment? payment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.status,
    this.totalAmount = 0,
    this.currency,
    this.shippingAddress,
    this.items = const [],
    this.payment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString(),
      shippingAddress: json['shipping_address']?.toString(),
      items: json['items'] != null
          ? (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList()
          : [],
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
      'shipping_address': shippingAddress,
      'items': items.map((e) => e.toJson()).toList(),
      'payment': payment?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Product? product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    this.quantity = 1,
    this.unitPrice = 0,
    this.totalPrice = 0,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product': product?.toJson(),
    };
  }
}

class Payment {
  final String id;
  final String orderId;
  final String method;
  final String status;
  final double amount;
  final String? currency;
  final String? reference;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.orderId,
    required this.method,
    required this.status,
    this.amount = 0,
    this.currency,
    this.reference,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString(),
      reference: json['reference']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'method': method,
      'status': status,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CreditBalance {
  final String userId;
  final int totalCredits;
  final int availableCredits;
  final int pendingCredits;
  final DateTime updatedAt;

  CreditBalance({
    required this.userId,
    this.totalCredits = 0,
    this.availableCredits = 0,
    this.pendingCredits = 0,
    required this.updatedAt,
  });

  factory CreditBalance.fromJson(Map<String, dynamic> json) {
    return CreditBalance(
      userId: json['user_id']?.toString() ?? '',
      totalCredits: json['total_credits'] ?? 0,
      availableCredits: json['available_credits'] ?? 0,
      pendingCredits: json['pending_credits'] ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_credits': totalCredits,
      'available_credits': availableCredits,
      'pending_credits': pendingCredits,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CreditTransaction {
  final String id;
  final String userId;
  final String type;
  final int amount;
  final String? description;
  final DateTime createdAt;

  CreditTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  factory CreditTransaction.fromJson(Map<String, dynamic> json) {
    return CreditTransaction(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      description: json['description']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Notification {
  final String id;
  final String userId;
  final String title;
  final String? body;
  final String? type;
  final bool read;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    this.body,
    this.type,
    this.read = false,
    this.data,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      type: json['type']?.toString(),
      read: json['read'] ?? false,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'read': read,
      'data': data,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SupportTicket {
  final String id;
  final String userId;
  final String subject;
  final String status;
  final String priority;
  final String? category;
  final List<SupportMessage>? messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.status,
    this.priority = 'normal',
    this.category,
    this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      priority: json['priority']?.toString() ?? 'normal',
      category: json['category']?.toString(),
      messages: json['messages'] != null
          ? (json['messages'] as List).map((e) => SupportMessage.fromJson(e)).toList()
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'status': status,
      'priority': priority,
      'category': category,
      'messages': messages?.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class SupportMessage {
  final String id;
  final String ticketId;
  final String senderId;
  final String senderType;
  final String content;
  final DateTime createdAt;

  SupportMessage({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderType,
    required this.content,
    required this.createdAt,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id']?.toString() ?? '',
      ticketId: json['ticket_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'sender_id': senderId,
      'sender_type': senderType,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String practitionerId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String status;
  final String? notes;
  final Service? service;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.practitionerId,
    required this.scheduledAt,
    this.durationMinutes = 60,
    required this.status,
    this.notes,
    this.service,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString() ?? '',
      practitionerId: json['practitioner_id']?.toString() ?? '',
      scheduledAt: DateTime.tryParse(json['scheduled_at']?.toString() ?? '') ?? DateTime.now(),
      durationMinutes: json['duration_minutes'] ?? 60,
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString(),
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'practitioner_id': practitionerId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'status': status,
      'notes': notes,
      'service': service?.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Service {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? currency;
  final int durationMinutes;
  final String? category;
  final String? imageUrl;
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    this.description,
    this.price = 0,
    this.currency,
    this.durationMinutes = 60,
    this.category,
    this.imageUrl,
    this.isActive = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString(),
      durationMinutes: json['duration_minutes'] ?? 60,
      category: json['category']?.toString(),
      imageUrl: json['image_url']?.toString(),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'duration_minutes': durationMinutes,
      'category': category,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}

class PractitionerClient {
  final String userId;
  final String userName;
  final String? userEmail;
  final DateTime registeredAt;
  final Map<String, dynamic>? latestCheckin;
  final Map<String, dynamic>? skinSummary;
  final List<String>? activeRoutines;

  PractitionerClient({
    required this.userId,
    required this.userName,
    this.userEmail,
    required this.registeredAt,
    this.latestCheckin,
    this.skinSummary,
    this.activeRoutines,
  });

  factory PractitionerClient.fromJson(Map<String, dynamic> json) {
    return PractitionerClient(
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      userEmail: json['user_email']?.toString(),
      registeredAt: DateTime.tryParse(json['registered_at']?.toString() ?? '') ?? DateTime.now(),
      latestCheckin: json['latest_checkin'] as Map<String, dynamic>?,
      skinSummary: json['skin_summary'] as Map<String, dynamic>?,
      activeRoutines: json['active_routines'] != null
          ? List<String>.from(json['active_routines'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'registered_at': registeredAt.toIso8601String(),
      'latest_checkin': latestCheckin,
      'skin_summary': skinSummary,
      'active_routines': activeRoutines,
    };
  }
}

class TreatmentSession {
  final String id;
  final String practitionerId;
  final String clientId;
  final String? bookingId;
  final String? protocol;
  final String? notes;
  final Map<String, dynamic>? observations;
  final DateTime sessionDate;
  final int durationMinutes;
  final DateTime createdAt;

  TreatmentSession({
    required this.id,
    required this.practitionerId,
    required this.clientId,
    this.bookingId,
    this.protocol,
    this.notes,
    this.observations,
    required this.sessionDate,
    this.durationMinutes = 60,
    required this.createdAt,
  });

  factory TreatmentSession.fromJson(Map<String, dynamic> json) {
    return TreatmentSession(
      id: json['id']?.toString() ?? '',
      practitionerId: json['practitioner_id']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '',
      bookingId: json['booking_id']?.toString(),
      protocol: json['protocol']?.toString(),
      notes: json['notes']?.toString(),
      observations: json['observations'] as Map<String, dynamic>?,
      sessionDate: DateTime.tryParse(json['session_date']?.toString() ?? '') ?? DateTime.now(),
      durationMinutes: json['duration_minutes'] ?? 60,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'practitioner_id': practitionerId,
      'client_id': clientId,
      'booking_id': bookingId,
      'protocol': protocol,
      'notes': notes,
      'observations': observations,
      'session_date': sessionDate.toIso8601String(),
      'duration_minutes': durationMinutes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
