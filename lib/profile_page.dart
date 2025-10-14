// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;
  final UserRepository repository;

  const ProfilePage({
    super.key,
    required this.loginName,
    required this.repository,
  });

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
    _firstNameCtrl.addListener(() {
      widget.repository.firstName = _firstNameCtrl.text;
      widget.repository.saveData();
    });

    _lastNameCtrl.addListener(() {
      widget.repository.lastName = _lastNameCtrl.text;
      widget.repository.saveData();
    });

    _phoneCtrl.addListener(() {
      widget.repository.phoneNumber = _phoneCtrl.text;
      widget.repository.saveData();
    });

    _emailCtrl.addListener(() {
      widget.repository.emailAddress = _emailCtrl.text;
      widget.repository.saveData();
    });

    // Show welcome snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome Back ${widget.loginName}'),
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String urlString, String type) async {
    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Not Supported'),
              content: Text('$type is not supported on this device.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Not Supported'),
            content: Text('$type is not supported on this device.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _onPhoneCall() {
    final phone = _phoneCtrl.text;
    if (phone.isNotEmpty) {
      _launchUrl('tel:$phone', 'Phone calls');
    }
  }

  void _onSms() {
    final phone = _phoneCtrl.text;
    if (phone.isNotEmpty) {
      _launchUrl('sms:$phone', 'SMS');
    }
  }

  void _onEmail() {
    final email = _emailCtrl.text;
    if (email.isNotEmpty) {
      _launchUrl('mailto:$email', 'Email');
    }
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
            Text(
              'Welcome Back ${widget.loginName}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _firstNameCtrl,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
                  onPressed: _onPhoneCall,
                  child: const Icon(Icons.phone),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSms,
                  child: const Icon(Icons.sms),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                  onPressed: _onEmail,
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