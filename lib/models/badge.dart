class Badge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final int? requiredScore;
  final String? game;
  final int? requiredDays;
  final int? requiredGames;

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.requiredScore,
    this.game,
    this.requiredDays,
    this.requiredGames,
  });

  Badge copyWith({
    bool? isUnlocked,
  }) {
    return Badge(
      id: id,
      title: title,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      requiredScore: requiredScore,
      game: game,
      requiredDays: requiredDays,
      requiredGames: requiredGames,
    );
  }
}