
class LibraryModel {
  int numFound;
  int start;
  bool numFoundExact;
  int libraryModelNumFound;
  String documentationUrl;
  String q;
  dynamic offset;
  List<Doc> docs;

  LibraryModel({
    required this.numFound,
    required this.start,
    required this.numFoundExact,
    required this.libraryModelNumFound,
    required this.documentationUrl,
    required this.q,
    required this.offset,
    required this.docs,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) => LibraryModel(
    numFound: json["numFound"],
    start: json["start"],
    numFoundExact: json["numFoundExact"],
    libraryModelNumFound: json["num_found"],
    documentationUrl: json["documentation_url"],
    q: json["q"],
    offset: json["offset"],
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "numFound": numFound,
    "start": start,
    "numFoundExact": numFoundExact,
    "num_found": libraryModelNumFound,
    "documentation_url": documentationUrl,
    "q": q,
    "offset": offset,
    "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
  };
}

class Doc {
  List<String>? authorKey;
  List<String>? authorName;
  String? coverEditionKey;
  int? coverI;
  EbookAccess ebookAccess;
  int editionCount;
  int? firstPublishYear;
  bool hasFulltext;
  String key;
  List<Language>? language;
  bool publicScanB;
  String title;
  List<String>? ia;
  List<String>? iaCollection;
  String? lendingEditionS;
  String? lendingIdentifierS;

  Doc({
    this.authorKey,
    this.authorName,
    this.coverEditionKey,
    this.coverI,
    required this.ebookAccess,
    required this.editionCount,
    this.firstPublishYear,
    required this.hasFulltext,
    required this.key,
    this.language,
    required this.publicScanB,
    required this.title,
    this.ia,
    this.iaCollection,
    this.lendingEditionS,
    this.lendingIdentifierS,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    authorKey: json["author_key"] == null ? [] : List<String>.from(json["author_key"]!.map((x) => x)),
    authorName: json["author_name"] == null ? [] : List<String>.from(json["author_name"]!.map((x) => x)),
    coverEditionKey: json["cover_edition_key"],
    coverI: json["cover_i"],
    ebookAccess: ebookAccessValues.map[json["ebook_access"]]!,
    editionCount: json["edition_count"],
    firstPublishYear: json["first_publish_year"],
    hasFulltext: json["has_fulltext"],
    key: json["key"],
    language: json["language"] == null ? [] : List<Language>.from(json["language"]!.map((x) => languageValues.map[x]!)),
    publicScanB: json["public_scan_b"],
    title: json["title"],
    ia: json["ia"] == null ? [] : List<String>.from(json["ia"]!.map((x) => x)),
    iaCollection: json["ia_collection"] == null ? [] : List<String>.from(json["ia_collection"]!.map((x) => x)),
    lendingEditionS: json["lending_edition_s"],
    lendingIdentifierS: json["lending_identifier_s"],
  );

  Map<String, dynamic> toJson() => {
    "author_key": authorKey == null ? [] : List<dynamic>.from(authorKey!.map((x) => x)),
    "author_name": authorName == null ? [] : List<dynamic>.from(authorName!.map((x) => x)),
    "cover_edition_key": coverEditionKey,
    "cover_i": coverI,
    "ebook_access": ebookAccessValues.reverse[ebookAccess],
    "edition_count": editionCount,
    "first_publish_year": firstPublishYear,
    "has_fulltext": hasFulltext,
    "key": key,
    "language": language == null ? [] : List<dynamic>.from(language!.map((x) => languageValues.reverse[x])),
    "public_scan_b": publicScanB,
    "title": title,
    "ia": ia == null ? [] : List<dynamic>.from(ia!.map((x) => x)),
    "ia_collection": iaCollection == null ? [] : List<dynamic>.from(iaCollection!.map((x) => x)),
    "lending_edition_s": lendingEditionS,
    "lending_identifier_s": lendingIdentifierS,
  };
}

enum EbookAccess {
  BORROWABLE,
  NO_EBOOK,
  PRINTDISABLED,
  PUBLIC
}

final ebookAccessValues = EnumValues({
  "borrowable": EbookAccess.BORROWABLE,
  "no_ebook": EbookAccess.NO_EBOOK,
  "printdisabled": EbookAccess.PRINTDISABLED,
  "public": EbookAccess.PUBLIC
});

enum Language {
  ENG,
  FIN,
  GER,
  SPA
}

final languageValues = EnumValues({
  "eng": Language.ENG,
  "fin": Language.FIN,
  "ger": Language.GER,
  "spa": Language.SPA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
