import 'dart:io';

abstract class FileHelper {
  static void saveEmails(List<String> emails) {
    String data = emails.join('\n');
    File('emails${DateTime.now().millisecondsSinceEpoch}.txt')
        .writeAsStringSync(data);
  }
}
