import 'package:flutter_test/flutter_test.dart';
import 'package:ggp_lob_monitoring/features/auth/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('parses role name from direct role_name field', () {
      final profile = UserProfile.fromMap({
        'id': '1',
        'auth_id': 'auth-123',
        'full_name': 'Budi',
        'email': 'budi@example.com',
        'role_id': 2,
        'role_name': 'supervisor',
        'is_active': true,
      });

      expect(profile.roleName, 'supervisor');
      expect(profile.authId, 'auth-123');
      expect(profile.fullName, 'Budi');
    });
  });
}
