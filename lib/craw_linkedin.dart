import 'package:craw_ppt/extensions.dart';
import 'package:craw_ppt/file_helper.dart';
import 'package:puppeteer/puppeteer.dart';

class CrawLinkdin {
  final String link =
      'https://www.linkedin.com/search/results/companies/?keywords=%40gmail.com&origin=CLUSTER_EXPANSION&sid=*E4&page=';

  Future<void> startCraw() async {
    List<String> emails = [];
    for (int i = 1; i <= 482; i++) {
      try {
        final result = await _getEmailFromSinglePage(
          threadLink: link + i.toString(),
        );
        emails.addAll(result);
      } catch (e) {
        print(e);
      }
    }
    emails = emails.removeDuplicate();
    print('Total emails: ${emails.length}');
  }

  Future<List<String>> _getEmailFromSinglePage({
    required String threadLink,
  }) async {
    print('Start crawling $threadLink');
    var browser = await puppeteer.launch();
    var myPage = await browser.newPage();
    myPage.defaultTimeout = const Duration(seconds: 30);
    await myPage.goto(threadLink, wait: Until.domContentLoaded);
    // await myPage.screenshot();
    // await myPage.pdf();

    String data =
        await myPage.evaluate<String>('() => document.body.innerHTML');
    print(data);
    final List<String> emails = data.toEmails();
    print('End crawling $threadLink, get ${emails.length} emails');
    browser.close();
    FileHelper.addEmailToLastFile(emails.join('\n'), 'gmails_linkedin.txt');
    return emails;
  }
}
