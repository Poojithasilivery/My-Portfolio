

import 'package:flutter/material.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();
  final _skillsController = TextEditingController();
  final _aboutController = TextEditingController();

  String _name = 'Your Name';
  String _email = 'your.email@example.com';
  String _course = 'Your Course';
  String _skills = 'Flutter, Dart';
  String _about = 'Welcome to my portfolio!';

  void _saveDetails() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _name = _nameController.text.trim();
      _email = _emailController.text.trim();
      _course = _courseController.text.trim();
      _skills = _skillsController.text.trim();
      _about = _aboutController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _skillsController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Widget _buildProfilePreview() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 42,
                child: Icon(Icons.person, size: 48),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Center(child: Text(_course)),
            const Divider(height: 28),
            const Text(
              'About Me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(_about),
            const SizedBox(height: 16),
            const Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_email),
            const SizedBox(height: 16),
            const Text(
              'Skills',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .split(',')
                  .map((skill) => skill.trim())
                  .where((skill) => skill.isNotEmpty)
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.folder_open),
                label: const Text('View My Projects'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Course / Qualification',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your course'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills',
                  hintText: 'Flutter, Dart, SQL',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your skills'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _aboutController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'About Me',
                  prefixIcon: Icon(Icons.info_outline),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a short description'
                    : null,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveDetails,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to My Portfolio',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Update your personal information and showcase your work.',
                    ),
                    const SizedBox(height: 24),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildProfilePreview()),
                          const SizedBox(width: 20),
                          Expanded(child: _buildProfileForm()),
                        ],
                      )
                    else ...[
                      _buildProfilePreview(),
                      const SizedBox(height: 20),
                      _buildProfileForm(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PortfolioProject {
  String title;
  String description;
  String technology;

  PortfolioProject({
    required this.title,
    required this.description,
    required this.technology,
  });
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologyController = TextEditingController();
  final _searchController = TextEditingController();

  int? _editingIndex;

  final List<PortfolioProject> _projects = [
    PortfolioProject(
      title: 'Portfolio Website',
      description: 'A personal portfolio built to showcase my skills.',
      technology: 'Flutter, Dart',
    ),
    PortfolioProject(
      title: 'Student Management System',
      description: 'An application to manage student information.',
      technology: 'Java, MySQL',
    ),
    PortfolioProject(
      title: 'Data Analytics Project',
      description: 'Analysed data to discover useful patterns and trends.',
      technology: 'Python, Pandas',
    ),
  ];

  List<PortfolioProject> get _filteredProjects {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _projects;

    return _projects.where((project) {
      return project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.technology.toLowerCase().contains(query);
    }).toList();
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

    final isEditing = _editingIndex != null;

    setState(() {
      final project = PortfolioProject(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        technology: _technologyController.text.trim(),
      );

      if (_editingIndex == null) {
        _projects.add(project);
      } else {
        _projects[_editingIndex!] = project;
      }

      _clearForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing ? 'Project updated successfully!' : 'Project added successfully!',
        ),
      ),
    );
  }

  void _editProject(PortfolioProject project) {
    setState(() {
      _editingIndex = _projects.indexOf(project);
      _titleController.text = project.title;
      _descriptionController.text = project.description;
      _technologyController.text = project.technology;
    });

    Scrollable.ensureVisible(
      _formKey.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _technologyController.clear();
    _editingIndex = null;
    _formKey.currentState?.reset();
  }

  Future<void> _deleteProject(int index) async {
    final project = _projects[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Project?'),
          content: Text(
            'Are you sure you want to delete "${project.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _projects.remove(project);

      if (_editingIndex == index) {
        _clearForm();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${project.title} deleted successfully')),
    );
  }

  Widget _buildProjectForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _editingIndex == null ? 'Add a Project' : 'Edit Project',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a project title'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _technologyController,
                decoration: const InputDecoration(
                  labelText: 'Technologies',
                  hintText: 'Flutter, Dart',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter the technologies used'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saveProject,
                      icon: Icon(
                        _editingIndex == null ? Icons.add : Icons.save,
                      ),
                      label: Text(
                        _editingIndex == null ? 'Add Project' : 'Update Project',
                      ),
                    ),
                  ),
                  if (_editingIndex != null) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(_clearForm);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(PortfolioProject project) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.folder_special, size: 34),
            const SizedBox(height: 12),
            Text(
              project.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(project.description),
            const SizedBox(height: 10),
            Text(
              'Technologies: ${project.technology}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: () => _editProject(project),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteProject(_projects.indexOf(project)),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _technologyController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProjects = _filteredProjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage My Projects',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Total projects: ${_projects.length}'),
                    const SizedBox(height: 20),

                    // Commit 9: Search projects by title, description, or technology.
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Search projects',
                        hintText: 'Enter title, description, or technology',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                tooltip: 'Clear search',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildProjectForm(),
                    const SizedBox(height: 24),

                    Text(
                      'Projects (${visibleProjects.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    if (visibleProjects.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              _projects.isEmpty
                                  ? 'No projects yet. Add your first project!'
                                  : 'No projects match "${_searchController.text}".',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    else if (isWide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleProjects.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 260,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) =>
                            _buildProjectCard(visibleProjects[index]),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleProjects.length,
                        itemBuilder: (context, index) =>
                            _buildProjectCard(visibleProjects[index]),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
