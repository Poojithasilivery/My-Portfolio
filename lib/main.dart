import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyPortfolioApp());
}

// ---------------- PROJECT MODEL ----------------

class PortfolioProject {
  String title;
  String description;
  String technologies;
  String status;

  PortfolioProject({
    required this.title,
    required this.description,
    required this.technologies,
    this.status = 'Completed',
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'technologies': technologies,
        'status': status,
      };

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    return PortfolioProject(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      technologies: json['technologies'] ?? '',
      status: json['status'] ?? 'Completed',
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
    DateTime? sentAt,
  }) : sentAt = sentAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'message': message,
        'sentAt': sentAt.toIso8601String(),
      };

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      message: json['message'] ?? '',
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ---------------- APP ROOT ----------------

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  bool isDarkMode = false;
  bool isLoaded = false;

  final List<ContactMessage> messages = [];

  @override
  void initState() {
    super.initState();
    loadAppData();
  }

  Future<void> loadAppData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedMessages = prefs.getString('contactMessages');
    if (savedMessages != null) {
      try {
        final List decoded = jsonDecode(savedMessages);
        messages.addAll(decoded.map(
          (item) => ContactMessage.fromJson(
            Map<String, dynamic>.from(item),
          ),
        ));
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      isLoaded = true;
    });
  }

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'contactMessages',
      jsonEncode(messages.map((m) => m.toJson()).toList()),
    );
  }

  Future<void> toggleTheme() async {
    setState(() => isDarkMode = !isDarkMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      home: isLoaded
          ? PortfolioHomePage(
              isDarkMode: isDarkMode,
              onToggleTheme: toggleTheme,
              messages: messages,
              onMessagesChanged: saveMessages,
            )
          : const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

// ---------------- HOME PAGE ----------------

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
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: 'Your Name');
  final emailController = TextEditingController(text: 'you@example.com');
  final roleController = TextEditingController(text: 'Flutter Developer');
  final skillsController = TextEditingController(text: 'Flutter, Dart, SQL');
  final aboutController = TextEditingController(
    text: 'Welcome to my portfolio! I enjoy building useful applications.',
  );

  String name = 'Your Name';
  String email = 'you@example.com';
  String role = 'Flutter Developer';
  String skills = 'Flutter, Dart, SQL';
  String about =
      'Welcome to my portfolio! I enjoy building useful applications.';

  void saveProfile() {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      name = nameController.text.trim();
      email = emailController.text.trim();
      role = roleController.text.trim();
      skills = skillsController.text.trim();
      about = aboutController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void openProjects() {
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

  void openContact() {
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
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    skillsController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Widget profileField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Projects',
            onPressed: openProjects,
            icon: const Icon(Icons.work_outline),
          ),
          IconButton(
            tooltip: 'Contact',
            onPressed: openContact,
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
              isLabelVisible: widget.messages.isNotEmpty,
              label: Text('${widget.messages.length}'),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final preview = Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.person, size: 52),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    role,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(height: 28),
                  Text(email),
                  const SizedBox(height: 12),
                  Text('Skills: $skills'),
                  const SizedBox(height: 12),
                  Text(about, textAlign: TextAlign.center),
                ],
              ),
            ),
          );

          final form = Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    profileField(nameController, 'Name'),
                    profileField(emailController, 'Email'),
                    profileField(roleController, 'Role'),
                    profileField(skillsController, 'Skills'),
                    profileField(aboutController, 'About Me', maxLines: 3),
                    FilledButton.icon(
                      onPressed: saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Profile'),
                    ),
                  ],
                ),
              ),
            ),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (constraints.maxWidth >= 800)
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
                      const SizedBox(height: 16),
                      form,
                    ],
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(Icons.work_outline, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Explore My Projects',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: openProjects,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('View Projects'),
                            ),
                            OutlinedButton.icon(
                              onPressed: openContact,
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
}

