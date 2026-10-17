
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
      elevation: 3,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
              children: _skills
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
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
      elevation: 3,
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
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter your name'
                        : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
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
                validator: (value) =>
                    value == null ||
                            value.split(',').every(
                                  (skill) => skill.trim().isEmpty,
                                )
                        ? 'Please enter at least one skill'
                        : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _aboutController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'About Me',
                  hintText: 'Write a short introduction',
                ),
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
  final String title;
  final String description;
  final String technology;

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

  void _addProject() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _projects.add(
        PortfolioProject(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          technology: _technologyController.text.trim(),
        ),
      );
    });

    _titleController.clear();
    _descriptionController.clear();
    _technologyController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project added successfully!')),
    );
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
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a New Project',
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
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
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
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? 'Enter a project description'
                                        : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _technologyController,
                                decoration: const InputDecoration(
                                  labelText: 'Technology Used',
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? 'Enter a technology'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: _addProject,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Project'),
                                ),
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
                    if (isWide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 175,
                        ),
                        itemCount: _projects.length,
                        itemBuilder: (context, index) =>
                            _buildProjectCard(_projects[index]),
                      )
                    else
                      ..._projects.map(_buildProjectCard),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectCard(PortfolioProject project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.folder_special, size: 30),
            const SizedBox(height: 8),
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Chip(
              label: Text(project.technology),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

