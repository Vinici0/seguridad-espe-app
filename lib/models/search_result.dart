class SearchResult {
  final bool cancel;
  final bool manual;

  SearchResult({required this.cancel, this.manual = false});

  @override
  String toString() {
    return '{ cancel: $cancel, manual: $manual }';
  }
}
