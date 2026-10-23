
import 'package:flutter/material.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
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
  String _about = 'Add a short introduction about yourself.';
  List<String> _skills = ['Flutter', 'Dart', 'UI Design'];

  void _saveDetails() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _name = _nameController.text.trim();
      _email = _emailController.text.trim();
      _course = _courseController.text.trim();
      _about = _aboutController.text.trim().isEmpty
          ? 'No introduction added yet.'
          : _aboutController.text.trim();
      _skills = _skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
            tooltip: 'View Projects',
            icon: const Icon(Icons.folder_open),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectsPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;
          final preview = _buildProfilePreview();
          final form = _buildProfileForm();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: preview),
                          const SizedBox(width: 24),
                          Expanded(child: form),
                        ],
                      )
                    : Column(
                        children: [
                          preview,
                          const SizedBox(height: 24),
                          form,
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _course,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 32),
            const Text(
              'About Me',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_about),
            const SizedBox(height: 20),
            const Text(
              'Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(_email)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((s) => Chip(label: Text(s))).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProjectsPage(),
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
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Your Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(v.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Please enter your course'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills',
                  hintText: 'Flutter, Dart, UI Design',
                  helperText: 'Separate skills with commas',
                ),
                validator: (v) =>
                    v == null ||
                            v.split(',').every((s) => s.trim().isEmpty)
                        ? 'Please enter at least one skill'
                        : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _aboutController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'About Me'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saveDetails,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Details'),
                ),
              ),
            ],
          ),
        ),
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

  final List<PortfolioProject> _projects = [
    PortfolioProject(
      title: 'Portfolio Website',
      description: 'A personal portfolio built with Flutter.',
      technology: 'Flutter',
    ),
    PortfolioProject(
      title: 'Student Management System',
      description: 'An application to manage student records.',
      technology: 'Dart',
    ),
    PortfolioProject(
      title: 'Data Analytics Dashboard',
      description: 'A dashboard to display useful data insights.',
      technology: 'Python',
    ),
  ];

  int? _editingIndex;

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

    final wasEditing = _editingIndex != null;

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
          wasEditing ? 'Project updated successfully!' : 'Project added!',
        ),
      ),
    );
  }

  void _editProject(int index) {
    final project = _projects[index];

    setState(() {
      _editingIndex = index;
      _titleController.text = project.title;
      _descriptionController.text = project.description;
      _technologyController.text = project.technology;
    });
  }

  Future<void> _deleteProject(int index) async {
    final project = _projects[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _projects.removeAt(index);

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

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _technologyController.clear();
    _editingIndex = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _technologyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _editingIndex == null
                          ? 'Add a New Project'
                          : 'Edit Project',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Project Title',
                                ),
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'Enter a project title'
                                        : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  labelText: 'Project Description',
                                ),
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'Enter a description'
                                        : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _technologyController,
                                decoration: const InputDecoration(
                                  labelText: 'Technology Used',
                                ),
                                validator: (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'Enter a technology'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: _saveProject,
                                      icon: Icon(
                                        _editingIndex == null
                                            ? Icons.add
                                            : Icons.save,
                                      ),
                                      label: Text(
                                        _editingIndex == null
                                            ? 'Add Project'
                                            : 'Update Project',
                                      ),
                                    ),
                                  ),
                                  if (_editingIndex != null) ...[
                                    const SizedBox(width: 10),
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
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'My Projects (${_projects.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    if (_projects.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No projects yet. Add your first one!',
                            ),
                          ),
                        ),
                      )
                    else if (isWide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 210,
                        ),
                        itemCount: _projects.length,
                        itemBuilder: (context, index) =>
                            _buildProjectCard(index),
                      )
                    else
                      ...List.generate(
                        _projects.length,
                        (index) => _buildProjectCard(index),
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

  Widget _buildProjectCard(int index) {
    final project = _projects[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_special, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(label: Text(project.technology)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _editProject(index),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteProject(index),
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
}

