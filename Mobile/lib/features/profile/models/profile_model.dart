class ProfileModel {
  final String? name;
  final String? password;
  final String? phoneNumber;
  final String? profilePicture;

  ProfileModel({
    this.name,
    this.password,
    this.phoneNumber,
    this.profilePicture,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}
