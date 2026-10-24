
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyPortfolioApp());
}

// --------------------------------------------------
// APP ROOT: SAVED LIGHT/DARK THEME
// --------------------------------------------------

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  bool _isDarkMode = false;
  bool _themeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      setState(() {
        _isDarkMode = prefs.getBool('isDarkMode') ?? false;
        _themeLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _themeLoaded = true);
    }
  }

  Future<void> _toggleTheme() async {
    final newTheme = !_isDarkMode;

    setState(() {
      _isDarkMode = newTheme;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', newTheme);
    } catch (_) {
      // The theme still changes for the current session.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: !_themeLoaded
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : PortfolioHomePage(
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
            ),
    );
  }
}

// --------------------------------------------------
// HOME PAGE: PROFILE EDITING AND LIVE PREVIEW
// --------------------------------------------------

class PortfolioHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const PortfolioHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Your Name');
  final _emailController = TextEditingController(text: 'you@example.com');
  final _courseController = TextEditingController(text: 'Flutter Developer');
  final _skillsController =
      TextEditingController(text: 'Flutter, Dart, SQL');
  final _aboutController = TextEditingController(
    text: 'Welcome to my portfolio! I enjoy building useful applications.',
  );

  String _name = 'Your Name';
  String _email = 'you@example.com';
  String _course = 'Flutter Developer';
  String _skills = 'Flutter, Dart, SQL';
  String _about =
      'Welcome to my portfolio! I enjoy building useful applications.';

  void _saveProfile() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Projects',
            icon: const Icon(Icons.work_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectsPage(
                    isDarkMode: widget.isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Contact Me',
            icon: const Icon(Icons.contact_mail_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactPage(
                    isDarkMode: widget.isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: widget.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          final profilePreview = _buildProfilePreview(context);
          final profileForm = _buildProfileForm(context);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: profilePreview),
                          const SizedBox(width: 24),
                          Expanded(child: profileForm),
                        ],
                      )
                    else ...[
                      profilePreview,
                      const SizedBox(height: 20),
                      profileForm,
                    ],
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.work_outline,
                              size: 36,
                              color: Colors.indigo,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Explore My Projects',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'View, search, add, edit, or delete projects.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProjectsPage(
                                      isDarkMode: widget.isDarkMode,
                                      onToggleTheme: widget.onToggleTheme,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('View Projects'),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ContactPage(
                                      isDarkMode: widget.isDarkMode,
                                      onToggleTheme: widget.onToggleTheme,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.mail_outline),
                              label: const Text('Contact Me'),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildProfilePreview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              _course,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 28),
            _detailRow(Icons.email_outlined, _email),
            const SizedBox(height: 12),
            _detailRow(Icons.code, _skills),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(_about),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 10),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
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
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Role or Course',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your role or course';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: 'Skills',
                  hintText: 'Flutter, Dart, SQL',
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your skills';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _aboutController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'About Me',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.info_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some information about yourself';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// PROJECT MODEL
// --------------------------------------------------

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

// --------------------------------------------------
// PROJECTS PAGE: SEARCH, ADD, EDIT, DELETE
// --------------------------------------------------

class ProjectsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ProjectsPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologyController = TextEditingController();

  int? _editingIndex;

  final List<PortfolioProject> _projects = [
    PortfolioProject(
      title: 'Portfolio Website',
      description: 'A personal portfolio to display my profile and skills.',
      technology: 'Flutter, Dart',
    ),
    PortfolioProject(
      title: 'Employee Management System',
      description: 'An application to manage employee information.',
      technology: 'Flutter, Database',
    ),
    PortfolioProject(
      title: 'Student Dashboard',
      description: 'A dashboard for viewing student information.',
      technology: 'Flutter, UI Design',
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

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _technologyController.clear();
    _editingIndex = null;
    _formKey.currentState?.reset();
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

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
          _editingIndex == null
              ? 'Project saved successfully!'
              : 'Project updated successfully!',
        ),
      ),
    );
  }

  void _editProject(PortfolioProject project) {
    final index = _projects.indexOf(project);

    setState(() {
      _editingIndex = index;
      _titleController.text = project.title;
      _descriptionController.text = project.description;
      _technologyController.text = project.technology;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit the fields and save your changes.')),
    );
  }

  Future<void> _deleteProject(PortfolioProject project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Project?'),
          content: Text('Delete "${project.title}"? This cannot be undone.'),
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
      final deletedIndex = _projects.indexOf(project);
      if (deletedIndex == -1) return;

      _projects.removeAt(deletedIndex);

      if (_editingIndex == deletedIndex) {
        _clearForm();
      } else if (_editingIndex != null &&
          _editingIndex! > deletedIndex) {
        _editingIndex = _editingIndex! - 1;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${project.title} deleted successfully')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _technologyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProjects = _filteredProjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'Contact Me',
            icon: const Icon(Icons.contact_mail_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactPage(
                    isDarkMode: widget.isDarkMode,
                    onToggleTheme: widget.onToggleTheme,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 850;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Manage Your Projects',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Total projects: ${_projects.length}'),
                    const SizedBox(height: 18),

                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Search projects',
                        hintText: 'Search title, description, or technology',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _editingIndex == null
                                    ? 'Add New Project'
                                    : 'Edit Project',
                                style:
                                    Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Project Title',
                                  prefixIcon: Icon(Icons.title),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Enter a project title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  alignLabelWithHint: true,
                                  prefixIcon: Icon(Icons.description_outlined),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _technologyController,
                                decoration: const InputDecoration(
                                  labelText: 'Technologies Used',
                                  hintText: 'Flutter, Dart, SQL',
                                  prefixIcon: Icon(Icons.code),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty) {
                                    return 'Enter the technologies used';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  FilledButton.icon(
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
                                  if (_editingIndex != null)
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(_clearForm);
                                      },
                                      child: const Text('Cancel Edit'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Projects',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    if (visibleProjects.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(28),
                        child: Center(
                          child: Text('No matching projects found.'),
                        ),
                      )
                    else if (isWide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleProjects.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 370,
                          mainAxisExtent: 255,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final project = visibleProjects[index];
                          return _buildProjectCard(project);
                        },
                      )
                    else
                      Column(
                        children: visibleProjects
                            .map(_buildProjectCard)
                            .toList(),
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

  Widget _buildProjectCard(PortfolioProject project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_outlined,
                size: 34, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(
              project.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(project.description),
            const SizedBox(height: 10),
            Text(
              'Technologies: ${project.technology}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Edit project',
                  onPressed: () => _editProject(project),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete project',
                  onPressed: () => _deleteProject(project),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// COMMIT 12: CONTACT FORM WITH VALIDATION
// --------------------------------------------------

class ContactPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ContactPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact form submitted successfully!'),
      ),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    _formKey.currentState!.reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Me'),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Light mode' : 'Dark mode',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.mail_outline,
                        size: 55,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Get in Touch',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fill out the form below to contact me.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _messageController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Your Message',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.message_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your message';
                          }

                          if (value.trim().length < 10) {
                            return 'Message must contain at least 10 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send),
                        label: const Text('Submit Message'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



