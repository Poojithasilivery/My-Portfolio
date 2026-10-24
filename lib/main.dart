import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyPortfolioApp());
}

// ---------------- APP ROOT ----------------

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  bool _isDarkMode = false;
  bool _themeLoaded = false;

  final List<ContactMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMessages = prefs.getString('contactMessages');
      final loadedMessages = <ContactMessage>[];

      if (savedMessages != null) {
        final decoded = jsonDecode(savedMessages);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is Map) {
              loadedMessages.add(
                ContactMessage.fromJson(Map<String, dynamic>.from(item)),
              );
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _isDarkMode = prefs.getBool('isDarkMode') ?? false;
        _messages
          ..clear()
          ..addAll(loadedMessages);
        _themeLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _themeLoaded = true);
    }
  }

  Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        _messages.map((message) => message.toJson()).toList(),
      );
      await prefs.setString('contactMessages', encoded);
    } catch (_) {
      // The app remains usable if local storage is unavailable.
    }
  }

  Future<void> _toggleTheme() async {
    final newValue = !_isDarkMode;
    setState(() => _isDarkMode = newValue);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', newValue);
    } catch (_) {}
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
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: !_themeLoaded
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : PortfolioHomePage(
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
              messages: _messages,
              onMessagesChanged: _saveMessages,
            ),
    );
  }
}

// ---------------- PROFILE HOME PAGE ----------------

class PortfolioHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final List<ContactMessage> messages;
  final Future<void> Function() onMessagesChanged;

  const PortfolioHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.messages,
    required this.onMessagesChanged,
  });

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Your Name');
  final _emailController = TextEditingController(text: 'you@example.com');
  final _roleController = TextEditingController(text: 'Flutter Developer');
  final _skillsController = TextEditingController(text: 'Flutter, Dart, SQL');
  final _aboutController = TextEditingController(
    text: 'Welcome to my portfolio! I enjoy building useful applications.',
  );

  String _name = 'Your Name';
  String _email = 'you@example.com';
  String _role = 'Flutter Developer';
  String _skills = 'Flutter, Dart, SQL';
  String _about =
      'Welcome to my portfolio! I enjoy building useful applications.';

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _name = _nameController.text.trim();
      _email = _emailController.text.trim();
      _role = _roleController.text.trim();
      _skills = _skillsController.text.trim();
      _about = _aboutController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _openProjects() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectsPage(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
          messages: widget.messages,
          onMessagesChanged: widget.onMessagesChanged,
        ),
      ),
    );
  }

  void _openContact() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactPage(
          isDarkMode: widget.isDarkMode,
          onToggleTheme: widget.onToggleTheme,
          messages: widget.messages,
          onMessagesChanged: widget.onMessagesChanged,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
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
            onPressed: _openProjects,
            icon: const Icon(Icons.work_outline),
          ),
          IconButton(
            tooltip: 'Contact',
            onPressed: _openContact,
            icon: const Icon(Icons.contact_mail_outlined),
          ),
          IconButton(
            tooltip: 'Message history',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageHistoryPage(
                  messages: widget.messages,
                  onMessagesChanged: widget.onMessagesChanged,
                  isDarkMode: widget.isDarkMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ),
            icon: Badge(
              label: Text('${widget.messages.length}'),
              isLabelVisible: widget.messages.isNotEmpty,
              child: const Icon(Icons.history),
            ),
          ),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;

          final preview = _profilePreview(context);
          final form = _profileForm(context);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (wide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: preview),
                          const SizedBox(width: 20),
                          Expanded(child: form),
                        ],
                      )
                    else ...[
                      preview,
                      const SizedBox(height: 20),
                      form,
                    ],
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(Icons.work_outline, size: 38),
                            const SizedBox(height: 8),
                            Text(
                              'Explore My Projects',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: _openProjects,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('View Projects'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _openContact,
                              icon: const Icon(Icons.mail_outline),
                              label: const Text('Contact Me'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MessageHistoryPage(
                                    messages: widget.messages,
                                    onMessagesChanged:
                                        widget.onMessagesChanged,
                                    isDarkMode: widget.isDarkMode,
                                    onToggleTheme: widget.onToggleTheme,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.history),
                              label: Text(
                                'Message History (${widget.messages.length})',
                              ),
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

  Widget _profilePreview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 54),
            ),
            const SizedBox(height: 14),
            Text(
              _name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(_role, textAlign: TextAlign.center),
            const Divider(height: 28),
            _detail(Icons.email_outlined, _email),
            const SizedBox(height: 12),
            _detail(Icons.code, _skills),
            const SizedBox(height: 18),
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

  Widget _detail(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _profileForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _profileField(_nameController, 'Name'),
              _profileField(
                _emailController,
                'Email',
                email: true,
              ),
              _profileField(_roleController, 'Role or Course'),
              _profileField(_skillsController, 'Skills'),
              _profileField(
                _aboutController,
                'About Me',
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileField(
    TextEditingController controller,
    String label, {
    bool email = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType:
            email ? TextInputType.emailAddress : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          if (email &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                  .hasMatch(value.trim())) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}

// ---------------- PROJECT MODEL ----------------

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
// ---------------- PROJECT MANAGEMENT ----------------

class ProjectsPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final List<ContactMessage> messages;
  final Future<void> Function() onMessagesChanged;

  const ProjectsPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.messages,
    required this.onMessagesChanged,
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
      description: 'A personal portfolio to showcase my profile and skills.',
      technology: 'Flutter, Dart',
    ),
    PortfolioProject(
      title: 'Employee Management System',
      description: 'An application for managing employee information.',
      technology: 'Flutter, Database',
    ),
    PortfolioProject(
      title: 'Student Dashboard',
      description: 'A dashboard for student information.',
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
          wasEditing ? 'Project updated!' : 'Project added!',
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
  }

  Future<void> _deleteProject(PortfolioProject project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Project?'),
        content: Text('Delete "${project.title}"?'),
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
      final index = _projects.indexOf(project);
      if (index == -1) return;

      _projects.removeAt(index);

      if (_editingIndex == index) {
        _clearForm();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
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
    final projects = _filteredProjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            tooltip: 'Message history',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageHistoryPage(
                  messages: widget.messages,
                  onMessagesChanged: widget.onMessagesChanged,
                  isDarkMode: widget.isDarkMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;

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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Search projects',
                        hintText: 'Title, description, or technology',
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
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 14),
                              _projectField(_titleController, 'Project Title'),
                              _projectField(
                                _descriptionController,
                                'Description',
                                maxLines: 3,
                              ),
                              _projectField(
                                _technologyController,
                                'Technologies Used',
                              ),
                              Wrap(
                                spacing: 10,
                                children: [
                                  FilledButton.icon(
                                    onPressed: _saveProject,
                                    icon: const Icon(Icons.save),
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
                    if (projects.isEmpty)
                      const Center(
                        child: Text('No matching projects found.'),
                      )
                    else if (wide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: projects.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 370,
                          mainAxisExtent: 260,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) =>
                            _projectCard(projects[index]),
                      )
                    else
                      Column(
                        children: projects.map(_projectCard).toList(),
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

  Widget _projectField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _projectCard(PortfolioProject project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.folder_outlined, size: 34),
            const SizedBox(height: 8),
            Text(
              project.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(project.description),
            const SizedBox(height: 8),
            Text('Technologies: ${project.technology}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () => _editProject(project),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete',
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

// ---------------- CONTACT MESSAGE MODEL ----------------

class ContactMessage {
  final String name;
  final String email;
  final String message;
  final DateTime sentAt;

  ContactMessage({
    required this.name,
    required this.email,
    required this.message,
  }) : sentAt = DateTime.now();

  ContactMessage._({
    required this.name,
    required this.email,
    required this.message,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'message': message,
        'sentAt': sentAt.toIso8601String(),
      };

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage._(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      message: json['message'] as String? ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
// ---------------- CONTACT FORM ----------------

class ContactPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final List<ContactMessage> messages;
  final Future<void> Function() onMessagesChanged;

  const ContactPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.messages,
    required this.onMessagesChanged,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final newMessage = ContactMessage(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
    );

    setState(() {
      widget.messages.add(newMessage);
    });

    await widget.onMessagesChanged();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message submitted successfully!'),
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
            tooltip: 'Message history',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageHistoryPage(
                  messages: widget.messages,
                  onMessagesChanged: widget.onMessagesChanged,
                  isDarkMode: widget.isDarkMode,
                  onToggleTheme: widget.onToggleTheme,
                ),
              ),
            ),
            icon: Badge(
              label: Text('${widget.messages.length}'),
              isLabelVisible: widget.messages.isNotEmpty,
              child: const Icon(Icons.history),
            ),
          ),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
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
                      const Icon(Icons.mail_outline, size: 52),
                      const SizedBox(height: 12),
                      Text(
                        'Get in Touch',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Fill in the form to submit a message.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      _contactField(_nameController, 'Your Name'),
                      _contactField(
                        _emailController,
                        'Email Address',
                        email: true,
                      ),
                      _contactField(
                        _messageController,
                        'Your Message',
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.send),
                        label: const Text('Submit Message'),
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

  Widget _contactField(
    TextEditingController controller,
    String label, {
    bool email = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType:
            email ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }

          if (email &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                  .hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }

          if (label == 'Your Message' && value.trim().length < 10) {
            return 'Message must contain at least 10 characters';
          }

          return null;
        },
      ),
    );
  }
}

// ---------------- COMMIT 14: PERMANENT MESSAGE HISTORY ----------------

class MessageHistoryPage extends StatefulWidget {
  final List<ContactMessage> messages;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Future<void> Function() onMessagesChanged;

  const MessageHistoryPage({
    super.key,
    required this.messages,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onMessagesChanged,
  });

  @override
  State<MessageHistoryPage> createState() => _MessageHistoryPageState();
}

class _MessageHistoryPageState extends State<MessageHistoryPage> {
  Future<void> _deleteMessage(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Message?'),
        content: const Text(
          'Are you sure you want to delete this message?',
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
      widget.messages.removeAt(index);
    });

    await widget.onMessagesChanged();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message History'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: widget.messages.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'No messages yet',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Submit a message through the contact form to see it here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(message.email),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete message',
                              onPressed: () => _deleteMessage(index),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(message.message),
                        const SizedBox(height: 10),
                        Text(
                          'Received: ${message.sentAt.toLocal()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}