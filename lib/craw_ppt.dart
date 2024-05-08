import 'package:craw_ppt/craw_instance.dart';
import 'package:craw_ppt/extensions.dart';
import 'package:craw_ppt/file_helper.dart';
import 'package:craw_ppt/threads_link.dart';
import 'package:puppeteer/puppeteer.dart';

Future<int> calculate() async {
  // return 6 * 7;
  CrawInstance crawInstance = CrawInstance();
  List<String> emails = [];
  var browser = await puppeteer.launch();
  var myPage = await browser.newPage();
  myPage.defaultTimeout = const Duration(seconds: 50);
  for (int i = 1; i <= 165; i++) {
    try {
      final result = await crawInstance.getMailTolFromSinglePage(
        threadLink: '${ThreadLinks.links[0]}$i',
      );
      result.forEach((element) {
        print(element);
      });
      emails.addAll(result);
    } catch (e) {
      print(e);
    }
  }
  emails = emails.removeDuplicate();
  FileHelper.saveEmails(emails);
  print('Total emails: ${emails.length}');
  return 0;
}
