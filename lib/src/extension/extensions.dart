
extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) return '${this[0].toUpperCase()}${substring(1)}';
    return this;
  }

  String capitalizeEachWord() {
    var titleCase = StringBuffer();
    split(', ').forEach((sub) {
      if (sub.trim().isEmpty) return;
      titleCase
        ..write(sub[0].toUpperCase())
        ..write(sub.substring(1))
        ..write(' ');
    });
    return this;
  }

  String toTitleCase() {
    return split(' ').map((sub) {
      if (sub.trim().isEmpty) return sub;
      return '${sub[0].toUpperCase()}${sub.substring(1)}';
    }).join(' ');
  }
}