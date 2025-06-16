import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<bool> sendResetPasswordEmail(
    String recipientEmail, String newPassword) async {
  String username = 'leminhoang2004@gmail.com';
  String appPassword = 'hjqd kyjg rpxg vajl';

  final smtpServer = gmail(username, appPassword);

  final message = Message()
    ..from = Address(username, 'UTC2 Administrator')
    ..recipients.add(recipientEmail) // Use the passed email
    ..subject = 'UTC2 Password Reset'
    ..text = 'Here is your new password: $newPassword';

  try {
    await send(message, smtpServer);
    print('✅ Email sent successfully to: $recipientEmail');
    return true;
  } on MailerException catch (e) {
    print('❌ Error sending email: $e');
    for (var p in e.problems) {
      print(' - ${p.code}: ${p.msg}');
    }
    return false;
  }
}
