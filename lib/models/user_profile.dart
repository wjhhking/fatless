class UserProfile {
  final String id;
  final String height;
  final int currentWeight;
  final int targetWeight;
  final String name;
  final String age;
  final String gender;
  final String mbti;
  final String relationshipStatus;
  final List<String> exercisePreferences;
  final List<String> dietExperience;
  final List<String> quitReasons;
  final String avatar;
  final String weightLossDeclaration;

  UserProfile({
    required this.id,
    required this.height,
    required this.currentWeight,
    required this.targetWeight,
    required this.name,
    required this.age,
    required this.gender,
    required this.mbti,
    required this.relationshipStatus,
    required this.exercisePreferences,
    required this.dietExperience,
    required this.quitReasons,
    required this.avatar,
    required this.weightLossDeclaration,
  });

  List<String> get tags {
    List<String> allTags = [];
    allTags.addAll(exercisePreferences);
    allTags.addAll(dietExperience);
    allTags.addAll(quitReasons);
    return allTags;
  }
}
