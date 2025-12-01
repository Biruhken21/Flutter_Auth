class Startup {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final String industry;
  final String stage;
  final List<String> founders;

  Startup({
    required this.id,
    required this.name,
    required this.description,
    this.logoUrl,
    required this.industry,
    required this.stage,
    this.founders = const [],
  });

  factory Startup.fromJson(Map<String, dynamic> json) {
    return Startup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
      industry: json['industry'] as String,
      stage: json['stage'] as String,
      founders: List<String>.from(json['founders'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'industry': industry,
      'stage': stage,
      'founders': founders,
    };
  }
}
