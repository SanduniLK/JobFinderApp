class JobField {
  static const List<String> options = [
    'Software Development',
    'Data Science',
    'DevOps',
    'Cloud Computing',
    'Cybersecurity',
    'Mobile Development',
    'Frontend Development',
    'Backend Development',
    'Full Stack Development',
    'UI/UX Design',
    'Product Management',
    'Project Management',
    'Quality Assurance',
    'Technical Support',
    'IT Administration',
    'Database Administration',
    'Network Engineering',
    'Systems Architecture',
    'Business Intelligence',
    'Machine Learning',
  ];
}

class JobTitle {
  static const List<String> options = [
    'Software Engineer',
    'Senior Software Engineer',
    'Lead Developer',
    'Technical Lead',
    'Engineering Manager',
    'Data Scientist',
    'DevOps Engineer',
    'Cloud Architect',
    'Security Engineer',
    'Mobile Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'UI/UX Designer',
    'Product Owner',
    'Scrum Master',
    'QA Engineer',
    'IT Support Specialist',
    'System Administrator',
    'Database Administrator',
    'Network Administrator',
    'Business Analyst',
    'Project Manager',
    'Product Manager',
    'Technical Writer',
  ];
}

class WorkMode {
  static const String remote = 'Remote';
  static const String hybrid = 'Hybrid';
  static const String onSite = 'On-site';
  
  static const List<String> options = [remote, hybrid, onSite];
  
  static String getIcon(String mode) {
    switch (mode) {
      case remote:
        return '🏠';
      case hybrid:
        return '🏢📱';
      case onSite:
        return '🏢';
      default:
        return '💼';
    }
  }
  
  static String getDescription(String mode) {
    switch (mode) {
      case remote:
        return 'Work from anywhere';
      case hybrid:
        return 'Mix of office & remote';
      case onSite:
        return 'Work from office';
      default:
        return '';
    }
  }
}