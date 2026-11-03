class ProjectsData {
  const ProjectsData({
    required this.projectName,
    required this.projectType,
    required this.durationWork,
    required this.stack,
    required this.description,
    this.photos = const <String>[],
    this.logoAsset,
  });

  final String projectName;

  final String projectType;

  final String durationWork;

  final String stack;

  final String description;

  final List<String> photos;

  final String? logoAsset;

  factory ProjectsData.fromJson(Map<String, dynamic> json) => ProjectsData(
        projectName: json['project_name'] as String,
        projectType: json['project_type'] as String,
        durationWork: json['duration_work'] as String,
        stack: json['stack'] as String,
        description: json['description'] as String,
        photos: (json['photos'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .toList(),
        logoAsset: json['logo_url'] as String?,
      );
}

const List<ProjectsData> projects = <ProjectsData>[
  ProjectsData(
    projectName: 'Financial Memo (FIMO)',
    projectType: 'web-app project',
    durationWork: '5 weeks',
    stack: 'Next.js, Supabase, Shadcn',
    logoAsset: 'assets/fimo.png',
    description: 'Fimo is a digital financial memo, tracking and planning application equipped with AI features powered by Gemini & Claude, designed to help users manage cash flow, create category-based budgets, and conveniently evaluate their monthly financial health.',
    photos: ['assets/project-fimo-light.png', 'assets/project-fimo-dark.png'],
  ),
];
