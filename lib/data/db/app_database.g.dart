// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChapterReadsTable extends ChapterReads
    with TableInfo<$ChapterReadsTable, ChapterRead> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterReadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstReadAtMeta = const VerificationMeta(
    'firstReadAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstReadAt = GeneratedColumn<DateTime>(
    'first_read_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesReadMeta = const VerificationMeta(
    'timesRead',
  );
  @override
  late final GeneratedColumn<int> timesRead = GeneratedColumn<int>(
    'times_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [book, chapter, firstReadAt, timesRead];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter_reads';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterRead> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('first_read_at')) {
      context.handle(
        _firstReadAtMeta,
        firstReadAt.isAcceptableOrUnknown(
          data['first_read_at']!,
          _firstReadAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstReadAtMeta);
    }
    if (data.containsKey('times_read')) {
      context.handle(
        _timesReadMeta,
        timesRead.isAcceptableOrUnknown(data['times_read']!, _timesReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book, chapter};
  @override
  ChapterRead map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterRead(
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      firstReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_read_at'],
      )!,
      timesRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_read'],
      )!,
    );
  }

  @override
  $ChapterReadsTable createAlias(String alias) {
    return $ChapterReadsTable(attachedDatabase, alias);
  }
}

class ChapterRead extends DataClass implements Insertable<ChapterRead> {
  final String book;
  final int chapter;
  final DateTime firstReadAt;
  final int timesRead;
  const ChapterRead({
    required this.book,
    required this.chapter,
    required this.firstReadAt,
    required this.timesRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['first_read_at'] = Variable<DateTime>(firstReadAt);
    map['times_read'] = Variable<int>(timesRead);
    return map;
  }

  ChapterReadsCompanion toCompanion(bool nullToAbsent) {
    return ChapterReadsCompanion(
      book: Value(book),
      chapter: Value(chapter),
      firstReadAt: Value(firstReadAt),
      timesRead: Value(timesRead),
    );
  }

  factory ChapterRead.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterRead(
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      firstReadAt: serializer.fromJson<DateTime>(json['firstReadAt']),
      timesRead: serializer.fromJson<int>(json['timesRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'firstReadAt': serializer.toJson<DateTime>(firstReadAt),
      'timesRead': serializer.toJson<int>(timesRead),
    };
  }

  ChapterRead copyWith({
    String? book,
    int? chapter,
    DateTime? firstReadAt,
    int? timesRead,
  }) => ChapterRead(
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    firstReadAt: firstReadAt ?? this.firstReadAt,
    timesRead: timesRead ?? this.timesRead,
  );
  ChapterRead copyWithCompanion(ChapterReadsCompanion data) {
    return ChapterRead(
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      firstReadAt: data.firstReadAt.present
          ? data.firstReadAt.value
          : this.firstReadAt,
      timesRead: data.timesRead.present ? data.timesRead.value : this.timesRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterRead(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('firstReadAt: $firstReadAt, ')
          ..write('timesRead: $timesRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(book, chapter, firstReadAt, timesRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterRead &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.firstReadAt == this.firstReadAt &&
          other.timesRead == this.timesRead);
}

class ChapterReadsCompanion extends UpdateCompanion<ChapterRead> {
  final Value<String> book;
  final Value<int> chapter;
  final Value<DateTime> firstReadAt;
  final Value<int> timesRead;
  final Value<int> rowid;
  const ChapterReadsCompanion({
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.firstReadAt = const Value.absent(),
    this.timesRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterReadsCompanion.insert({
    required String book,
    required int chapter,
    required DateTime firstReadAt,
    this.timesRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : book = Value(book),
       chapter = Value(chapter),
       firstReadAt = Value(firstReadAt);
  static Insertable<ChapterRead> custom({
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<DateTime>? firstReadAt,
    Expression<int>? timesRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (firstReadAt != null) 'first_read_at': firstReadAt,
      if (timesRead != null) 'times_read': timesRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterReadsCompanion copyWith({
    Value<String>? book,
    Value<int>? chapter,
    Value<DateTime>? firstReadAt,
    Value<int>? timesRead,
    Value<int>? rowid,
  }) {
    return ChapterReadsCompanion(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      firstReadAt: firstReadAt ?? this.firstReadAt,
      timesRead: timesRead ?? this.timesRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (firstReadAt.present) {
      map['first_read_at'] = Variable<DateTime>(firstReadAt.value);
    }
    if (timesRead.present) {
      map['times_read'] = Variable<int>(timesRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterReadsCompanion(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('firstReadAt: $firstReadAt, ')
          ..write('timesRead: $timesRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookCompletionsTable extends BookCompletions
    with TableInfo<$BookCompletionsTable, BookCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionsMeta = const VerificationMeta(
    'completions',
  );
  @override
  late final GeneratedColumn<int> completions = GeneratedColumn<int>(
    'completions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [book, completions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('completions')) {
      context.handle(
        _completionsMeta,
        completions.isAcceptableOrUnknown(
          data['completions']!,
          _completionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book};
  @override
  BookCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookCompletion(
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      completions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completions'],
      )!,
    );
  }

  @override
  $BookCompletionsTable createAlias(String alias) {
    return $BookCompletionsTable(attachedDatabase, alias);
  }
}

class BookCompletion extends DataClass implements Insertable<BookCompletion> {
  final String book;
  final int completions;
  const BookCompletion({required this.book, required this.completions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['completions'] = Variable<int>(completions);
    return map;
  }

  BookCompletionsCompanion toCompanion(bool nullToAbsent) {
    return BookCompletionsCompanion(
      book: Value(book),
      completions: Value(completions),
    );
  }

  factory BookCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookCompletion(
      book: serializer.fromJson<String>(json['book']),
      completions: serializer.fromJson<int>(json['completions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'completions': serializer.toJson<int>(completions),
    };
  }

  BookCompletion copyWith({String? book, int? completions}) => BookCompletion(
    book: book ?? this.book,
    completions: completions ?? this.completions,
  );
  BookCompletion copyWithCompanion(BookCompletionsCompanion data) {
    return BookCompletion(
      book: data.book.present ? data.book.value : this.book,
      completions: data.completions.present
          ? data.completions.value
          : this.completions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookCompletion(')
          ..write('book: $book, ')
          ..write('completions: $completions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(book, completions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookCompletion &&
          other.book == this.book &&
          other.completions == this.completions);
}

class BookCompletionsCompanion extends UpdateCompanion<BookCompletion> {
  final Value<String> book;
  final Value<int> completions;
  final Value<int> rowid;
  const BookCompletionsCompanion({
    this.book = const Value.absent(),
    this.completions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookCompletionsCompanion.insert({
    required String book,
    this.completions = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : book = Value(book);
  static Insertable<BookCompletion> custom({
    Expression<String>? book,
    Expression<int>? completions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (completions != null) 'completions': completions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookCompletionsCompanion copyWith({
    Value<String>? book,
    Value<int>? completions,
    Value<int>? rowid,
  }) {
    return BookCompletionsCompanion(
      book: book ?? this.book,
      completions: completions ?? this.completions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (completions.present) {
      map['completions'] = Variable<int>(completions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookCompletionsCompanion(')
          ..write('book: $book, ')
          ..write('completions: $completions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingLogTable extends ReadingLog
    with TableInfo<$ReadingLogTable, ReadingLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<double> minutes = GeneratedColumn<double>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    at,
    minutes,
    method,
    details,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}minutes'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      )!,
    );
  }

  @override
  $ReadingLogTable createAlias(String alias) {
    return $ReadingLogTable(attachedDatabase, alias);
  }
}

class ReadingLogData extends DataClass implements Insertable<ReadingLogData> {
  final int id;
  final String book;
  final int chapter;
  final DateTime at;
  final double minutes;

  /// 'app' (validada na tela) ou 'impressa' (li na minha Bíblia).
  final String method;

  /// Resumo da validação em JSON (blocos, pausas, toques, mão).
  final String details;
  const ReadingLogData({
    required this.id,
    required this.book,
    required this.chapter,
    required this.at,
    required this.minutes,
    required this.method,
    required this.details,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['at'] = Variable<DateTime>(at);
    map['minutes'] = Variable<double>(minutes);
    map['method'] = Variable<String>(method);
    map['details'] = Variable<String>(details);
    return map;
  }

  ReadingLogCompanion toCompanion(bool nullToAbsent) {
    return ReadingLogCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      at: Value(at),
      minutes: Value(minutes),
      method: Value(method),
      details: Value(details),
    );
  }

  factory ReadingLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingLogData(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      at: serializer.fromJson<DateTime>(json['at']),
      minutes: serializer.fromJson<double>(json['minutes']),
      method: serializer.fromJson<String>(json['method']),
      details: serializer.fromJson<String>(json['details']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'at': serializer.toJson<DateTime>(at),
      'minutes': serializer.toJson<double>(minutes),
      'method': serializer.toJson<String>(method),
      'details': serializer.toJson<String>(details),
    };
  }

  ReadingLogData copyWith({
    int? id,
    String? book,
    int? chapter,
    DateTime? at,
    double? minutes,
    String? method,
    String? details,
  }) => ReadingLogData(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    at: at ?? this.at,
    minutes: minutes ?? this.minutes,
    method: method ?? this.method,
    details: details ?? this.details,
  );
  ReadingLogData copyWithCompanion(ReadingLogCompanion data) {
    return ReadingLogData(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      at: data.at.present ? data.at.value : this.at,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      method: data.method.present ? data.method.value : this.method,
      details: data.details.present ? data.details.value : this.details,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingLogData(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('at: $at, ')
          ..write('minutes: $minutes, ')
          ..write('method: $method, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, book, chapter, at, minutes, method, details);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingLogData &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.at == this.at &&
          other.minutes == this.minutes &&
          other.method == this.method &&
          other.details == this.details);
}

class ReadingLogCompanion extends UpdateCompanion<ReadingLogData> {
  final Value<int> id;
  final Value<String> book;
  final Value<int> chapter;
  final Value<DateTime> at;
  final Value<double> minutes;
  final Value<String> method;
  final Value<String> details;
  const ReadingLogCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.at = const Value.absent(),
    this.minutes = const Value.absent(),
    this.method = const Value.absent(),
    this.details = const Value.absent(),
  });
  ReadingLogCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required int chapter,
    required DateTime at,
    required double minutes,
    required String method,
    this.details = const Value.absent(),
  }) : book = Value(book),
       chapter = Value(chapter),
       at = Value(at),
       minutes = Value(minutes),
       method = Value(method);
  static Insertable<ReadingLogData> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<DateTime>? at,
    Expression<double>? minutes,
    Expression<String>? method,
    Expression<String>? details,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (at != null) 'at': at,
      if (minutes != null) 'minutes': minutes,
      if (method != null) 'method': method,
      if (details != null) 'details': details,
    });
  }

  ReadingLogCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<int>? chapter,
    Value<DateTime>? at,
    Value<double>? minutes,
    Value<String>? method,
    Value<String>? details,
  }) {
    return ReadingLogCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      at: at ?? this.at,
      minutes: minutes ?? this.minutes,
      method: method ?? this.method,
      details: details ?? this.details,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<double>(minutes.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingLogCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('at: $at, ')
          ..write('minutes: $minutes, ')
          ..write('method: $method, ')
          ..write('details: $details')
          ..write(')'))
        .toString();
  }
}

class $DayActivitiesTable extends DayActivities
    with TableInfo<$DayActivitiesTable, DayActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readMinMeta = const VerificationMeta(
    'readMin',
  );
  @override
  late final GeneratedColumn<double> readMin = GeneratedColumn<double>(
    'read_min',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _prayMinMeta = const VerificationMeta(
    'prayMin',
  );
  @override
  late final GeneratedColumn<double> prayMin = GeneratedColumn<double>(
    'pray_min',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _devocionalMeta = const VerificationMeta(
    'devocional',
  );
  @override
  late final GeneratedColumn<bool> devocional = GeneratedColumn<bool>(
    'devocional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("devocional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _porcaoCreditadaMeta = const VerificationMeta(
    'porcaoCreditada',
  );
  @override
  late final GeneratedColumn<int> porcaoCreditada = GeneratedColumn<int>(
    'porcao_creditada',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    readMin,
    prayMin,
    devocional,
    porcaoCreditada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('read_min')) {
      context.handle(
        _readMinMeta,
        readMin.isAcceptableOrUnknown(data['read_min']!, _readMinMeta),
      );
    }
    if (data.containsKey('pray_min')) {
      context.handle(
        _prayMinMeta,
        prayMin.isAcceptableOrUnknown(data['pray_min']!, _prayMinMeta),
      );
    }
    if (data.containsKey('devocional')) {
      context.handle(
        _devocionalMeta,
        devocional.isAcceptableOrUnknown(data['devocional']!, _devocionalMeta),
      );
    }
    if (data.containsKey('porcao_creditada')) {
      context.handle(
        _porcaoCreditadaMeta,
        porcaoCreditada.isAcceptableOrUnknown(
          data['porcao_creditada']!,
          _porcaoCreditadaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DayActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayActivity(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      readMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}read_min'],
      )!,
      prayMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pray_min'],
      )!,
      devocional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}devocional'],
      )!,
      porcaoCreditada: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcao_creditada'],
      )!,
    );
  }

  @override
  $DayActivitiesTable createAlias(String alias) {
    return $DayActivitiesTable(attachedDatabase, alias);
  }
}

class DayActivity extends DataClass implements Insertable<DayActivity> {
  /// Dia ISO local (aaaa-mm-dd).
  final String day;
  final double readMin;
  final double prayMin;
  final bool devocional;

  /// Orvalho já creditado neste dia (a porção é calculada de novo e só a
  /// diferença entra no livro-caixa).
  final int porcaoCreditada;
  const DayActivity({
    required this.day,
    required this.readMin,
    required this.prayMin,
    required this.devocional,
    required this.porcaoCreditada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['read_min'] = Variable<double>(readMin);
    map['pray_min'] = Variable<double>(prayMin);
    map['devocional'] = Variable<bool>(devocional);
    map['porcao_creditada'] = Variable<int>(porcaoCreditada);
    return map;
  }

  DayActivitiesCompanion toCompanion(bool nullToAbsent) {
    return DayActivitiesCompanion(
      day: Value(day),
      readMin: Value(readMin),
      prayMin: Value(prayMin),
      devocional: Value(devocional),
      porcaoCreditada: Value(porcaoCreditada),
    );
  }

  factory DayActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayActivity(
      day: serializer.fromJson<String>(json['day']),
      readMin: serializer.fromJson<double>(json['readMin']),
      prayMin: serializer.fromJson<double>(json['prayMin']),
      devocional: serializer.fromJson<bool>(json['devocional']),
      porcaoCreditada: serializer.fromJson<int>(json['porcaoCreditada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'readMin': serializer.toJson<double>(readMin),
      'prayMin': serializer.toJson<double>(prayMin),
      'devocional': serializer.toJson<bool>(devocional),
      'porcaoCreditada': serializer.toJson<int>(porcaoCreditada),
    };
  }

  DayActivity copyWith({
    String? day,
    double? readMin,
    double? prayMin,
    bool? devocional,
    int? porcaoCreditada,
  }) => DayActivity(
    day: day ?? this.day,
    readMin: readMin ?? this.readMin,
    prayMin: prayMin ?? this.prayMin,
    devocional: devocional ?? this.devocional,
    porcaoCreditada: porcaoCreditada ?? this.porcaoCreditada,
  );
  DayActivity copyWithCompanion(DayActivitiesCompanion data) {
    return DayActivity(
      day: data.day.present ? data.day.value : this.day,
      readMin: data.readMin.present ? data.readMin.value : this.readMin,
      prayMin: data.prayMin.present ? data.prayMin.value : this.prayMin,
      devocional: data.devocional.present
          ? data.devocional.value
          : this.devocional,
      porcaoCreditada: data.porcaoCreditada.present
          ? data.porcaoCreditada.value
          : this.porcaoCreditada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayActivity(')
          ..write('day: $day, ')
          ..write('readMin: $readMin, ')
          ..write('prayMin: $prayMin, ')
          ..write('devocional: $devocional, ')
          ..write('porcaoCreditada: $porcaoCreditada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(day, readMin, prayMin, devocional, porcaoCreditada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayActivity &&
          other.day == this.day &&
          other.readMin == this.readMin &&
          other.prayMin == this.prayMin &&
          other.devocional == this.devocional &&
          other.porcaoCreditada == this.porcaoCreditada);
}

class DayActivitiesCompanion extends UpdateCompanion<DayActivity> {
  final Value<String> day;
  final Value<double> readMin;
  final Value<double> prayMin;
  final Value<bool> devocional;
  final Value<int> porcaoCreditada;
  final Value<int> rowid;
  const DayActivitiesCompanion({
    this.day = const Value.absent(),
    this.readMin = const Value.absent(),
    this.prayMin = const Value.absent(),
    this.devocional = const Value.absent(),
    this.porcaoCreditada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayActivitiesCompanion.insert({
    required String day,
    this.readMin = const Value.absent(),
    this.prayMin = const Value.absent(),
    this.devocional = const Value.absent(),
    this.porcaoCreditada = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<DayActivity> custom({
    Expression<String>? day,
    Expression<double>? readMin,
    Expression<double>? prayMin,
    Expression<bool>? devocional,
    Expression<int>? porcaoCreditada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (readMin != null) 'read_min': readMin,
      if (prayMin != null) 'pray_min': prayMin,
      if (devocional != null) 'devocional': devocional,
      if (porcaoCreditada != null) 'porcao_creditada': porcaoCreditada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayActivitiesCompanion copyWith({
    Value<String>? day,
    Value<double>? readMin,
    Value<double>? prayMin,
    Value<bool>? devocional,
    Value<int>? porcaoCreditada,
    Value<int>? rowid,
  }) {
    return DayActivitiesCompanion(
      day: day ?? this.day,
      readMin: readMin ?? this.readMin,
      prayMin: prayMin ?? this.prayMin,
      devocional: devocional ?? this.devocional,
      porcaoCreditada: porcaoCreditada ?? this.porcaoCreditada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (readMin.present) {
      map['read_min'] = Variable<double>(readMin.value);
    }
    if (prayMin.present) {
      map['pray_min'] = Variable<double>(prayMin.value);
    }
    if (devocional.present) {
      map['devocional'] = Variable<bool>(devocional.value);
    }
    if (porcaoCreditada.present) {
      map['porcao_creditada'] = Variable<int>(porcaoCreditada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayActivitiesCompanion(')
          ..write('day: $day, ')
          ..write('readMin: $readMin, ')
          ..write('prayMin: $prayMin, ')
          ..write('devocional: $devocional, ')
          ..write('porcaoCreditada: $porcaoCreditada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrvalhoLedgerTable extends OrvalhoLedger
    with TableInfo<$OrvalhoLedgerTable, OrvalhoLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrvalhoLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refMeta = const VerificationMeta('ref');
  @override
  late final GeneratedColumn<String> ref = GeneratedColumn<String>(
    'ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, delta, reason, ref];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orvalho_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrvalhoLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('ref')) {
      context.handle(
        _refMeta,
        ref.isAcceptableOrUnknown(data['ref']!, _refMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrvalhoLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrvalhoLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      ref: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref'],
      ),
    );
  }

  @override
  $OrvalhoLedgerTable createAlias(String alias) {
    return $OrvalhoLedgerTable(attachedDatabase, alias);
  }
}

class OrvalhoLedgerData extends DataClass
    implements Insertable<OrvalhoLedgerData> {
  final int id;
  final DateTime at;
  final int delta;

  /// porcao | compra | pacote | presente | ajuste_dev
  final String reason;
  final String? ref;
  const OrvalhoLedgerData({
    required this.id,
    required this.at,
    required this.delta,
    required this.reason,
    this.ref,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['delta'] = Variable<int>(delta);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || ref != null) {
      map['ref'] = Variable<String>(ref);
    }
    return map;
  }

  OrvalhoLedgerCompanion toCompanion(bool nullToAbsent) {
    return OrvalhoLedgerCompanion(
      id: Value(id),
      at: Value(at),
      delta: Value(delta),
      reason: Value(reason),
      ref: ref == null && nullToAbsent ? const Value.absent() : Value(ref),
    );
  }

  factory OrvalhoLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrvalhoLedgerData(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      delta: serializer.fromJson<int>(json['delta']),
      reason: serializer.fromJson<String>(json['reason']),
      ref: serializer.fromJson<String?>(json['ref']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'delta': serializer.toJson<int>(delta),
      'reason': serializer.toJson<String>(reason),
      'ref': serializer.toJson<String?>(ref),
    };
  }

  OrvalhoLedgerData copyWith({
    int? id,
    DateTime? at,
    int? delta,
    String? reason,
    Value<String?> ref = const Value.absent(),
  }) => OrvalhoLedgerData(
    id: id ?? this.id,
    at: at ?? this.at,
    delta: delta ?? this.delta,
    reason: reason ?? this.reason,
    ref: ref.present ? ref.value : this.ref,
  );
  OrvalhoLedgerData copyWithCompanion(OrvalhoLedgerCompanion data) {
    return OrvalhoLedgerData(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      delta: data.delta.present ? data.delta.value : this.delta,
      reason: data.reason.present ? data.reason.value : this.reason,
      ref: data.ref.present ? data.ref.value : this.ref,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrvalhoLedgerData(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('ref: $ref')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, delta, reason, ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrvalhoLedgerData &&
          other.id == this.id &&
          other.at == this.at &&
          other.delta == this.delta &&
          other.reason == this.reason &&
          other.ref == this.ref);
}

class OrvalhoLedgerCompanion extends UpdateCompanion<OrvalhoLedgerData> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<int> delta;
  final Value<String> reason;
  final Value<String?> ref;
  const OrvalhoLedgerCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.delta = const Value.absent(),
    this.reason = const Value.absent(),
    this.ref = const Value.absent(),
  });
  OrvalhoLedgerCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required int delta,
    required String reason,
    this.ref = const Value.absent(),
  }) : at = Value(at),
       delta = Value(delta),
       reason = Value(reason);
  static Insertable<OrvalhoLedgerData> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<int>? delta,
    Expression<String>? reason,
    Expression<String>? ref,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (delta != null) 'delta': delta,
      if (reason != null) 'reason': reason,
      if (ref != null) 'ref': ref,
    });
  }

  OrvalhoLedgerCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<int>? delta,
    Value<String>? reason,
    Value<String?>? ref,
  }) {
    return OrvalhoLedgerCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      delta: delta ?? this.delta,
      reason: reason ?? this.reason,
      ref: ref ?? this.ref,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (ref.present) {
      map['ref'] = Variable<String>(ref.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrvalhoLedgerCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('ref: $ref')
          ..write(')'))
        .toString();
  }
}

class $OwnedItemsTable extends OwnedItems
    with TableInfo<$OwnedItemsTable, OwnedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, acquiredAt, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  OwnedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acquired_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $OwnedItemsTable createAlias(String alias) {
    return $OwnedItemsTable(attachedDatabase, alias);
  }
}

class OwnedItem extends DataClass implements Insertable<OwnedItem> {
  final String itemId;
  final DateTime acquiredAt;

  /// orvalho | gratis | pacote
  final String source;
  const OwnedItem({
    required this.itemId,
    required this.acquiredAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['acquired_at'] = Variable<DateTime>(acquiredAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  OwnedItemsCompanion toCompanion(bool nullToAbsent) {
    return OwnedItemsCompanion(
      itemId: Value(itemId),
      acquiredAt: Value(acquiredAt),
      source: Value(source),
    );
  }

  factory OwnedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      acquiredAt: serializer.fromJson<DateTime>(json['acquiredAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'acquiredAt': serializer.toJson<DateTime>(acquiredAt),
      'source': serializer.toJson<String>(source),
    };
  }

  OwnedItem copyWith({String? itemId, DateTime? acquiredAt, String? source}) =>
      OwnedItem(
        itemId: itemId ?? this.itemId,
        acquiredAt: acquiredAt ?? this.acquiredAt,
        source: source ?? this.source,
      );
  OwnedItem copyWithCompanion(OwnedItemsCompanion data) {
    return OwnedItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItem(')
          ..write('itemId: $itemId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, acquiredAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedItem &&
          other.itemId == this.itemId &&
          other.acquiredAt == this.acquiredAt &&
          other.source == this.source);
}

class OwnedItemsCompanion extends UpdateCompanion<OwnedItem> {
  final Value<String> itemId;
  final Value<DateTime> acquiredAt;
  final Value<String> source;
  final Value<int> rowid;
  const OwnedItemsCompanion({
    this.itemId = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedItemsCompanion.insert({
    required String itemId,
    required DateTime acquiredAt,
    required String source,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       acquiredAt = Value(acquiredAt),
       source = Value(source);
  static Insertable<OwnedItem> custom({
    Expression<String>? itemId,
    Expression<DateTime>? acquiredAt,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedItemsCompanion copyWith({
    Value<String>? itemId,
    Value<DateTime>? acquiredAt,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return OwnedItemsCompanion(
      itemId: itemId ?? this.itemId,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacementsTable extends Placements
    with TableInfo<$PlacementsTable, Placement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<int> x = GeneratedColumn<int>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<int> y = GeneratedColumn<int>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, book, itemId, x, y];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'placements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Placement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Placement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Placement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}y'],
      )!,
    );
  }

  @override
  $PlacementsTable createAlias(String alias) {
    return $PlacementsTable(attachedDatabase, alias);
  }
}

class Placement extends DataClass implements Insertable<Placement> {
  final int id;
  final String book;
  final String itemId;
  final int x;
  final int y;
  const Placement({
    required this.id,
    required this.book,
    required this.itemId,
    required this.x,
    required this.y,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['item_id'] = Variable<String>(itemId);
    map['x'] = Variable<int>(x);
    map['y'] = Variable<int>(y);
    return map;
  }

  PlacementsCompanion toCompanion(bool nullToAbsent) {
    return PlacementsCompanion(
      id: Value(id),
      book: Value(book),
      itemId: Value(itemId),
      x: Value(x),
      y: Value(y),
    );
  }

  factory Placement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Placement(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      itemId: serializer.fromJson<String>(json['itemId']),
      x: serializer.fromJson<int>(json['x']),
      y: serializer.fromJson<int>(json['y']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'itemId': serializer.toJson<String>(itemId),
      'x': serializer.toJson<int>(x),
      'y': serializer.toJson<int>(y),
    };
  }

  Placement copyWith({int? id, String? book, String? itemId, int? x, int? y}) =>
      Placement(
        id: id ?? this.id,
        book: book ?? this.book,
        itemId: itemId ?? this.itemId,
        x: x ?? this.x,
        y: y ?? this.y,
      );
  Placement copyWithCompanion(PlacementsCompanion data) {
    return Placement(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Placement(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('itemId: $itemId, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, book, itemId, x, y);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Placement &&
          other.id == this.id &&
          other.book == this.book &&
          other.itemId == this.itemId &&
          other.x == this.x &&
          other.y == this.y);
}

class PlacementsCompanion extends UpdateCompanion<Placement> {
  final Value<int> id;
  final Value<String> book;
  final Value<String> itemId;
  final Value<int> x;
  final Value<int> y;
  const PlacementsCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.itemId = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
  });
  PlacementsCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required String itemId,
    required int x,
    required int y,
  }) : book = Value(book),
       itemId = Value(itemId),
       x = Value(x),
       y = Value(y);
  static Insertable<Placement> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<String>? itemId,
    Expression<int>? x,
    Expression<int>? y,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (itemId != null) 'item_id': itemId,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
    });
  }

  PlacementsCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<String>? itemId,
    Value<int>? x,
    Value<int>? y,
  }) {
    return PlacementsCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      itemId: itemId ?? this.itemId,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (x.present) {
      map['x'] = Variable<int>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<int>(y.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacementsCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('itemId: $itemId, ')
          ..write('x: $x, ')
          ..write('y: $y')
          ..write(')'))
        .toString();
  }
}

class $AnimalsTable extends Animals with TableInfo<$AnimalsTable, Animal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _animalIdMeta = const VerificationMeta(
    'animalId',
  );
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
    'animal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gardenMeta = const VerificationMeta('garden');
  @override
  late final GeneratedColumn<String> garden = GeneratedColumn<String>(
    'garden',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivedAtMeta = const VerificationMeta(
    'arrivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> arrivedAt = GeneratedColumn<DateTime>(
    'arrived_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _porcoesAtArrivalMeta = const VerificationMeta(
    'porcoesAtArrival',
  );
  @override
  late final GeneratedColumn<int> porcoesAtArrival = GeneratedColumn<int>(
    'porcoes_at_arrival',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    animalId,
    garden,
    arrivedAt,
    porcoesAtArrival,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Animal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('animal_id')) {
      context.handle(
        _animalIdMeta,
        animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('garden')) {
      context.handle(
        _gardenMeta,
        garden.isAcceptableOrUnknown(data['garden']!, _gardenMeta),
      );
    } else if (isInserting) {
      context.missing(_gardenMeta);
    }
    if (data.containsKey('arrived_at')) {
      context.handle(
        _arrivedAtMeta,
        arrivedAt.isAcceptableOrUnknown(data['arrived_at']!, _arrivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_arrivedAtMeta);
    }
    if (data.containsKey('porcoes_at_arrival')) {
      context.handle(
        _porcoesAtArrivalMeta,
        porcoesAtArrival.isAcceptableOrUnknown(
          data['porcoes_at_arrival']!,
          _porcoesAtArrivalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_porcoesAtArrivalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {animalId, garden};
  @override
  Animal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Animal(
      animalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}animal_id'],
      )!,
      garden: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garden'],
      )!,
      arrivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrived_at'],
      )!,
      porcoesAtArrival: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}porcoes_at_arrival'],
      )!,
    );
  }

  @override
  $AnimalsTable createAlias(String alias) {
    return $AnimalsTable(attachedDatabase, alias);
  }
}

class Animal extends DataClass implements Insertable<Animal> {
  final String animalId;

  /// Livro do jardim, ou 'COMP' para o companheiro.
  final String garden;
  final DateTime arrivedAt;
  final int porcoesAtArrival;
  const Animal({
    required this.animalId,
    required this.garden,
    required this.arrivedAt,
    required this.porcoesAtArrival,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['animal_id'] = Variable<String>(animalId);
    map['garden'] = Variable<String>(garden);
    map['arrived_at'] = Variable<DateTime>(arrivedAt);
    map['porcoes_at_arrival'] = Variable<int>(porcoesAtArrival);
    return map;
  }

  AnimalsCompanion toCompanion(bool nullToAbsent) {
    return AnimalsCompanion(
      animalId: Value(animalId),
      garden: Value(garden),
      arrivedAt: Value(arrivedAt),
      porcoesAtArrival: Value(porcoesAtArrival),
    );
  }

  factory Animal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Animal(
      animalId: serializer.fromJson<String>(json['animalId']),
      garden: serializer.fromJson<String>(json['garden']),
      arrivedAt: serializer.fromJson<DateTime>(json['arrivedAt']),
      porcoesAtArrival: serializer.fromJson<int>(json['porcoesAtArrival']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'animalId': serializer.toJson<String>(animalId),
      'garden': serializer.toJson<String>(garden),
      'arrivedAt': serializer.toJson<DateTime>(arrivedAt),
      'porcoesAtArrival': serializer.toJson<int>(porcoesAtArrival),
    };
  }

  Animal copyWith({
    String? animalId,
    String? garden,
    DateTime? arrivedAt,
    int? porcoesAtArrival,
  }) => Animal(
    animalId: animalId ?? this.animalId,
    garden: garden ?? this.garden,
    arrivedAt: arrivedAt ?? this.arrivedAt,
    porcoesAtArrival: porcoesAtArrival ?? this.porcoesAtArrival,
  );
  Animal copyWithCompanion(AnimalsCompanion data) {
    return Animal(
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      garden: data.garden.present ? data.garden.value : this.garden,
      arrivedAt: data.arrivedAt.present ? data.arrivedAt.value : this.arrivedAt,
      porcoesAtArrival: data.porcoesAtArrival.present
          ? data.porcoesAtArrival.value
          : this.porcoesAtArrival,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Animal(')
          ..write('animalId: $animalId, ')
          ..write('garden: $garden, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('porcoesAtArrival: $porcoesAtArrival')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(animalId, garden, arrivedAt, porcoesAtArrival);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Animal &&
          other.animalId == this.animalId &&
          other.garden == this.garden &&
          other.arrivedAt == this.arrivedAt &&
          other.porcoesAtArrival == this.porcoesAtArrival);
}

class AnimalsCompanion extends UpdateCompanion<Animal> {
  final Value<String> animalId;
  final Value<String> garden;
  final Value<DateTime> arrivedAt;
  final Value<int> porcoesAtArrival;
  final Value<int> rowid;
  const AnimalsCompanion({
    this.animalId = const Value.absent(),
    this.garden = const Value.absent(),
    this.arrivedAt = const Value.absent(),
    this.porcoesAtArrival = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalsCompanion.insert({
    required String animalId,
    required String garden,
    required DateTime arrivedAt,
    required int porcoesAtArrival,
    this.rowid = const Value.absent(),
  }) : animalId = Value(animalId),
       garden = Value(garden),
       arrivedAt = Value(arrivedAt),
       porcoesAtArrival = Value(porcoesAtArrival);
  static Insertable<Animal> custom({
    Expression<String>? animalId,
    Expression<String>? garden,
    Expression<DateTime>? arrivedAt,
    Expression<int>? porcoesAtArrival,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (animalId != null) 'animal_id': animalId,
      if (garden != null) 'garden': garden,
      if (arrivedAt != null) 'arrived_at': arrivedAt,
      if (porcoesAtArrival != null) 'porcoes_at_arrival': porcoesAtArrival,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalsCompanion copyWith({
    Value<String>? animalId,
    Value<String>? garden,
    Value<DateTime>? arrivedAt,
    Value<int>? porcoesAtArrival,
    Value<int>? rowid,
  }) {
    return AnimalsCompanion(
      animalId: animalId ?? this.animalId,
      garden: garden ?? this.garden,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      porcoesAtArrival: porcoesAtArrival ?? this.porcoesAtArrival,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (garden.present) {
      map['garden'] = Variable<String>(garden.value);
    }
    if (arrivedAt.present) {
      map['arrived_at'] = Variable<DateTime>(arrivedAt.value);
    }
    if (porcoesAtArrival.present) {
      map['porcoes_at_arrival'] = Variable<int>(porcoesAtArrival.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalsCompanion(')
          ..write('animalId: $animalId, ')
          ..write('garden: $garden, ')
          ..write('arrivedAt: $arrivedAt, ')
          ..write('porcoesAtArrival: $porcoesAtArrival, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _boughtAtMeta = const VerificationMeta(
    'boughtAt',
  );
  @override
  late final GeneratedColumn<DateTime> boughtAt = GeneratedColumn<DateTime>(
    'bought_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [characterId, unlockedAt, boughtAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('bought_at')) {
      context.handle(
        _boughtAtMeta,
        boughtAt.isAcceptableOrUnknown(data['bought_at']!, _boughtAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      boughtAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bought_at'],
      ),
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final String characterId;
  final DateTime? unlockedAt;
  final DateTime? boughtAt;
  const Character({required this.characterId, this.unlockedAt, this.boughtAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    if (!nullToAbsent || boughtAt != null) {
      map['bought_at'] = Variable<DateTime>(boughtAt);
    }
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      characterId: Value(characterId),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      boughtAt: boughtAt == null && nullToAbsent
          ? const Value.absent()
          : Value(boughtAt),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      characterId: serializer.fromJson<String>(json['characterId']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      boughtAt: serializer.fromJson<DateTime?>(json['boughtAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'boughtAt': serializer.toJson<DateTime?>(boughtAt),
    };
  }

  Character copyWith({
    String? characterId,
    Value<DateTime?> unlockedAt = const Value.absent(),
    Value<DateTime?> boughtAt = const Value.absent(),
  }) => Character(
    characterId: characterId ?? this.characterId,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    boughtAt: boughtAt.present ? boughtAt.value : this.boughtAt,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      boughtAt: data.boughtAt.present ? data.boughtAt.value : this.boughtAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('characterId: $characterId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('boughtAt: $boughtAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(characterId, unlockedAt, boughtAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.characterId == this.characterId &&
          other.unlockedAt == this.unlockedAt &&
          other.boughtAt == this.boughtAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<String> characterId;
  final Value<DateTime?> unlockedAt;
  final Value<DateTime?> boughtAt;
  final Value<int> rowid;
  const CharactersCompanion({
    this.characterId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.boughtAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    required String characterId,
    this.unlockedAt = const Value.absent(),
    this.boughtAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId);
  static Insertable<Character> custom({
    Expression<String>? characterId,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? boughtAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (boughtAt != null) 'bought_at': boughtAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<String>? characterId,
    Value<DateTime?>? unlockedAt,
    Value<DateTime?>? boughtAt,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      characterId: characterId ?? this.characterId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      boughtAt: boughtAt ?? this.boughtAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (boughtAt.present) {
      map['bought_at'] = Variable<DateTime>(boughtAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('characterId: $characterId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('boughtAt: $boughtAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrayersTable extends Prayers with TableInfo<$PrayersTable, Prayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _guidedMeta = const VerificationMeta('guided');
  @override
  late final GeneratedColumn<bool> guided = GeneratedColumn<bool>(
    'guided',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("guided" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, at, minutes, guided];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('guided')) {
      context.handle(
        _guidedMeta,
        guided.isAcceptableOrUnknown(data['guided']!, _guidedMeta),
      );
    } else if (isInserting) {
      context.missing(_guidedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prayer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      guided: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}guided'],
      )!,
    );
  }

  @override
  $PrayersTable createAlias(String alias) {
    return $PrayersTable(attachedDatabase, alias);
  }
}

class Prayer extends DataClass implements Insertable<Prayer> {
  final int id;
  final DateTime at;
  final int minutes;
  final bool guided;
  const Prayer({
    required this.id,
    required this.at,
    required this.minutes,
    required this.guided,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['at'] = Variable<DateTime>(at);
    map['minutes'] = Variable<int>(minutes);
    map['guided'] = Variable<bool>(guided);
    return map;
  }

  PrayersCompanion toCompanion(bool nullToAbsent) {
    return PrayersCompanion(
      id: Value(id),
      at: Value(at),
      minutes: Value(minutes),
      guided: Value(guided),
    );
  }

  factory Prayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prayer(
      id: serializer.fromJson<int>(json['id']),
      at: serializer.fromJson<DateTime>(json['at']),
      minutes: serializer.fromJson<int>(json['minutes']),
      guided: serializer.fromJson<bool>(json['guided']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'at': serializer.toJson<DateTime>(at),
      'minutes': serializer.toJson<int>(minutes),
      'guided': serializer.toJson<bool>(guided),
    };
  }

  Prayer copyWith({int? id, DateTime? at, int? minutes, bool? guided}) =>
      Prayer(
        id: id ?? this.id,
        at: at ?? this.at,
        minutes: minutes ?? this.minutes,
        guided: guided ?? this.guided,
      );
  Prayer copyWithCompanion(PrayersCompanion data) {
    return Prayer(
      id: data.id.present ? data.id.value : this.id,
      at: data.at.present ? data.at.value : this.at,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      guided: data.guided.present ? data.guided.value : this.guided,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prayer(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('minutes: $minutes, ')
          ..write('guided: $guided')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, at, minutes, guided);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prayer &&
          other.id == this.id &&
          other.at == this.at &&
          other.minutes == this.minutes &&
          other.guided == this.guided);
}

class PrayersCompanion extends UpdateCompanion<Prayer> {
  final Value<int> id;
  final Value<DateTime> at;
  final Value<int> minutes;
  final Value<bool> guided;
  const PrayersCompanion({
    this.id = const Value.absent(),
    this.at = const Value.absent(),
    this.minutes = const Value.absent(),
    this.guided = const Value.absent(),
  });
  PrayersCompanion.insert({
    this.id = const Value.absent(),
    required DateTime at,
    required int minutes,
    required bool guided,
  }) : at = Value(at),
       minutes = Value(minutes),
       guided = Value(guided);
  static Insertable<Prayer> custom({
    Expression<int>? id,
    Expression<DateTime>? at,
    Expression<int>? minutes,
    Expression<bool>? guided,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (at != null) 'at': at,
      if (minutes != null) 'minutes': minutes,
      if (guided != null) 'guided': guided,
    });
  }

  PrayersCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? at,
    Value<int>? minutes,
    Value<bool>? guided,
  }) {
    return PrayersCompanion(
      id: id ?? this.id,
      at: at ?? this.at,
      minutes: minutes ?? this.minutes,
      guided: guided ?? this.guided,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (guided.present) {
      map['guided'] = Variable<bool>(guided.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayersCompanion(')
          ..write('id: $id, ')
          ..write('at: $at, ')
          ..write('minutes: $minutes, ')
          ..write('guided: $guided')
          ..write(')'))
        .toString();
  }
}

class $PrayerRequestsTable extends PrayerRequests
    with TableInfo<$PrayerRequestsTable, PrayerRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
    'answered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ebenezerNoteMeta = const VerificationMeta(
    'ebenezerNote',
  );
  @override
  late final GeneratedColumn<String> ebenezerNote = GeneratedColumn<String>(
    'ebenezer_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    body,
    createdAt,
    answeredAt,
    ebenezerNote,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    }
    if (data.containsKey('ebenezer_note')) {
      context.handle(
        _ebenezerNoteMeta,
        ebenezerNote.isAcceptableOrUnknown(
          data['ebenezer_note']!,
          _ebenezerNoteMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PrayerRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}answered_at'],
      ),
      ebenezerNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ebenezer_note'],
      ),
    );
  }

  @override
  $PrayerRequestsTable createAlias(String alias) {
    return $PrayerRequestsTable(attachedDatabase, alias);
  }
}

class PrayerRequest extends DataClass implements Insertable<PrayerRequest> {
  final int id;
  final String body;
  final DateTime createdAt;
  final DateTime? answeredAt;
  final String? ebenezerNote;
  const PrayerRequest({
    required this.id,
    required this.body,
    required this.createdAt,
    this.answeredAt,
    this.ebenezerNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || answeredAt != null) {
      map['answered_at'] = Variable<DateTime>(answeredAt);
    }
    if (!nullToAbsent || ebenezerNote != null) {
      map['ebenezer_note'] = Variable<String>(ebenezerNote);
    }
    return map;
  }

  PrayerRequestsCompanion toCompanion(bool nullToAbsent) {
    return PrayerRequestsCompanion(
      id: Value(id),
      body: Value(body),
      createdAt: Value(createdAt),
      answeredAt: answeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(answeredAt),
      ebenezerNote: ebenezerNote == null && nullToAbsent
          ? const Value.absent()
          : Value(ebenezerNote),
    );
  }

  factory PrayerRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerRequest(
      id: serializer.fromJson<int>(json['id']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      answeredAt: serializer.fromJson<DateTime?>(json['answeredAt']),
      ebenezerNote: serializer.fromJson<String?>(json['ebenezerNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'answeredAt': serializer.toJson<DateTime?>(answeredAt),
      'ebenezerNote': serializer.toJson<String?>(ebenezerNote),
    };
  }

  PrayerRequest copyWith({
    int? id,
    String? body,
    DateTime? createdAt,
    Value<DateTime?> answeredAt = const Value.absent(),
    Value<String?> ebenezerNote = const Value.absent(),
  }) => PrayerRequest(
    id: id ?? this.id,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    answeredAt: answeredAt.present ? answeredAt.value : this.answeredAt,
    ebenezerNote: ebenezerNote.present ? ebenezerNote.value : this.ebenezerNote,
  );
  PrayerRequest copyWithCompanion(PrayerRequestsCompanion data) {
    return PrayerRequest(
      id: data.id.present ? data.id.value : this.id,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
      ebenezerNote: data.ebenezerNote.present
          ? data.ebenezerNote.value
          : this.ebenezerNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRequest(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('ebenezerNote: $ebenezerNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, body, createdAt, answeredAt, ebenezerNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerRequest &&
          other.id == this.id &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.answeredAt == this.answeredAt &&
          other.ebenezerNote == this.ebenezerNote);
}

class PrayerRequestsCompanion extends UpdateCompanion<PrayerRequest> {
  final Value<int> id;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime?> answeredAt;
  final Value<String?> ebenezerNote;
  const PrayerRequestsCompanion({
    this.id = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.ebenezerNote = const Value.absent(),
  });
  PrayerRequestsCompanion.insert({
    this.id = const Value.absent(),
    required String body,
    required DateTime createdAt,
    this.answeredAt = const Value.absent(),
    this.ebenezerNote = const Value.absent(),
  }) : body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<PrayerRequest> custom({
    Expression<int>? id,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? answeredAt,
    Expression<String>? ebenezerNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (ebenezerNote != null) 'ebenezer_note': ebenezerNote,
    });
  }

  PrayerRequestsCompanion copyWith({
    Value<int>? id,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime?>? answeredAt,
    Value<String?>? ebenezerNote,
  }) {
    return PrayerRequestsCompanion(
      id: id ?? this.id,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      answeredAt: answeredAt ?? this.answeredAt,
      ebenezerNote: ebenezerNote ?? this.ebenezerNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (ebenezerNote.present) {
      map['ebenezer_note'] = Variable<String>(ebenezerNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerRequestsCompanion(')
          ..write('id: $id, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('ebenezerNote: $ebenezerNote')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _devotionalIdMeta = const VerificationMeta(
    'devotionalId',
  );
  @override
  late final GeneratedColumn<String> devotionalId = GeneratedColumn<String>(
    'devotional_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    devotionalId,
    body,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('devotional_id')) {
      context.handle(
        _devotionalIdMeta,
        devotionalId.isAcceptableOrUnknown(
          data['devotional_id']!,
          _devotionalIdMeta,
        ),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      devotionalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}devotional_id'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String day;
  final String? devotionalId;
  final String body;
  final DateTime createdAt;
  const JournalEntry({
    required this.id,
    required this.day,
    this.devotionalId,
    required this.body,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    if (!nullToAbsent || devotionalId != null) {
      map['devotional_id'] = Variable<String>(devotionalId);
    }
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      day: Value(day),
      devotionalId: devotionalId == null && nullToAbsent
          ? const Value.absent()
          : Value(devotionalId),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      devotionalId: serializer.fromJson<String?>(json['devotionalId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'devotionalId': serializer.toJson<String?>(devotionalId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  JournalEntry copyWith({
    int? id,
    String? day,
    Value<String?> devotionalId = const Value.absent(),
    String? body,
    DateTime? createdAt,
  }) => JournalEntry(
    id: id ?? this.id,
    day: day ?? this.day,
    devotionalId: devotionalId.present ? devotionalId.value : this.devotionalId,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      devotionalId: data.devotionalId.present
          ? data.devotionalId.value
          : this.devotionalId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('devotionalId: $devotionalId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, devotionalId, body, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.day == this.day &&
          other.devotionalId == this.devotionalId &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> day;
  final Value<String?> devotionalId;
  final Value<String> body;
  final Value<DateTime> createdAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.devotionalId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    this.devotionalId = const Value.absent(),
    required String body,
    required DateTime createdAt,
  }) : day = Value(day),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? devotionalId,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (devotionalId != null) 'devotional_id': devotionalId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String?>? devotionalId,
    Value<String>? body,
    Value<DateTime>? createdAt,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      devotionalId: devotionalId ?? this.devotionalId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (devotionalId.present) {
      map['devotional_id'] = Variable<String>(devotionalId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('devotionalId: $devotionalId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CrownStonesTable extends CrownStones
    with TableInfo<$CrownStonesTable, CrownStone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CrownStonesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, count, at];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crown_stones';
  @override
  VerificationContext validateIntegrity(
    Insertable<CrownStone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CrownStone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CrownStone(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
    );
  }

  @override
  $CrownStonesTable createAlias(String alias) {
    return $CrownStonesTable(attachedDatabase, alias);
  }
}

class CrownStone extends DataClass implements Insertable<CrownStone> {
  /// Ex.: 'canteiro:GEN:1', 'livro:RUT', 'bioma:Evangelhos', 'biblia'.
  final String id;
  final int count;
  final DateTime at;
  const CrownStone({required this.id, required this.count, required this.at});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['count'] = Variable<int>(count);
    map['at'] = Variable<DateTime>(at);
    return map;
  }

  CrownStonesCompanion toCompanion(bool nullToAbsent) {
    return CrownStonesCompanion(
      id: Value(id),
      count: Value(count),
      at: Value(at),
    );
  }

  factory CrownStone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CrownStone(
      id: serializer.fromJson<String>(json['id']),
      count: serializer.fromJson<int>(json['count']),
      at: serializer.fromJson<DateTime>(json['at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'count': serializer.toJson<int>(count),
      'at': serializer.toJson<DateTime>(at),
    };
  }

  CrownStone copyWith({String? id, int? count, DateTime? at}) => CrownStone(
    id: id ?? this.id,
    count: count ?? this.count,
    at: at ?? this.at,
  );
  CrownStone copyWithCompanion(CrownStonesCompanion data) {
    return CrownStone(
      id: data.id.present ? data.id.value : this.id,
      count: data.count.present ? data.count.value : this.count,
      at: data.at.present ? data.at.value : this.at,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CrownStone(')
          ..write('id: $id, ')
          ..write('count: $count, ')
          ..write('at: $at')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, count, at);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CrownStone &&
          other.id == this.id &&
          other.count == this.count &&
          other.at == this.at);
}

class CrownStonesCompanion extends UpdateCompanion<CrownStone> {
  final Value<String> id;
  final Value<int> count;
  final Value<DateTime> at;
  final Value<int> rowid;
  const CrownStonesCompanion({
    this.id = const Value.absent(),
    this.count = const Value.absent(),
    this.at = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CrownStonesCompanion.insert({
    required String id,
    required int count,
    required DateTime at,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       count = Value(count),
       at = Value(at);
  static Insertable<CrownStone> custom({
    Expression<String>? id,
    Expression<int>? count,
    Expression<DateTime>? at,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (count != null) 'count': count,
      if (at != null) 'at': at,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CrownStonesCompanion copyWith({
    Value<String>? id,
    Value<int>? count,
    Value<DateTime>? at,
    Value<int>? rowid,
  }) {
    return CrownStonesCompanion(
      id: id ?? this.id,
      count: count ?? this.count,
      at: at ?? this.at,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CrownStonesCompanion(')
          ..write('id: $id, ')
          ..write('count: $count, ')
          ..write('at: $at, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorePurchasesTable extends StorePurchases
    with TableInfo<$StorePurchasesTable, StorePurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorePurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atMeta = const VerificationMeta('at');
  @override
  late final GeneratedColumn<DateTime> at = GeneratedColumn<DateTime>(
    'at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    transactionId,
    productId,
    priceCents,
    currency,
    at,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorePurchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('at')) {
      context.handle(_atMeta, at.isAcceptableOrUnknown(data['at']!, _atMeta));
    } else if (isInserting) {
      context.missing(_atMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId};
  @override
  StorePurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorePurchase(
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      at: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $StorePurchasesTable createAlias(String alias) {
    return $StorePurchasesTable(attachedDatabase, alias);
  }
}

class StorePurchase extends DataClass implements Insertable<StorePurchase> {
  final String transactionId;
  final String productId;
  final int priceCents;
  final String currency;
  final DateTime at;

  /// pendente | entregue | reembolsada
  final String status;
  const StorePurchase({
    required this.transactionId,
    required this.productId,
    required this.priceCents,
    required this.currency,
    required this.at,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<String>(transactionId);
    map['product_id'] = Variable<String>(productId);
    map['price_cents'] = Variable<int>(priceCents);
    map['currency'] = Variable<String>(currency);
    map['at'] = Variable<DateTime>(at);
    map['status'] = Variable<String>(status);
    return map;
  }

  StorePurchasesCompanion toCompanion(bool nullToAbsent) {
    return StorePurchasesCompanion(
      transactionId: Value(transactionId),
      productId: Value(productId),
      priceCents: Value(priceCents),
      currency: Value(currency),
      at: Value(at),
      status: Value(status),
    );
  }

  factory StorePurchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorePurchase(
      transactionId: serializer.fromJson<String>(json['transactionId']),
      productId: serializer.fromJson<String>(json['productId']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      currency: serializer.fromJson<String>(json['currency']),
      at: serializer.fromJson<DateTime>(json['at']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<String>(transactionId),
      'productId': serializer.toJson<String>(productId),
      'priceCents': serializer.toJson<int>(priceCents),
      'currency': serializer.toJson<String>(currency),
      'at': serializer.toJson<DateTime>(at),
      'status': serializer.toJson<String>(status),
    };
  }

  StorePurchase copyWith({
    String? transactionId,
    String? productId,
    int? priceCents,
    String? currency,
    DateTime? at,
    String? status,
  }) => StorePurchase(
    transactionId: transactionId ?? this.transactionId,
    productId: productId ?? this.productId,
    priceCents: priceCents ?? this.priceCents,
    currency: currency ?? this.currency,
    at: at ?? this.at,
    status: status ?? this.status,
  );
  StorePurchase copyWithCompanion(StorePurchasesCompanion data) {
    return StorePurchase(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      currency: data.currency.present ? data.currency.value : this.currency,
      at: data.at.present ? data.at.value : this.at,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorePurchase(')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('priceCents: $priceCents, ')
          ..write('currency: $currency, ')
          ..write('at: $at, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(transactionId, productId, priceCents, currency, at, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorePurchase &&
          other.transactionId == this.transactionId &&
          other.productId == this.productId &&
          other.priceCents == this.priceCents &&
          other.currency == this.currency &&
          other.at == this.at &&
          other.status == this.status);
}

class StorePurchasesCompanion extends UpdateCompanion<StorePurchase> {
  final Value<String> transactionId;
  final Value<String> productId;
  final Value<int> priceCents;
  final Value<String> currency;
  final Value<DateTime> at;
  final Value<String> status;
  final Value<int> rowid;
  const StorePurchasesCompanion({
    this.transactionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.currency = const Value.absent(),
    this.at = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorePurchasesCompanion.insert({
    required String transactionId,
    required String productId,
    required int priceCents,
    required String currency,
    required DateTime at,
    required String status,
    this.rowid = const Value.absent(),
  }) : transactionId = Value(transactionId),
       productId = Value(productId),
       priceCents = Value(priceCents),
       currency = Value(currency),
       at = Value(at),
       status = Value(status);
  static Insertable<StorePurchase> custom({
    Expression<String>? transactionId,
    Expression<String>? productId,
    Expression<int>? priceCents,
    Expression<String>? currency,
    Expression<DateTime>? at,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (productId != null) 'product_id': productId,
      if (priceCents != null) 'price_cents': priceCents,
      if (currency != null) 'currency': currency,
      if (at != null) 'at': at,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorePurchasesCompanion copyWith({
    Value<String>? transactionId,
    Value<String>? productId,
    Value<int>? priceCents,
    Value<String>? currency,
    Value<DateTime>? at,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return StorePurchasesCompanion(
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      priceCents: priceCents ?? this.priceCents,
      currency: currency ?? this.currency,
      at: at ?? this.at,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (at.present) {
      map['at'] = Variable<DateTime>(at.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorePurchasesCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('priceCents: $priceCents, ')
          ..write('currency: $currency, ')
          ..write('at: $at, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChapterReadsTable chapterReads = $ChapterReadsTable(this);
  late final $BookCompletionsTable bookCompletions = $BookCompletionsTable(
    this,
  );
  late final $ReadingLogTable readingLog = $ReadingLogTable(this);
  late final $DayActivitiesTable dayActivities = $DayActivitiesTable(this);
  late final $OrvalhoLedgerTable orvalhoLedger = $OrvalhoLedgerTable(this);
  late final $OwnedItemsTable ownedItems = $OwnedItemsTable(this);
  late final $PlacementsTable placements = $PlacementsTable(this);
  late final $AnimalsTable animals = $AnimalsTable(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $PrayersTable prayers = $PrayersTable(this);
  late final $PrayerRequestsTable prayerRequests = $PrayerRequestsTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $CrownStonesTable crownStones = $CrownStonesTable(this);
  late final $StorePurchasesTable storePurchases = $StorePurchasesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    chapterReads,
    bookCompletions,
    readingLog,
    dayActivities,
    orvalhoLedger,
    ownedItems,
    placements,
    animals,
    characters,
    prayers,
    prayerRequests,
    journalEntries,
    crownStones,
    storePurchases,
    settings,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ChapterReadsTableCreateCompanionBuilder =
    ChapterReadsCompanion Function({
      required String book,
      required int chapter,
      required DateTime firstReadAt,
      Value<int> timesRead,
      Value<int> rowid,
    });
typedef $$ChapterReadsTableUpdateCompanionBuilder =
    ChapterReadsCompanion Function({
      Value<String> book,
      Value<int> chapter,
      Value<DateTime> firstReadAt,
      Value<int> timesRead,
      Value<int> rowid,
    });

class $$ChapterReadsTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterReadsTable> {
  $$ChapterReadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstReadAt => $composableBuilder(
    column: $table.firstReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesRead => $composableBuilder(
    column: $table.timesRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChapterReadsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterReadsTable> {
  $$ChapterReadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstReadAt => $composableBuilder(
    column: $table.firstReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesRead => $composableBuilder(
    column: $table.timesRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChapterReadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterReadsTable> {
  $$ChapterReadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<DateTime> get firstReadAt => $composableBuilder(
    column: $table.firstReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesRead =>
      $composableBuilder(column: $table.timesRead, builder: (column) => column);
}

class $$ChapterReadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChapterReadsTable,
          ChapterRead,
          $$ChapterReadsTableFilterComposer,
          $$ChapterReadsTableOrderingComposer,
          $$ChapterReadsTableAnnotationComposer,
          $$ChapterReadsTableCreateCompanionBuilder,
          $$ChapterReadsTableUpdateCompanionBuilder,
          (
            ChapterRead,
            BaseReferences<_$AppDatabase, $ChapterReadsTable, ChapterRead>,
          ),
          ChapterRead,
          PrefetchHooks Function()
        > {
  $$ChapterReadsTableTableManager(_$AppDatabase db, $ChapterReadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterReadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterReadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterReadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<DateTime> firstReadAt = const Value.absent(),
                Value<int> timesRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterReadsCompanion(
                book: book,
                chapter: chapter,
                firstReadAt: firstReadAt,
                timesRead: timesRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String book,
                required int chapter,
                required DateTime firstReadAt,
                Value<int> timesRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterReadsCompanion.insert(
                book: book,
                chapter: chapter,
                firstReadAt: firstReadAt,
                timesRead: timesRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChapterReadsTable, ChapterRead>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChapterReadsTable,
                    ChapterRead
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChapterReadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChapterReadsTable,
      ChapterRead,
      $$ChapterReadsTableFilterComposer,
      $$ChapterReadsTableOrderingComposer,
      $$ChapterReadsTableAnnotationComposer,
      $$ChapterReadsTableCreateCompanionBuilder,
      $$ChapterReadsTableUpdateCompanionBuilder,
      (
        ChapterRead,
        BaseReferences<_$AppDatabase, $ChapterReadsTable, ChapterRead>,
      ),
      ChapterRead,
      PrefetchHooks Function()
    >;
typedef $$BookCompletionsTableCreateCompanionBuilder =
    BookCompletionsCompanion Function({
      required String book,
      Value<int> completions,
      Value<int> rowid,
    });
typedef $$BookCompletionsTableUpdateCompanionBuilder =
    BookCompletionsCompanion Function({
      Value<String> book,
      Value<int> completions,
      Value<int> rowid,
    });

class $$BookCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $BookCompletionsTable> {
  $$BookCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookCompletionsTable> {
  $$BookCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookCompletionsTable> {
  $$BookCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get completions => $composableBuilder(
    column: $table.completions,
    builder: (column) => column,
  );
}

class $$BookCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookCompletionsTable,
          BookCompletion,
          $$BookCompletionsTableFilterComposer,
          $$BookCompletionsTableOrderingComposer,
          $$BookCompletionsTableAnnotationComposer,
          $$BookCompletionsTableCreateCompanionBuilder,
          $$BookCompletionsTableUpdateCompanionBuilder,
          (
            BookCompletion,
            BaseReferences<
              _$AppDatabase,
              $BookCompletionsTable,
              BookCompletion
            >,
          ),
          BookCompletion,
          PrefetchHooks Function()
        > {
  $$BookCompletionsTableTableManager(
    _$AppDatabase db,
    $BookCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> completions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookCompletionsCompanion(
                book: book,
                completions: completions,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String book,
                Value<int> completions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookCompletionsCompanion.insert(
                book: book,
                completions: completions,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookCompletionsTable, BookCompletion>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BookCompletionsTable,
                    BookCompletion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookCompletionsTable,
      BookCompletion,
      $$BookCompletionsTableFilterComposer,
      $$BookCompletionsTableOrderingComposer,
      $$BookCompletionsTableAnnotationComposer,
      $$BookCompletionsTableCreateCompanionBuilder,
      $$BookCompletionsTableUpdateCompanionBuilder,
      (
        BookCompletion,
        BaseReferences<_$AppDatabase, $BookCompletionsTable, BookCompletion>,
      ),
      BookCompletion,
      PrefetchHooks Function()
    >;
typedef $$ReadingLogTableCreateCompanionBuilder = ReadingLogCompanion Function({
  Value<int> id,
  required String book,
  required int chapter,
  required DateTime at,
  required double minutes,
  required String method,
  Value<String> details,
});
typedef $$ReadingLogTableUpdateCompanionBuilder = ReadingLogCompanion Function({
  Value<int> id,
  Value<String> book,
  Value<int> chapter,
  Value<DateTime> at,
  Value<double> minutes,
  Value<String> method,
  Value<String> details,
});

class $$ReadingLogTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingLogTable> {
  $$ReadingLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingLogTable> {
  $$ReadingLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingLogTable> {
  $$ReadingLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<double> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);
}

class $$ReadingLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingLogTable,
          ReadingLogData,
          $$ReadingLogTableFilterComposer,
          $$ReadingLogTableOrderingComposer,
          $$ReadingLogTableAnnotationComposer,
          $$ReadingLogTableCreateCompanionBuilder,
          $$ReadingLogTableUpdateCompanionBuilder,
          (
            ReadingLogData,
            BaseReferences<_$AppDatabase, $ReadingLogTable, ReadingLogData>,
          ),
          ReadingLogData,
          PrefetchHooks Function()
        > {
  $$ReadingLogTableTableManager(_$AppDatabase db, $ReadingLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<double> minutes = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> details = const Value.absent(),
              }) => ReadingLogCompanion(
                id: id,
                book: book,
                chapter: chapter,
                at: at,
                minutes: minutes,
                method: method,
                details: details,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required int chapter,
                required DateTime at,
                required double minutes,
                required String method,
                Value<String> details = const Value.absent(),
              }) => ReadingLogCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                at: at,
                minutes: minutes,
                method: method,
                details: details,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingLogTable, ReadingLogData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReadingLogTable,
                    ReadingLogData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingLogTable,
      ReadingLogData,
      $$ReadingLogTableFilterComposer,
      $$ReadingLogTableOrderingComposer,
      $$ReadingLogTableAnnotationComposer,
      $$ReadingLogTableCreateCompanionBuilder,
      $$ReadingLogTableUpdateCompanionBuilder,
      (
        ReadingLogData,
        BaseReferences<_$AppDatabase, $ReadingLogTable, ReadingLogData>,
      ),
      ReadingLogData,
      PrefetchHooks Function()
    >;
typedef $$DayActivitiesTableCreateCompanionBuilder =
    DayActivitiesCompanion Function({
      required String day,
      Value<double> readMin,
      Value<double> prayMin,
      Value<bool> devocional,
      Value<int> porcaoCreditada,
      Value<int> rowid,
    });
typedef $$DayActivitiesTableUpdateCompanionBuilder =
    DayActivitiesCompanion Function({
      Value<String> day,
      Value<double> readMin,
      Value<double> prayMin,
      Value<bool> devocional,
      Value<int> porcaoCreditada,
      Value<int> rowid,
    });

class $$DayActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get readMin => $composableBuilder(
    column: $table.readMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prayMin => $composableBuilder(
    column: $table.prayMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get devocional => $composableBuilder(
    column: $table.devocional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcaoCreditada => $composableBuilder(
    column: $table.porcaoCreditada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get readMin => $composableBuilder(
    column: $table.readMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prayMin => $composableBuilder(
    column: $table.prayMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get devocional => $composableBuilder(
    column: $table.devocional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcaoCreditada => $composableBuilder(
    column: $table.porcaoCreditada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<double> get readMin =>
      $composableBuilder(column: $table.readMin, builder: (column) => column);

  GeneratedColumn<double> get prayMin =>
      $composableBuilder(column: $table.prayMin, builder: (column) => column);

  GeneratedColumn<bool> get devocional => $composableBuilder(
    column: $table.devocional,
    builder: (column) => column,
  );

  GeneratedColumn<int> get porcaoCreditada => $composableBuilder(
    column: $table.porcaoCreditada,
    builder: (column) => column,
  );
}

class $$DayActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayActivitiesTable,
          DayActivity,
          $$DayActivitiesTableFilterComposer,
          $$DayActivitiesTableOrderingComposer,
          $$DayActivitiesTableAnnotationComposer,
          $$DayActivitiesTableCreateCompanionBuilder,
          $$DayActivitiesTableUpdateCompanionBuilder,
          (
            DayActivity,
            BaseReferences<_$AppDatabase, $DayActivitiesTable, DayActivity>,
          ),
          DayActivity,
          PrefetchHooks Function()
        > {
  $$DayActivitiesTableTableManager(_$AppDatabase db, $DayActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<double> readMin = const Value.absent(),
                Value<double> prayMin = const Value.absent(),
                Value<bool> devocional = const Value.absent(),
                Value<int> porcaoCreditada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayActivitiesCompanion(
                day: day,
                readMin: readMin,
                prayMin: prayMin,
                devocional: devocional,
                porcaoCreditada: porcaoCreditada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                Value<double> readMin = const Value.absent(),
                Value<double> prayMin = const Value.absent(),
                Value<bool> devocional = const Value.absent(),
                Value<int> porcaoCreditada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayActivitiesCompanion.insert(
                day: day,
                readMin: readMin,
                prayMin: prayMin,
                devocional: devocional,
                porcaoCreditada: porcaoCreditada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayActivitiesTable, DayActivity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DayActivitiesTable,
                    DayActivity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayActivitiesTable,
      DayActivity,
      $$DayActivitiesTableFilterComposer,
      $$DayActivitiesTableOrderingComposer,
      $$DayActivitiesTableAnnotationComposer,
      $$DayActivitiesTableCreateCompanionBuilder,
      $$DayActivitiesTableUpdateCompanionBuilder,
      (
        DayActivity,
        BaseReferences<_$AppDatabase, $DayActivitiesTable, DayActivity>,
      ),
      DayActivity,
      PrefetchHooks Function()
    >;
typedef $$OrvalhoLedgerTableCreateCompanionBuilder =
    OrvalhoLedgerCompanion Function({
      Value<int> id,
      required DateTime at,
      required int delta,
      required String reason,
      Value<String?> ref,
    });
typedef $$OrvalhoLedgerTableUpdateCompanionBuilder =
    OrvalhoLedgerCompanion Function({
      Value<int> id,
      Value<DateTime> at,
      Value<int> delta,
      Value<String> reason,
      Value<String?> ref,
    });

class $$OrvalhoLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $OrvalhoLedgerTable> {
  $$OrvalhoLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ref => $composableBuilder(
    column: $table.ref,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrvalhoLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $OrvalhoLedgerTable> {
  $$OrvalhoLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ref => $composableBuilder(
    column: $table.ref,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrvalhoLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrvalhoLedgerTable> {
  $$OrvalhoLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get ref =>
      $composableBuilder(column: $table.ref, builder: (column) => column);
}

class $$OrvalhoLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrvalhoLedgerTable,
          OrvalhoLedgerData,
          $$OrvalhoLedgerTableFilterComposer,
          $$OrvalhoLedgerTableOrderingComposer,
          $$OrvalhoLedgerTableAnnotationComposer,
          $$OrvalhoLedgerTableCreateCompanionBuilder,
          $$OrvalhoLedgerTableUpdateCompanionBuilder,
          (
            OrvalhoLedgerData,
            BaseReferences<
              _$AppDatabase,
              $OrvalhoLedgerTable,
              OrvalhoLedgerData
            >,
          ),
          OrvalhoLedgerData,
          PrefetchHooks Function()
        > {
  $$OrvalhoLedgerTableTableManager(_$AppDatabase db, $OrvalhoLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrvalhoLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrvalhoLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrvalhoLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> ref = const Value.absent(),
              }) => OrvalhoLedgerCompanion(
                id: id,
                at: at,
                delta: delta,
                reason: reason,
                ref: ref,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required int delta,
                required String reason,
                Value<String?> ref = const Value.absent(),
              }) => OrvalhoLedgerCompanion.insert(
                id: id,
                at: at,
                delta: delta,
                reason: reason,
                ref: ref,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrvalhoLedgerTable, OrvalhoLedgerData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OrvalhoLedgerTable,
                    OrvalhoLedgerData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrvalhoLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrvalhoLedgerTable,
      OrvalhoLedgerData,
      $$OrvalhoLedgerTableFilterComposer,
      $$OrvalhoLedgerTableOrderingComposer,
      $$OrvalhoLedgerTableAnnotationComposer,
      $$OrvalhoLedgerTableCreateCompanionBuilder,
      $$OrvalhoLedgerTableUpdateCompanionBuilder,
      (
        OrvalhoLedgerData,
        BaseReferences<_$AppDatabase, $OrvalhoLedgerTable, OrvalhoLedgerData>,
      ),
      OrvalhoLedgerData,
      PrefetchHooks Function()
    >;
typedef $$OwnedItemsTableCreateCompanionBuilder = OwnedItemsCompanion Function({
  required String itemId,
  required DateTime acquiredAt,
  required String source,
  Value<int> rowid,
});
typedef $$OwnedItemsTableUpdateCompanionBuilder = OwnedItemsCompanion Function({
  Value<String> itemId,
  Value<DateTime> acquiredAt,
  Value<String> source,
  Value<int> rowid,
});

class $$OwnedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$OwnedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedItemsTable,
          OwnedItem,
          $$OwnedItemsTableFilterComposer,
          $$OwnedItemsTableOrderingComposer,
          $$OwnedItemsTableAnnotationComposer,
          $$OwnedItemsTableCreateCompanionBuilder,
          $$OwnedItemsTableUpdateCompanionBuilder,
          (
            OwnedItem,
            BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>,
          ),
          OwnedItem,
          PrefetchHooks Function()
        > {
  $$OwnedItemsTableTableManager(_$AppDatabase db, $OwnedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DateTime> acquiredAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedItemsCompanion(
                itemId: itemId,
                acquiredAt: acquiredAt,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required DateTime acquiredAt,
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => OwnedItemsCompanion.insert(
                itemId: itemId,
                acquiredAt: acquiredAt,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OwnedItemsTable, OwnedItem>(table),
                  BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedItemsTable,
      OwnedItem,
      $$OwnedItemsTableFilterComposer,
      $$OwnedItemsTableOrderingComposer,
      $$OwnedItemsTableAnnotationComposer,
      $$OwnedItemsTableCreateCompanionBuilder,
      $$OwnedItemsTableUpdateCompanionBuilder,
      (OwnedItem, BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>),
      OwnedItem,
      PrefetchHooks Function()
    >;
typedef $$PlacementsTableCreateCompanionBuilder = PlacementsCompanion Function({
  Value<int> id,
  required String book,
  required String itemId,
  required int x,
  required int y,
});
typedef $$PlacementsTableUpdateCompanionBuilder = PlacementsCompanion Function({
  Value<int> id,
  Value<String> book,
  Value<String> itemId,
  Value<int> x,
  Value<int> y,
});

class $$PlacementsTableFilterComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlacementsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacementsTable> {
  $$PlacementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<int> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);
}

class $$PlacementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacementsTable,
          Placement,
          $$PlacementsTableFilterComposer,
          $$PlacementsTableOrderingComposer,
          $$PlacementsTableAnnotationComposer,
          $$PlacementsTableCreateCompanionBuilder,
          $$PlacementsTableUpdateCompanionBuilder,
          (
            Placement,
            BaseReferences<_$AppDatabase, $PlacementsTable, Placement>,
          ),
          Placement,
          PrefetchHooks Function()
        > {
  $$PlacementsTableTableManager(_$AppDatabase db, $PlacementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> x = const Value.absent(),
                Value<int> y = const Value.absent(),
              }) => PlacementsCompanion(
                id: id,
                book: book,
                itemId: itemId,
                x: x,
                y: y,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required String itemId,
                required int x,
                required int y,
              }) => PlacementsCompanion.insert(
                id: id,
                book: book,
                itemId: itemId,
                x: x,
                y: y,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacementsTable, Placement>(table),
                  BaseReferences<_$AppDatabase, $PlacementsTable, Placement>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlacementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacementsTable,
      Placement,
      $$PlacementsTableFilterComposer,
      $$PlacementsTableOrderingComposer,
      $$PlacementsTableAnnotationComposer,
      $$PlacementsTableCreateCompanionBuilder,
      $$PlacementsTableUpdateCompanionBuilder,
      (Placement, BaseReferences<_$AppDatabase, $PlacementsTable, Placement>),
      Placement,
      PrefetchHooks Function()
    >;
typedef $$AnimalsTableCreateCompanionBuilder = AnimalsCompanion Function({
  required String animalId,
  required String garden,
  required DateTime arrivedAt,
  required int porcoesAtArrival,
  Value<int> rowid,
});
typedef $$AnimalsTableUpdateCompanionBuilder = AnimalsCompanion Function({
  Value<String> animalId,
  Value<String> garden,
  Value<DateTime> arrivedAt,
  Value<int> porcoesAtArrival,
  Value<int> rowid,
});

class $$AnimalsTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garden => $composableBuilder(
    column: $table.garden,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get porcoesAtArrival => $composableBuilder(
    column: $table.porcoesAtArrival,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AnimalsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get animalId => $composableBuilder(
    column: $table.animalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garden => $composableBuilder(
    column: $table.garden,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrivedAt => $composableBuilder(
    column: $table.arrivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get porcoesAtArrival => $composableBuilder(
    column: $table.porcoesAtArrival,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get garden =>
      $composableBuilder(column: $table.garden, builder: (column) => column);

  GeneratedColumn<DateTime> get arrivedAt =>
      $composableBuilder(column: $table.arrivedAt, builder: (column) => column);

  GeneratedColumn<int> get porcoesAtArrival => $composableBuilder(
    column: $table.porcoesAtArrival,
    builder: (column) => column,
  );
}

class $$AnimalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimalsTable,
          Animal,
          $$AnimalsTableFilterComposer,
          $$AnimalsTableOrderingComposer,
          $$AnimalsTableAnnotationComposer,
          $$AnimalsTableCreateCompanionBuilder,
          $$AnimalsTableUpdateCompanionBuilder,
          (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
          Animal,
          PrefetchHooks Function()
        > {
  $$AnimalsTableTableManager(_$AppDatabase db, $AnimalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> animalId = const Value.absent(),
                Value<String> garden = const Value.absent(),
                Value<DateTime> arrivedAt = const Value.absent(),
                Value<int> porcoesAtArrival = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnimalsCompanion(
                animalId: animalId,
                garden: garden,
                arrivedAt: arrivedAt,
                porcoesAtArrival: porcoesAtArrival,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String animalId,
                required String garden,
                required DateTime arrivedAt,
                required int porcoesAtArrival,
                Value<int> rowid = const Value.absent(),
              }) => AnimalsCompanion.insert(
                animalId: animalId,
                garden: garden,
                arrivedAt: arrivedAt,
                porcoesAtArrival: porcoesAtArrival,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AnimalsTable, Animal>(table),
                  BaseReferences<_$AppDatabase, $AnimalsTable, Animal>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AnimalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimalsTable,
      Animal,
      $$AnimalsTableFilterComposer,
      $$AnimalsTableOrderingComposer,
      $$AnimalsTableAnnotationComposer,
      $$AnimalsTableCreateCompanionBuilder,
      $$AnimalsTableUpdateCompanionBuilder,
      (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
      Animal,
      PrefetchHooks Function()
    >;
typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  required String characterId,
  Value<DateTime?> unlockedAt,
  Value<DateTime?> boughtAt,
  Value<int> rowid,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<String> characterId,
  Value<DateTime?> unlockedAt,
  Value<DateTime?> boughtAt,
  Value<int> rowid,
});

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get boughtAt => $composableBuilder(
    column: $table.boughtAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get boughtAt => $composableBuilder(
    column: $table.boughtAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get boughtAt =>
      $composableBuilder(column: $table.boughtAt, builder: (column) => column);
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (
            Character,
            BaseReferences<_$AppDatabase, $CharactersTable, Character>,
          ),
          Character,
          PrefetchHooks Function()
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<DateTime?> boughtAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                characterId: characterId,
                unlockedAt: unlockedAt,
                boughtAt: boughtAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<DateTime?> boughtAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                characterId: characterId,
                unlockedAt: unlockedAt,
                boughtAt: boughtAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharactersTable, Character>(table),
                  BaseReferences<_$AppDatabase, $CharactersTable, Character>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, BaseReferences<_$AppDatabase, $CharactersTable, Character>),
      Character,
      PrefetchHooks Function()
    >;
typedef $$PrayersTableCreateCompanionBuilder = PrayersCompanion Function({
  Value<int> id,
  required DateTime at,
  required int minutes,
  required bool guided,
});
typedef $$PrayersTableUpdateCompanionBuilder = PrayersCompanion Function({
  Value<int> id,
  Value<DateTime> at,
  Value<int> minutes,
  Value<bool> guided,
});

class $$PrayersTableFilterComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get guided => $composableBuilder(
    column: $table.guided,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get guided => $composableBuilder(
    column: $table.guided,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayersTable> {
  $$PrayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<bool> get guided =>
      $composableBuilder(column: $table.guided, builder: (column) => column);
}

class $$PrayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayersTable,
          Prayer,
          $$PrayersTableFilterComposer,
          $$PrayersTableOrderingComposer,
          $$PrayersTableAnnotationComposer,
          $$PrayersTableCreateCompanionBuilder,
          $$PrayersTableUpdateCompanionBuilder,
          (Prayer, BaseReferences<_$AppDatabase, $PrayersTable, Prayer>),
          Prayer,
          PrefetchHooks Function()
        > {
  $$PrayersTableTableManager(_$AppDatabase db, $PrayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<bool> guided = const Value.absent(),
              }) => PrayersCompanion(
                id: id,
                at: at,
                minutes: minutes,
                guided: guided,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime at,
                required int minutes,
                required bool guided,
              }) => PrayersCompanion.insert(
                id: id,
                at: at,
                minutes: minutes,
                guided: guided,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayersTable, Prayer>(table),
                  BaseReferences<_$AppDatabase, $PrayersTable, Prayer>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayersTable,
      Prayer,
      $$PrayersTableFilterComposer,
      $$PrayersTableOrderingComposer,
      $$PrayersTableAnnotationComposer,
      $$PrayersTableCreateCompanionBuilder,
      $$PrayersTableUpdateCompanionBuilder,
      (Prayer, BaseReferences<_$AppDatabase, $PrayersTable, Prayer>),
      Prayer,
      PrefetchHooks Function()
    >;
typedef $$PrayerRequestsTableCreateCompanionBuilder =
    PrayerRequestsCompanion Function({
      Value<int> id,
      required String body,
      required DateTime createdAt,
      Value<DateTime?> answeredAt,
      Value<String?> ebenezerNote,
    });
typedef $$PrayerRequestsTableUpdateCompanionBuilder =
    PrayerRequestsCompanion Function({
      Value<int> id,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime?> answeredAt,
      Value<String?> ebenezerNote,
    });

class $$PrayerRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerRequestsTable> {
  $$PrayerRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ebenezerNote => $composableBuilder(
    column: $table.ebenezerNote,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerRequestsTable> {
  $$PrayerRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ebenezerNote => $composableBuilder(
    column: $table.ebenezerNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerRequestsTable> {
  $$PrayerRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ebenezerNote => $composableBuilder(
    column: $table.ebenezerNote,
    builder: (column) => column,
  );
}

class $$PrayerRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerRequestsTable,
          PrayerRequest,
          $$PrayerRequestsTableFilterComposer,
          $$PrayerRequestsTableOrderingComposer,
          $$PrayerRequestsTableAnnotationComposer,
          $$PrayerRequestsTableCreateCompanionBuilder,
          $$PrayerRequestsTableUpdateCompanionBuilder,
          (
            PrayerRequest,
            BaseReferences<_$AppDatabase, $PrayerRequestsTable, PrayerRequest>,
          ),
          PrayerRequest,
          PrefetchHooks Function()
        > {
  $$PrayerRequestsTableTableManager(
    _$AppDatabase db,
    $PrayerRequestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> answeredAt = const Value.absent(),
                Value<String?> ebenezerNote = const Value.absent(),
              }) => PrayerRequestsCompanion(
                id: id,
                body: body,
                createdAt: createdAt,
                answeredAt: answeredAt,
                ebenezerNote: ebenezerNote,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String body,
                required DateTime createdAt,
                Value<DateTime?> answeredAt = const Value.absent(),
                Value<String?> ebenezerNote = const Value.absent(),
              }) => PrayerRequestsCompanion.insert(
                id: id,
                body: body,
                createdAt: createdAt,
                answeredAt: answeredAt,
                ebenezerNote: ebenezerNote,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayerRequestsTable, PrayerRequest>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PrayerRequestsTable,
                    PrayerRequest
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerRequestsTable,
      PrayerRequest,
      $$PrayerRequestsTableFilterComposer,
      $$PrayerRequestsTableOrderingComposer,
      $$PrayerRequestsTableAnnotationComposer,
      $$PrayerRequestsTableCreateCompanionBuilder,
      $$PrayerRequestsTableUpdateCompanionBuilder,
      (
        PrayerRequest,
        BaseReferences<_$AppDatabase, $PrayerRequestsTable, PrayerRequest>,
      ),
      PrayerRequest,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required String day,
      Value<String?> devotionalId,
      required String body,
      required DateTime createdAt,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String?> devotionalId,
      Value<String> body,
      Value<DateTime> createdAt,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get devotionalId => $composableBuilder(
    column: $table.devotionalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get devotionalId => $composableBuilder(
    column: $table.devotionalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get devotionalId => $composableBuilder(
    column: $table.devotionalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String?> devotionalId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                day: day,
                devotionalId: devotionalId,
                body: body,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                Value<String?> devotionalId = const Value.absent(),
                required String body,
                required DateTime createdAt,
              }) => JournalEntriesCompanion.insert(
                id: id,
                day: day,
                devotionalId: devotionalId,
                body: body,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$JournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $JournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$CrownStonesTableCreateCompanionBuilder =
    CrownStonesCompanion Function({
      required String id,
      required int count,
      required DateTime at,
      Value<int> rowid,
    });
typedef $$CrownStonesTableUpdateCompanionBuilder =
    CrownStonesCompanion Function({
      Value<String> id,
      Value<int> count,
      Value<DateTime> at,
      Value<int> rowid,
    });

class $$CrownStonesTableFilterComposer
    extends Composer<_$AppDatabase, $CrownStonesTable> {
  $$CrownStonesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CrownStonesTableOrderingComposer
    extends Composer<_$AppDatabase, $CrownStonesTable> {
  $$CrownStonesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CrownStonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CrownStonesTable> {
  $$CrownStonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);
}

class $$CrownStonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CrownStonesTable,
          CrownStone,
          $$CrownStonesTableFilterComposer,
          $$CrownStonesTableOrderingComposer,
          $$CrownStonesTableAnnotationComposer,
          $$CrownStonesTableCreateCompanionBuilder,
          $$CrownStonesTableUpdateCompanionBuilder,
          (
            CrownStone,
            BaseReferences<_$AppDatabase, $CrownStonesTable, CrownStone>,
          ),
          CrownStone,
          PrefetchHooks Function()
        > {
  $$CrownStonesTableTableManager(_$AppDatabase db, $CrownStonesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CrownStonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CrownStonesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CrownStonesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CrownStonesCompanion(
                id: id,
                count: count,
                at: at,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int count,
                required DateTime at,
                Value<int> rowid = const Value.absent(),
              }) => CrownStonesCompanion.insert(
                id: id,
                count: count,
                at: at,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CrownStonesTable, CrownStone>(table),
                  BaseReferences<_$AppDatabase, $CrownStonesTable, CrownStone>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CrownStonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CrownStonesTable,
      CrownStone,
      $$CrownStonesTableFilterComposer,
      $$CrownStonesTableOrderingComposer,
      $$CrownStonesTableAnnotationComposer,
      $$CrownStonesTableCreateCompanionBuilder,
      $$CrownStonesTableUpdateCompanionBuilder,
      (
        CrownStone,
        BaseReferences<_$AppDatabase, $CrownStonesTable, CrownStone>,
      ),
      CrownStone,
      PrefetchHooks Function()
    >;
typedef $$StorePurchasesTableCreateCompanionBuilder =
    StorePurchasesCompanion Function({
      required String transactionId,
      required String productId,
      required int priceCents,
      required String currency,
      required DateTime at,
      required String status,
      Value<int> rowid,
    });
typedef $$StorePurchasesTableUpdateCompanionBuilder =
    StorePurchasesCompanion Function({
      Value<String> transactionId,
      Value<String> productId,
      Value<int> priceCents,
      Value<String> currency,
      Value<DateTime> at,
      Value<String> status,
      Value<int> rowid,
    });

class $$StorePurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $StorePurchasesTable> {
  $$StorePurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StorePurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $StorePurchasesTable> {
  $$StorePurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StorePurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorePurchasesTable> {
  $$StorePurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$StorePurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorePurchasesTable,
          StorePurchase,
          $$StorePurchasesTableFilterComposer,
          $$StorePurchasesTableOrderingComposer,
          $$StorePurchasesTableAnnotationComposer,
          $$StorePurchasesTableCreateCompanionBuilder,
          $$StorePurchasesTableUpdateCompanionBuilder,
          (
            StorePurchase,
            BaseReferences<_$AppDatabase, $StorePurchasesTable, StorePurchase>,
          ),
          StorePurchase,
          PrefetchHooks Function()
        > {
  $$StorePurchasesTableTableManager(
    _$AppDatabase db,
    $StorePurchasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorePurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorePurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorePurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> transactionId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorePurchasesCompanion(
                transactionId: transactionId,
                productId: productId,
                priceCents: priceCents,
                currency: currency,
                at: at,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String transactionId,
                required String productId,
                required int priceCents,
                required String currency,
                required DateTime at,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => StorePurchasesCompanion.insert(
                transactionId: transactionId,
                productId: productId,
                priceCents: priceCents,
                currency: currency,
                at: at,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StorePurchasesTable, StorePurchase>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StorePurchasesTable,
                    StorePurchase
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StorePurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorePurchasesTable,
      StorePurchase,
      $$StorePurchasesTableFilterComposer,
      $$StorePurchasesTableOrderingComposer,
      $$StorePurchasesTableAnnotationComposer,
      $$StorePurchasesTableCreateCompanionBuilder,
      $$StorePurchasesTableUpdateCompanionBuilder,
      (
        StorePurchase,
        BaseReferences<_$AppDatabase, $StorePurchasesTable, StorePurchase>,
      ),
      StorePurchase,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChapterReadsTableTableManager get chapterReads =>
      $$ChapterReadsTableTableManager(_db, _db.chapterReads);
  $$BookCompletionsTableTableManager get bookCompletions =>
      $$BookCompletionsTableTableManager(_db, _db.bookCompletions);
  $$ReadingLogTableTableManager get readingLog =>
      $$ReadingLogTableTableManager(_db, _db.readingLog);
  $$DayActivitiesTableTableManager get dayActivities =>
      $$DayActivitiesTableTableManager(_db, _db.dayActivities);
  $$OrvalhoLedgerTableTableManager get orvalhoLedger =>
      $$OrvalhoLedgerTableTableManager(_db, _db.orvalhoLedger);
  $$OwnedItemsTableTableManager get ownedItems =>
      $$OwnedItemsTableTableManager(_db, _db.ownedItems);
  $$PlacementsTableTableManager get placements =>
      $$PlacementsTableTableManager(_db, _db.placements);
  $$AnimalsTableTableManager get animals =>
      $$AnimalsTableTableManager(_db, _db.animals);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$PrayersTableTableManager get prayers =>
      $$PrayersTableTableManager(_db, _db.prayers);
  $$PrayerRequestsTableTableManager get prayerRequests =>
      $$PrayerRequestsTableTableManager(_db, _db.prayerRequests);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$CrownStonesTableTableManager get crownStones =>
      $$CrownStonesTableTableManager(_db, _db.crownStones);
  $$StorePurchasesTableTableManager get storePurchases =>
      $$StorePurchasesTableTableManager(_db, _db.storePurchases);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
