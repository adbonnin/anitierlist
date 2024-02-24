enum Gender {
  male,
  female,
  other;

  static Gender fromGraphql(String? gender) {
    return switch (gender) {
      "Male" => male,
      "Female" => female,
      _ => other,
    };
  }
}
