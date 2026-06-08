import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:feedback_flow/screens/pin_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? _customAppPin;
  static final LocalAuthentication _auth = LocalAuthentication();

  // Loads the PIN from local storage if it's not already in memory
  static Future<void> _loadPin() async {
    if (_customAppPin == null) {
      final prefs = await SharedPreferences.getInstance();
      _customAppPin = prefs.getString('custom_app_pin');
    }
  }

  // Saves the PIN permanently to local storage
  static Future<void> _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_app_pin', pin);
    _customAppPin = pin;
  }

  /// Authenticates the user via Biometrics/Device PIN, or falls back to an in-app custom PIN.
  static Future<bool> authenticate(BuildContext context, String reason) async {
    // Load the PIN first to check if they already set up the Custom PIN
    await _loadPin();

    // If a custom PIN is already set, bypass the native device checks completely!
    if (_customAppPin != null) {
      if (!context.mounted) return false;
      return await _handleCustomAuth(context);
    }

    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (canAuthenticate) {
        return await _auth.authenticate(
          localizedReason: reason,
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false,
          ),
        );
      } else {
        if (!context.mounted) return false;
        return await _handleCustomAuth(context);
      }
    } on PlatformException catch (e) {
      // Fallback to custom PIN if device doesn't have credentials
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        if (!context.mounted) return false;
        return await _handleCustomAuth(context);
      } else {
        debugPrint("Auth failed or was cancelled: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication error: ${e.message}')),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Auth failed or was cancelled: $e");
      return false;
    }
  }

  static Future<bool> _handleCustomAuth(BuildContext context) async {
    // Ensure the saved PIN is loaded before we check if it's null
    await _loadPin();

    if (_customAppPin == null) {
      // Setup new PIN
      final pin = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PinDialog(title: 'Set up App PIN', isSetup: true),
      );

      if (pin != null && pin.length >= 4) {
        await _savePin(pin);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App PIN set successfully.')),
          );
        }
        return true;
      }
      return false;
    } else {
      // Verify existing PIN
      final pin = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PinDialog(title: 'Enter App PIN', isSetup: false),
      );

      if (pin == _customAppPin) return true;
      if (pin != null && context.mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incorrect PIN.')));
      return false;
    }
  }
}
