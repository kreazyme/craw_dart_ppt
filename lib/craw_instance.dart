import 'package:craw_ppt/extensions.dart';
import 'package:puppeteer/puppeteer.dart';

class CrawInstance {
  const CrawInstance();
  Future<List<String>> getEmailFromSinglePage({
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
    data = data
        .replaceAll('<em class="textHighlight">', "")
        .replaceAll('</em>', "");
    final List<String> emails = data.toEmails();
    print('End crawling $threadLink, get ${emails.length} emails');
    browser.close();
    return emails;
  }

  Future<List<String>> getMailTolFromSinglePage({
    required String threadLink,
  }) async {
    print('Start crawling $threadLink');
    var browser = await puppeteer.launch();
    var myPage = await browser.newPage();
    myPage.defaultTimeout = const Duration(seconds: 50);
    await myPage.goto(threadLink, wait: Until.load);
    // await myPage.screenshot();
    // await myPage.pdf();
    String data =
        await myPage.evaluate<String>('() => document.body.innerHTML');
    final mailToRegex =
        RegExp(r'mailto:([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})');
    List<String> emails =
        mailToRegex.allMatches(data).map((e) => e.group(1)!).toList();
    emails = emails.join('\n').toEmails();
    emails = emails.removeDuplicate();
    print('End crawling $threadLink, get ${emails.length} emails');
    browser.close();
    return emails;
  }
}
