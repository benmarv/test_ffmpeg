class MyJobModel {
  MyJobModel({
    required this.id,
    required this.userId,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobLocation,
    required this.lat,
    required this.lon,
    required this.salaryDate,
    required this.currency,
    required this.minimumSalary,
    required this.maximumSalary,
    required this.jobType,
    required this.category,
    required this.companyName,
    required this.isUrgentHiring,
    required this.experienceYears,
    required this.expiryDate,
    required this.jobImage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.isApplied,
  });

  final String? id;
  final String? userId;
  final String? jobTitle;
  final String? jobDescription;
  final String? jobLocation;
  final dynamic lat;
  final dynamic lon;
  final String? salaryDate;
  final String? currency;
  final String? minimumSalary;
  final String? maximumSalary;
  final String? jobType;
  final String? category;
  final String? companyName;
  final dynamic isUrgentHiring;
  final String? experienceYears;
  final dynamic expiryDate;
  final String? jobImage;
  final String? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isApplied;
  factory MyJobModel.fromJson(Map<String, dynamic> json) {
    return MyJobModel(
        id: json["id"],
        userId: json["user_id"],
        jobTitle: json["job_title"],
        jobDescription: json["job_description"],
        jobLocation: json["job_location"],
        lat: json["lat"],
        lon: json["lon"],
        salaryDate: json["salary_date"],
        currency: json["currency"],
        minimumSalary: json["minimum_salary"],
        maximumSalary: json["maximum_salary"],
        jobType: json["job_type"],
        category: json["category"],
        companyName: json["company_name"],
        isUrgentHiring: json["is_urgent_hiring"],
        experienceYears: json["experience_years"],
        expiryDate: json["expiry_date"],
        jobImage: json["job_image"],
        isActive: json["is_active"],
        isApplied: json['is_applied'] ?? false,
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ""));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "job_title": jobTitle,
        "job_description": jobDescription,
        "job_location": jobLocation,
        "lat": lat,
        "lon": lon,
        "salary_date": salaryDate,
        "currency": currency,
        "minimum_salary": minimumSalary,
        "maximum_salary": maximumSalary,
        "job_type": jobType,
        "category": category,
        "company_name": companyName,
        "is_urgent_hiring": isUrgentHiring,
        "experience_years": experienceYears,
        "expiry_date": expiryDate,
        "job_image": jobImage,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        'is_applied': isApplied
      };
}
