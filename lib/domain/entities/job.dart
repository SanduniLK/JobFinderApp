class Job {
  final int? id;
  final String title;
  final String company;
  final String department;
  final String jobType;
  final String? salary;
  final String location;
  final String description;
  final String? requirements;
  final String? postedBy;
  final String? createdAt;

  Job({
    this.id,
    required this.title,
    required this.company,
    required this.department,
    required this.jobType,
    this.salary,
    required this.location,
    required this.description,
    this.requirements,
    this.postedBy,
    this.createdAt,
  });
}