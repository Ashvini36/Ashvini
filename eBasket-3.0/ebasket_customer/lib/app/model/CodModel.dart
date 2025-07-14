class CodModel {
  bool isEnabled;

  CodModel({
    this.isEnabled = false,
  });

  factory CodModel.fromJson(Map<String, dynamic> parsedJson) {
    return CodModel(
      isEnabled: parsedJson['isEnabled'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
    };
  }
}