// ---------------- COMMIT 15: PERMANENT PROJECT STORAGE ----------------

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
  static const String storageKey = 'portfolioProjects';

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final technologiesController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<PortfolioProject> projects = [];
  bool isLoading = true;
  int? editingIndex;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProjects = prefs.getString(storageKey);

      if (savedProjects != null) {
        final List decoded = jsonDecode(savedProjects);
        projects = decoded
            .map(
              (item) => PortfolioProject.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      } else {
        projects = [
          PortfolioProject(
            title: 'Portfolio Website',
            description:
                'A responsive portfolio to showcase my profile and work.',
            technologies: 'Flutter, Dart',
          ),
          PortfolioProject(
            title: 'Employee Management System',
            description:
                'An application to manage employee details and attendance.',
            technologies: 'HTML, CSS, JavaScript',
          ),
          PortfolioProject(
            title: 'Data Analytics Project',
            description:
                'A project for analyzing data and discovering useful patterns.',
            technologies: 'Python, Pandas',
          ),
        ];

        await saveProjects();
      }
    } catch (_) {
      projects = [];
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      projects.map((project) => project.toJson()).toList(),
    );
    await prefs.setString(storageKey, encoded);
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    technologiesController.clear();
    editingIndex = null;
  }

  Future<void> saveProject() async {
    if (!formKey.currentState!.validate()) return;

    final project = PortfolioProject(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      technologies: technologiesController.text.trim(),
      status: 'Completed',
    );

    setState(() {
      if (editingIndex == null) {
        projects.add(project);
      } else {
        projects[editingIndex!] = project;
      }
    });

    await saveProjects();

    if (!mounted) return;
    setState(clearForm);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          editingIndex == null
              ? 'Project saved permanently!'
              : 'Project updated permanently!',
        ),
      ),
    );
  }

  void editProject(int index) {
    final project = projects[index];

    setState(() {
      editingIndex = index;
      titleController.text = project.title;
      descriptionController.text = project.description;
      technologiesController.text = project.technologies;
    });

    Scrollable.ensureVisible(
      formKey.currentContext!,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> deleteProject(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text(
          'This project will be removed permanently.',
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

    if (confirmed != true || !mounted) return;

    setState(() {
      projects.removeAt(index);
      clearForm();
    });

    await saveProjects();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project deleted permanently')),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    technologiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = projects.where((project) {
      final query = searchText.toLowerCase();
      return project.title.toLowerCase().contains(query) ||
          project.description.toLowerCase().contains(query) ||
          project.technologies.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Manage Projects',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => setState(() => searchText = value),
                  decoration: const InputDecoration(
                    labelText: 'Search projects',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            editingIndex == null
                                ? 'Add New Project'
                                : 'Edit Project',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Project Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Enter project title'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Enter description'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: technologiesController,
                            decoration: const InputDecoration(
                              labelText: 'Technologies Used',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? 'Enter technologies'
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: saveProject,
                            icon: Icon(
                              editingIndex == null ? Icons.add : Icons.save,
                            ),
                            label: Text(
                              editingIndex == null
                                  ? 'Add Project'
                                  : 'Update Project',
                            ),
                          ),
                          if (editingIndex != null)
                            TextButton(
                              onPressed: () => setState(clearForm),
                              child: const Text('Cancel Editing'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Saved Projects (${filteredProjects.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (filteredProjects.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No projects found.')),
                    ),
                  ),
                ...filteredProjects.map((project) {
                  final originalIndex = projects.indexOf(project);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.folder_open, size: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  project.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    editProject(originalIndex);
                                  } else {
                                    deleteProject(originalIndex);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(project.description),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.technologies
                                .split(',')
                                .map((technology) => Chip(
                                      label: Text(technology.trim()),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${project.status}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

// ---------------- CONTACT PAGE ----------------

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
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final newMessage = ContactMessage(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      message: messageController.text.trim(),
    );

    setState(() => widget.messages.add(newMessage));
    await widget.onMessagesChanged();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message saved successfully!')),
    );

    nameController.clear();
    emailController.clear();
    messageController.clear();
    formKey.currentState!.reset();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget contactField(
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
            return 'Enter a valid email address';
          }

          if (label == 'Your Message' && value.trim().length < 10) {
            return 'Message must contain at least 10 characters';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Me'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
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
            icon: const Icon(Icons.history),
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
                  key: formKey,
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
                      contactField(nameController, 'Your Name'),
                      contactField(
                        emailController,
                        'Email Address',
                        email: true,
                      ),
                      contactField(
                        messageController,
                        'Your Message',
                        maxLines: 5,
                      ),
                      FilledButton.icon(
                        onPressed: submitForm,
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
}

// ---------------- MESSAGE HISTORY ----------------

class MessageHistoryPage extends StatefulWidget {
  final List<ContactMessage> messages;
  final Future<void> Function() onMessagesChanged;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MessageHistoryPage({
    super.key,
    required this.messages,
    required this.onMessagesChanged,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MessageHistoryPage> createState() => _MessageHistoryPageState();
}

class _MessageHistoryPageState extends State<MessageHistoryPage> {
  Future<void> deleteMessage(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Message?'),
        content: const Text('Are you sure you want to delete this message?'),
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

    if (confirmed != true || !mounted) return;

    setState(() => widget.messages.removeAt(index));
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
                              onPressed: () => deleteMessage(index),
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