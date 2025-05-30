import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String? getCurrentUserEmail() {
    final user = _supabase.auth.currentUser;
    return user?.email;
  }

  Future<void> updateUsername(String username) async {
    await _supabase.auth.updateUser(UserAttributes(data: {'username': username}));
  }

  Future<void> updateEmail(String newEmail) async {
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));
  }


  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
  String? getCurrentUsernane() {
    final user = _supabase.auth.currentUser;
    return user?.userMetadata?['username'];
  }

  Future<void> requestAccountDeletion() async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');

    final email = user.email;
    final userId = user.id;

    const supportEmail = 'support@wrapvpn.com';
    const subject = 'Account Deletion Request';
    final body = '''
Hello Wrap VPN Support Team,

I would like to request the deletion of my account and all associated data.

Account Details:
- Email: $email
- User ID: $userId
- Request Date: ${DateTime.now().toString()}

Please confirm the deletion of my account and all personal data associated with it.

Thank you,
User
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Could not open email client');
    }
  }
}



final authService = AuthService();




