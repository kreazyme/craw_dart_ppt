extension XString on String? {
  List<String> toEmails() {
    return this!
        .split(" ")
        .where((element) => RegExp(AppRegex.emailRegex).hasMatch(element))
        .join("\n")
        .split("\n")
        .where((element) => RegExp(AppRegex.emailRegex).hasMatch(element))
        .map((e) => e.trim())
        .toList();
  }
}

extension XListString on List<String> {
  List<String> removeDuplicate() {
    return toSet().toList();
  }
}

abstract class AppRegex {
  static final emailRegex =
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b';
}
