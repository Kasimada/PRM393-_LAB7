// lib/utils/validators.dart
import 'package:flutter/material.dart';

enum PasswordStrength { none, weak, medium, strong }

class ValidatorService {
  // Bỏ static
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  // Bỏ static
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  // Bỏ static
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Password must contain at least 1 digit';
    return null;
  }

  // Bỏ static
  String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'Confirm password is required';
    if (value != originalPassword) return 'Passwords do not match';
    return null;
  }

  // Bỏ static
  PasswordStrength calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Bỏ static
  String getStrengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak: return 'Weak';
      case PasswordStrength.medium: return 'Medium';
      case PasswordStrength.strong: return 'Strong';
      case PasswordStrength.none: return '';
    }
  }

  // Bỏ static
  Color getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak: return Colors.red;
      case PasswordStrength.medium: return Colors.orange;
      case PasswordStrength.strong: return Colors.green;
      case PasswordStrength.none: return Colors.grey.shade300;
    }
  }

  // Bỏ static
  double getStrengthProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak: return 0.33;
      case PasswordStrength.medium: return 0.66;
      case PasswordStrength.strong: return 1.0;
      case PasswordStrength.none: return 0.0;
    }
  }
}