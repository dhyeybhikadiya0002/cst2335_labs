// lib/user_repository.dart
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class UserRepository {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String emailAddress = '';

  // Load data from EncryptedSharedPreferences
  Future<void> loadData() async {
    try {
      firstName = await _prefs.getString('firstName') ?? '';
      lastName = await _prefs.getString('lastName') ?? '';
      phoneNumber = await _prefs.getString('phoneNumber') ?? '';
      emailAddress = await _prefs.getString('emailAddress') ?? '';
    } catch (e) {
      print('Error loading data: $e');
      // If keys don't exist yet, just use empty strings
      firstName = '';
      lastName = '';
      phoneNumber = '';
      emailAddress = '';
    }
  }

  // Save data to EncryptedSharedPreferences
  Future<void> saveData() async {
    try {
      await _prefs.setString('firstName', firstName);
      await _prefs.setString('lastName', lastName);
      await _prefs.setString('phoneNumber', phoneNumber);
      await _prefs.setString('emailAddress', emailAddress);
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}