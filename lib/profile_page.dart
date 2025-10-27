// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;
  final UserRepository repository;

  const ProfilePage({
    Key? key,
    required this.loginName,
    required this.repository,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from repository
    _firstNameCtrl = TextEditingController(text: widget.repository.firstName);
    _lastNameCtrl = TextEditingController(text: widget.repository.lastName);
    _phoneCtrl = TextEditingController(text: widget.repository.phoneNumber);
    _emailCtrl = TextEditingController(text: widget.repository.emailAddress);

    // Add listeners to save data when text changes
    _firstNameCtrl.addListener(_onFirstNameChanged);
    _lastNameCtrl.addListener(_onLastNameChanged);
    _phoneCtrl.addListener(_onPhoneChanged);
    _emailCtrl.addListener(_onEmailChanged);

    // Show welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome Back ${widget.loginName}'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _onFirstNameChanged() {
    widget.repository.firstName = _firstNameCtrl.text;
    widget.repository.saveData();
  }

  void _onLastNameChanged() {
    widget.repository.lastName = _lastNameCtrl.text;
    widget.repository.saveData();
  }

  void _onPhoneChanged() {
    widget.repository.phoneNumber = _phoneCtrl.text;
    widget.repository.saveData();
  }

  void _onEmailChanged() {
    widget.repository.emailAddress = _emailCtrl.text;
    widget.repository.saveData();
  }

  Future<void> _launchPhone() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      _showErrorDialog('Please enter a phone number first');
      return;
    }

    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        _showErrorDialog('Phone calls are not supported on this device');
      }
    }
  }

  Future<void> _launchSMS() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      _showErrorDialog('Please enter a phone number first');
      return;
    }

    final Uri uri = Uri.parse('sms:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        _showErrorDialog('SMS messaging is not supported on this device');
      }
    }
  }

  Future<void> _launchEmail() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showErrorDialog('Please enter an email address first');
      return;
    }

    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        _showErrorDialog('Email is not supported on this device');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Not Supported'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.removeListener(_onFirstNameChanged);
    _lastNameCtrl.removeListener(_onLastNameChanged);
    _phoneCtrl.removeListener(_onPhoneChanged);
    _emailCtrl.removeListener(_onEmailChanged);

    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message at the top
            Text(
              'Welcome Back ${widget.loginName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            TextField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name
            TextField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number with buttons
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _launchPhone,
                  child: const Icon(Icons.phone),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _launchSMS,
                  child: const Icon(Icons.sms),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email Address with button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _launchEmail,
                  child: const Icon(Icons.mail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}