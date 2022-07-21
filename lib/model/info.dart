// ignore_for_file: non_constant_identifier_names

class Information {
  String first_name;
  String last_name;
  String email;

  Information(
    this.first_name,
    this.last_name,
    this.email,
  );

  factory Information.fromJson(dynamic json) {
    return Information(
      "${json['First Name']}",
      "${json['Last Name']}",
      "${json['Email']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
      };
}
