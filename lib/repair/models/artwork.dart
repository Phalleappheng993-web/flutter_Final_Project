class Artwork {
  const Artwork({
    required this.prompt,
    required this.style,
    required this.createdAt,
    required this.seed,
  });
  final String prompt;
  final String style;
  final DateTime createdAt;
  final int seed;
}
