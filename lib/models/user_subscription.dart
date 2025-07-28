import 'package:hive/hive.dart';

part 'user_subscription.g.dart';

@HiveType(typeId: 1)
class UserSubscription {
  @HiveField(0)
  final bool isPremium;

  @HiveField(1)
  final DateTime? subscriptionStart;

  @HiveField(2)
  final DateTime? subscriptionEnd;

  @HiveField(3)
  final String subscriptionType;

  @HiveField(4)
  final bool isTrialActive;

  @HiveField(5)
  final DateTime? trialEnd;

  @HiveField(6)
  final List<String> purchasedThemes;

  @HiveField(7)
  final List<String> purchasedFeatures;

  @HiveField(8)
  final int maxHabits;

  @HiveField(9)
  final bool adsRemoved;

  @HiveField(10)
  final DateTime? lastPurchaseDate;

  const UserSubscription({
    required this.isPremium,
    this.subscriptionStart,
    this.subscriptionEnd,
    required this.subscriptionType,
    required this.isTrialActive,
    this.trialEnd,
    required this.purchasedThemes,
    required this.purchasedFeatures,
    required this.maxHabits,
    required this.adsRemoved,
    this.lastPurchaseDate,
  });

  // Factory constructor for creating a default free subscription
  factory UserSubscription.free() {
    return const UserSubscription(
      isPremium: false,
      subscriptionType: 'free',
      isTrialActive: false,
      purchasedThemes: [],
      purchasedFeatures: [],
      maxHabits: 3, // Free users can have up to 3 habits
      adsRemoved: false,
    );
  }

  // Factory constructor for creating a premium subscription
  factory UserSubscription.premium({
    required DateTime subscriptionStart,
    required DateTime subscriptionEnd,
    required String subscriptionType,
    List<String> purchasedThemes = const [],
    List<String> purchasedFeatures = const [],
    int maxHabits = -1, // -1 means unlimited
    bool adsRemoved = true,
    DateTime? lastPurchaseDate,
  }) {
    return UserSubscription(
      isPremium: true,
      subscriptionStart: subscriptionStart,
      subscriptionEnd: subscriptionEnd,
      subscriptionType: subscriptionType,
      isTrialActive: false,
      purchasedThemes: purchasedThemes,
      purchasedFeatures: purchasedFeatures,
      maxHabits: maxHabits,
      adsRemoved: adsRemoved,
      lastPurchaseDate: lastPurchaseDate,
    );
  }

  // Factory constructor for creating a trial subscription
  factory UserSubscription.trial({
    required DateTime trialEnd,
    List<String> purchasedThemes = const [],
    List<String> purchasedFeatures = const [],
    int maxHabits = -1, // -1 means unlimited during trial
  }) {
    return UserSubscription(
      isPremium: true,
      subscriptionType: 'trial',
      isTrialActive: true,
      trialEnd: trialEnd,
      purchasedThemes: purchasedThemes,
      purchasedFeatures: purchasedFeatures,
      maxHabits: maxHabits,
      adsRemoved: true,
    );
  }

  // Copy with method for updating subscription
  UserSubscription copyWith({
    bool? isPremium,
    DateTime? subscriptionStart,
    DateTime? subscriptionEnd,
    String? subscriptionType,
    bool? isTrialActive,
    DateTime? trialEnd,
    List<String>? purchasedThemes,
    List<String>? purchasedFeatures,
    int? maxHabits,
    bool? adsRemoved,
    DateTime? lastPurchaseDate,
  }) {
    return UserSubscription(
      isPremium: isPremium ?? this.isPremium,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      isTrialActive: isTrialActive ?? this.isTrialActive,
      trialEnd: trialEnd ?? this.trialEnd,
      purchasedThemes: purchasedThemes ?? this.purchasedThemes,
      purchasedFeatures: purchasedFeatures ?? this.purchasedFeatures,
      maxHabits: maxHabits ?? this.maxHabits,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
    );
  }

  // Check if subscription is active
  bool get isActive {
    if (isTrialActive && trialEnd != null) {
      return DateTime.now().isBefore(trialEnd!);
    }
    if (isPremium && subscriptionEnd != null) {
      return DateTime.now().isBefore(subscriptionEnd!);
    }
    return isPremium;
  }

  // Check if user has unlimited habits
  bool get hasUnlimitedHabits => maxHabits == -1;

  // Check if user can create more habits
  bool canCreateHabits(int currentHabitCount) {
    if (hasUnlimitedHabits) return true;
    return currentHabitCount < maxHabits;
  }

  @override
  String toString() {
    return 'UserSubscription('
        'isPremium: $isPremium, '
        'subscriptionType: $subscriptionType, '
        'isTrialActive: $isTrialActive, '
        'maxHabits: $maxHabits, '
        'adsRemoved: $adsRemoved'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserSubscription &&
      other.isPremium == isPremium &&
      other.subscriptionStart == subscriptionStart &&
      other.subscriptionEnd == subscriptionEnd &&
      other.subscriptionType == subscriptionType &&
      other.isTrialActive == isTrialActive &&
      other.trialEnd == trialEnd &&
      other.purchasedThemes.toString() == purchasedThemes.toString() &&
      other.purchasedFeatures.toString() == purchasedFeatures.toString() &&
      other.maxHabits == maxHabits &&
      other.adsRemoved == adsRemoved &&
      other.lastPurchaseDate == lastPurchaseDate;
  }

  @override
  int get hashCode {
    return isPremium.hashCode ^
      subscriptionStart.hashCode ^
      subscriptionEnd.hashCode ^
      subscriptionType.hashCode ^
      isTrialActive.hashCode ^
      trialEnd.hashCode ^
      purchasedThemes.hashCode ^
      purchasedFeatures.hashCode ^
      maxHabits.hashCode ^
      adsRemoved.hashCode ^
      lastPurchaseDate.hashCode;
  }
}
