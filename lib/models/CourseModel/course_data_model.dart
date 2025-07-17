import 'package:link_on/models/usr.dart';

class CourseModel {
  final int id;
  final String title;
  final String address;
  final bool isPaid;
  final String amount;
  final String startDate;
  final String endDate;
  final String country;
  final String cover;
  final String description;
  final String level;
  final String language;
  final String categoryId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String createdBy;
  bool isApplied;
  final Usr user;

  CourseModel({
    required this.id,
    required this.title,
    required this.address,
    required this.isPaid,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.country,
    required this.cover,
    required this.description,
    required this.level,
    required this.language,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.createdBy,
    required this.isApplied,
    required this.user,
  });

  // Factory constructor to create a CourseModel object from JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: int.parse(json['id']),
      title: json['title'],
      address: json['address'],
      isPaid: json['is_paid'] == 1,
      amount: json['amount'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      country: json['country'],
      cover: json['cover'],
      description: json['description'],
      level: json['level'],
      language: json['language'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      createdBy: json['created_by'],
      isApplied: json['is_applied'] == 1,
      user: Usr.fromJson(json['user']),
    );
  }
}
