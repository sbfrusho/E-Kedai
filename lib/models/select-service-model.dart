class SelectServiceModel {
  final bool selectService;

  SelectServiceModel({
    required this.selectService,
  });

  // Serialize the SelectServiceModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'selectService': selectService,
    };
  }

  // Create a SelectServiceModel instance from a JSON map
  factory SelectServiceModel.fromMap(Map<String, dynamic> json) {
    return SelectServiceModel(
      selectService: json['selectService'] ?? false, // Provide a default value if necessary
    );
  }
}
