import 'dart:math';

import 'package:craw_ppt/extensions.dart';
import 'package:craw_ppt/file_helper.dart';
import 'package:dio/dio.dart';

class CrawFromEpik {
  final Dio dio = Dio();
  final int total = 3100;
  final int perPage = 20;

  Future<void> crawEpik() async {
    for (int currentPage = 1; currentPage <= total ~/ perPage; currentPage++) {
      await _crawPagination(
        link: _getLink(currentPage),
      );
    }
  }

  Future<void> _crawPagination({
    required String link,
  }) async {
    print(link);
    // add headers
    var headers = {
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
      'accept-encoding': 'gzip, deflate, sdch, br',
      'sec-ch-ua':
          '"Microsoft Edge";v="123", "Not:A-Brand";v="8", "Chromium";v="123"',
      'accept': "application/json, text/plain, */*",
    };
    dio.options.headers = headers;
    final response = await dio.get(link);
    final mailToRegex =
        RegExp(r'([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})');
    List<String> emails = mailToRegex
        .allMatches(response.data.toString())
        .map((e) => e.group(1)!)
        .toList();
    emails = emails.removeDuplicate();
    FileHelper.addEmailToLastFile(emails.join('\n'), 'gmails_epik_v2.txt');
    await Future.delayed(
      Duration(
        milliseconds: 1000 + Random().nextInt(3000),
      ),
    );
    print('Total emails: ${emails.length}');
  }

  String _getLink(int currentPage) {
    return 'https://dev.epicgames.com/community/api/search/index.json?per_page=$perPage&query=@gmail.com&published_at_range=any_time&sort_by=relevancy&preferred_locale=en-us&page=$currentPage';
  }
}
