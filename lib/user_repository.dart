// lib/user_repository.dart
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class UserRepository {
  final _prefs = EncryptedSharedPreferences();

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String emailAddress = '';

  /// Load user data from EncryptedSharedPreferences
  Future<void> loadData() async {
    try {
      final fn = await _prefs.getString('firstName');
      final ln = await _prefs.getString('lastName');
      final pn = await _prefs.getString('phoneNumber');
      final ea = await _prefs.getString('emailAddress');

      firstName = fn ?? '';
      lastName = ln ?? '';
      phoneNumber = pn ?? '';
      emailAddress = ea ?? '';
    } catch (e) {
      // If any error occurs (e.g., key doesn't exist), use empty strings
      firstName = '';
      lastName = '';
      phoneNumber = '';
      emailAddress = '';
    }
  }

  /// Save user data to EncryptedSharedPreferences
  Future<void> saveData() async {
    try {
      await _prefs.setString('firstName', firstName);
      await _prefs.setString('lastName', lastName);
      await _prefs.setString('phoneNumber', phoneNumber);
      await _prefs.setString('emailAddress', emailAddress);
    } catch (e) {
      // Handle any save errors silently
    }
  }
}