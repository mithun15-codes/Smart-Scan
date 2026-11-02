class TeamMember {
  final String name;
  final String role;
  final String bio;
  final String? imageAsset;

  const TeamMember({
    required this.name,
    required this.role,
    required this.bio,
    this.imageAsset,
  });

  static const List<TeamMember> team = [
    TeamMember(
      name: 'ABIN B',
      role: 'AI Model Training Expert',
      bio: 'AI & DS STUDENT, AI Model training expert specializing in deep learning architectures.',
      imageAsset: 'assets/team/abin.jpg',
    ),
    TeamMember(
      name: 'Jeswin Cheriyan PriJi',
      role: 'AI Research Lead',
      bio: 'Expert in machine learning algorithms for medical image analysis & head developer.',
      imageAsset: 'assets/team/jeswin.jpg',
    ),
    TeamMember(
      name: 'Vishnu C B',
      role: 'Software Engineer',
      bio: 'Develops the platform infrastructure and ensures seamless user experience & assistant developer.',
      imageAsset: 'assets/team/vishnu.jpg',
    ),
    TeamMember(
      name: 'U R Harikesh',
      role: 'Medical Consultant',
      bio: 'Provides clinical insights to improve diagnostic accuracy and healthcare integration.',
      imageAsset: 'assets/team/harikesh.jpg',
    ),
  ];
}

