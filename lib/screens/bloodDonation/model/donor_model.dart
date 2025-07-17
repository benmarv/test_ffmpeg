class DonorModel {
  DonorModel({
    required this.id,
    required this.isVerified,
    required this.username,
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.avatar,
    required this.cover,
    required this.gender,
    required this.level,
    required this.role,
    required this.bloodGroup,
    required this.donationDate,
    required this.address,
    required this.donationAvailable,
    required this.phoneNumber,
    required this.dateOfBirth,
  });

  final String? id;
  final String? isVerified;
  final String? username;
  final String? firstName;
  final String? email;
  final String? lastName;
  final String? avatar;
  final String? cover;
  final String? gender;
  final String? level;
  final String? role;
  final String? bloodGroup;
  final dynamic donationDate;
  final String? address;
  final String? donationAvailable;
  final String? phoneNumber;
  final String? dateOfBirth;

  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      id: json["id"],
      isVerified: json["is_verified"],
      username: json["username"],
      firstName: json["first_name"],
      email: json["email"],
      lastName: json["last_name"],
      avatar: json["avatar"],
      cover: json["cover"],
      gender: json["gender"],
      level: json["level"],
      role: json["role"],
      bloodGroup: json["blood_group"],
      donationDate: json["donation_date"],
      address: json["address"],
      donationAvailable: json["donation_available"],
      phoneNumber: json["phone"],
      dateOfBirth: json["date_of_birth"],
    );
  }
}
